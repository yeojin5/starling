// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

#include "aux_utils.h"

#define READ_SECTOR_LEN (size_t) 4096
#define READ_SECTOR_OFFSET(node_id)                                            \
  ((_u64) node_id / nnodes_per_sector + 1) * READ_SECTOR_LEN +                 \
      ((_u64) node_id % nnodes_per_sector) * max_node_len

static std::string default_output_path(const std::string &partition_path,
                                       uint32_t slice_dim) {
  std::string base_path = partition_path;
  auto dot_pos = base_path.find_last_of('.');
  if (dot_pos != std::string::npos) {
    base_path = base_path.substr(0, dot_pos);
  }
  return base_path + "_slice" + std::to_string(slice_dim) + ".index";
}

static void slice_relayout(const std::string &indexname,
                           const std::string &partition_name,
                           uint32_t slice_dim,
                           const std::string &output_index_name) {
  _u64 C = 0;
  _u64 partition_nums = 0;
  _u64 nd = 0;
  std::vector<std::vector<unsigned>> layout;

  std::ifstream part(partition_name, std::ios::binary);
  if (!part) {
    std::cerr << "Failed to open partition file: " << partition_name << std::endl;
    std::exit(-1);
  }

  part.read((char *) &C, sizeof(_u64));
  part.read((char *) &partition_nums, sizeof(_u64));
  part.read((char *) &nd, sizeof(_u64));
  std::cout << "C: " << C << " partition_nums: " << partition_nums
            << " nd: " << nd << std::endl;

  auto meta_pair = diskann::get_disk_index_meta(indexname);
  _u64 actual_index_size = get_file_size(indexname);
  _u64 expected_file_size = 0;
  _u64 expected_npts = 0;

  if (meta_pair.first) {
    expected_file_size = meta_pair.second.back();
    expected_npts = meta_pair.second.front();
  } else {
    expected_file_size = meta_pair.second.front();
    expected_npts = meta_pair.second[1];
  }

  if (expected_file_size != actual_index_size) {
    diskann::cout << "File size mismatch for " << indexname
                  << " (size: " << actual_index_size << ")"
                  << " with meta-data size: " << expected_file_size << std::endl;
    std::exit(-1);
  }
  if (expected_npts != nd) {
    diskann::cout << "expect nd: " << nd << " actual nd: " << expected_npts
                  << std::endl;
    std::exit(-1);
  }

  const _u64 dims = meta_pair.second[1];
  const _u64 max_node_len = meta_pair.second[3];
  const unsigned nnodes_per_sector = static_cast<unsigned>(meta_pair.second[4]);
  const _u64 full_vec_bytes = dims * sizeof(float);

  if (slice_dim == 0 || slice_dim > dims) {
    std::cerr << "slice_dim must be in the range [1, " << dims << "]" << std::endl;
    std::exit(-1);
  }
  if (max_node_len < full_vec_bytes) {
    std::cerr << "Invalid index metadata: node length is smaller than the vector payload"
              << std::endl;
    std::exit(-1);
  }
  if (C != nnodes_per_sector) {
    std::cerr << "Partition file and index metadata disagree on nodes per sector: "
              << C << " vs " << nnodes_per_sector << std::endl;
    std::exit(-1);
  }

  layout.resize(partition_nums);
  for (unsigned i = 0; i < partition_nums; i++) {
    unsigned s = 0;
    part.read((char *) &s, sizeof(unsigned));
    layout[i].resize(s);
    part.read((char *) layout[i].data(), sizeof(unsigned) * s);
  }
  part.close();

  const _u64 sliced_vec_bytes = slice_dim * sizeof(float);
  const _u64 adj_bytes = max_node_len - full_vec_bytes;
  const _u64 new_max_node_len = sliced_vec_bytes + adj_bytes;
  if (new_max_node_len > max_node_len) {
    std::cerr << "Unexpected sliced node length larger than the original length"
              << std::endl;
    std::exit(-1);
  }

  const _u64 file_size = READ_SECTOR_LEN + READ_SECTOR_LEN * partition_nums;
  std::unique_ptr<char[]> mem_index = std::make_unique<char[]>(actual_index_size);
  std::ifstream diskann_reader(indexname, std::ios::binary);
  if (!diskann_reader) {
    std::cerr << "Failed to open index file: " << indexname << std::endl;
    std::exit(-1);
  }
  diskann_reader.read(mem_index.get(), actual_index_size);
  diskann_reader.close();

  std::unique_ptr<char[]> new_mem_index = std::make_unique<char[]>(file_size);
  std::memcpy(new_mem_index.get(), mem_index.get(), READ_SECTOR_LEN);

  if (meta_pair.first) {
    char *meta_buf = new_mem_index.get() + 2 * sizeof(int);
    *(reinterpret_cast<_u64 *>(meta_buf + 3 * sizeof(_u64))) = new_max_node_len;
    *(reinterpret_cast<_u64 *>(meta_buf + 4 * sizeof(_u64))) = C;
    *(reinterpret_cast<_u64 *>(meta_buf + (meta_pair.second.size() - 1) * sizeof(_u64))) =
        file_size;
  } else {
    _u64 *meta_buf = reinterpret_cast<_u64 *>(new_mem_index.get());
    *meta_buf = file_size;
    *(meta_buf + 3) = new_max_node_len;
    *(meta_buf + 4) = C;
  }

  std::unique_ptr<char[]> sector_buf = std::make_unique<char[]>(READ_SECTOR_LEN);

  for (unsigned i = 0; i < partition_nums; i++) {
    if (i % 100000 == 0) {
      diskann::cout << "relayout has done " << (float) i / partition_nums
                    << std::endl;
      diskann::cout.flush();
    }

    std::memset(sector_buf.get(), 0, READ_SECTOR_LEN);
    if (layout[i].size() * new_max_node_len > READ_SECTOR_LEN) {
      std::cerr << "Partition " << i << " does not fit into one sector after slicing"
                << std::endl;
      std::exit(-1);
    }

    for (unsigned j = 0; j < layout[i].size(); j++) {
      unsigned id = layout[i][j];
      const _u64 index_offset = READ_SECTOR_OFFSET(id);
      const _u64 buf_offset = static_cast<_u64>(j) * new_max_node_len;

      const char *src_node = mem_index.get() + index_offset;
      char *dst_node = sector_buf.get() + buf_offset;
      std::memcpy(dst_node, src_node, sliced_vec_bytes);
      std::memcpy(dst_node + sliced_vec_bytes,
                  src_node + full_vec_bytes,
                  adj_bytes);
    }

    std::memcpy(new_mem_index.get() + READ_SECTOR_LEN * (i + 1),
                sector_buf.get(),
                READ_SECTOR_LEN);
  }

  std::ofstream writer(output_index_name, std::ios::binary | std::ios::trunc);
  if (!writer) {
    std::cerr << "Failed to open output index file: " << output_index_name << std::endl;
    std::exit(-1);
  }
  writer.write(new_mem_index.get(), file_size);
  writer.close();

  diskann::cout << "Sliced and relayouted index written to " << output_index_name
                << std::endl;
  diskann::cout << "slice_dim: " << slice_dim << ", full_dim: " << dims
                << ", new_max_node_len: " << new_max_node_len << std::endl;
}

int main(int argc, char **argv) {
  if (argc < 4) {
    std::cout << "Usage: slice_relayout <index_file> <partition_file> <slice_dim> [output_index_file]"
              << std::endl;
    return -1;
  }

  const std::string index_name(argv[1]);
  const std::string partition_name(argv[2]);
  const uint32_t slice_dim = static_cast<uint32_t>(std::stoul(argv[3]));
  const std::string output_index_name =
      argc >= 5 ? std::string(argv[4]) : default_output_path(partition_name, slice_dim);

  slice_relayout(index_name, partition_name, slice_dim, output_index_name);
  return 0;
}