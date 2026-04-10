#!/bin/sh

# Switch dataset in the config_local.sh file by calling the desired function

#################
#   BIGANN10M   #
#################
# dataset_bigann10M() {
#   BASE_PATH=/data/datasets/BIGANN/base.10M.u8bin
#   QUERY_FILE=/data/datasets/BIGANN/query.public.10K.128.u8bin
#   GT_FILE=/data/datasets/BIGANN/bigann-10M-gt.bin 
#   PREFIX=bigann_10m
#   DATA_TYPE=uint8
#   DIST_FN=l2
#   B=0.3
#   K=10
#   DATA_DIM=128
#   DATA_N=10000000
# }

dataset_ms_marco_nomic_16() {
  DATA_DIM=16
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_gt100"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.004
  K=10
  DATA_N=1000000
}

dataset_ms_marco_nomic_32() {
  DATA_DIM=32
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_gt100"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.008
  K=10
  DATA_N=1000000
}

dataset_ms_marco_nomic_64() {
  DATA_DIM=64
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_gt100"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.016
  K=10
  DATA_N=1000000
}

dataset_ms_marco_nomic_128() {
  DATA_DIM=128
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_gt100"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.032
  K=10
  DATA_N=1000000
}

dataset_ms_marco_nomic_256() {
  DATA_DIM=256
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_gt100"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.064
  K=10
  DATA_N=1000000
}

dataset_ms_marco_nomic_512() {
  DATA_DIM=512
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_gt100"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.128
  K=10
  DATA_N=1000000
}


dataset_ms_marco_nomic_768() {
  DATA_DIM=768
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_base.fbin"
  QUERY_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_query.fbin"
  GT_FILE="${DATA_DIR}/nomic_embed_text_v1.5/msmarco_nomic_embed_text_v1.5_gt100"
  PREFIX=msmarco_nomic_768
  DATA_TYPE=float
  DIST_FN=l2
  B=0.192
  K=10
  DATA_N=1000000
}


dataset_ms_marco_mxbai_16() {
  DATA_DIM=16
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_gt100"
  PREFIX=msmarco_mxbai_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.004
  K=10
  DATA_N=1000000
}

dataset_ms_marco_mxbai_32() {
  DATA_DIM=32
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_gt100"
  PREFIX=msmarco_mxbai_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.008
  K=10
  DATA_N=1000000
}

dataset_ms_marco_mxbai_64() {
  DATA_DIM=64
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_gt100"
  PREFIX=msmarco_mxbai_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.016
  K=10
  DATA_N=1000000
}

dataset_ms_marco_mxbai_128() {
  DATA_DIM=128
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_gt100"
  PREFIX=msmarco_mxbai_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.032
  K=10
  DATA_N=1000000
}

dataset_ms_marco_mxbai_256() {
  DATA_DIM=256
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_gt100"
  PREFIX=msmarco_mxbai_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.064
  K=10
  DATA_N=1000000
}

dataset_ms_marco_mxbai_512() {
  DATA_DIM=512
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_gt100"
  PREFIX=msmarco_mxbai_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.128
  K=10
  DATA_N=1000000
}


dataset_ms_marco_mxbai_1024() {
  DATA_DIM=1024
  DATA_DIR="/nvme_data/dataset"
  BASE_PATH="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_base.fbin"
  QUERY_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_query.fbin"
  GT_FILE="${DATA_DIR}/mxbai_embed_large_v1/msmarco_mxbai_embed_large_v1_gt100"
  PREFIX=msmarco_mxbai_1024
  DATA_TYPE=float
  DIST_FN=l2
  B=0.256
  K=10
  DATA_N=1000000
}

