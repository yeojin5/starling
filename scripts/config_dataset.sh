#!/bin/sh

# Switch dataset in the config_local.sh file by calling the desired function

#################
#   BIGANN10M   #
#################
dataset_bigann10M() {
  BASE_PATH=/data/datasets/BIGANN/base.10M.u8bin
  QUERY_FILE=/data/datasets/BIGANN/query.public.10K.128.u8bin
  GT_FILE=/data/datasets/BIGANN/bigann-10M-gt.bin 
  PREFIX=bigann_10m
  DATA_TYPE=uint8
  DIST_FN=l2
  B=0.3
  K=10
  DATA_DIM=128
  DATA_N=10000000
}

dataset_ms_marco_16() {
  DATA_DIM=16
  DATA_DIR="$HOME/workspace/nvme_data/dataset/ms-marco_v1.1"
  BASE_PATH="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_gt100.fbin"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.004
  K=10
  DATA_N=1000000
}

dataset_ms_marco_32() {
  DATA_DIM=32
  DATA_DIR="$HOME/workspace/nvme_data/dataset/ms-marco_v1.1"
  BASE_PATH="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_gt100.fbin"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.008
  K=10
  DATA_N=1000000
}

dataset_ms_marco_64() {
  DATA_DIM=64
  DATA_DIR="$HOME/workspace/nvme_data/dataset/ms-marco_v1.1"
  BASE_PATH="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_gt100.fbin"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.016
  K=10
  DATA_N=1000000
}

dataset_ms_marco_128() {
  DATA_DIM=128
  DATA_DIR="$HOME/workspace/nvme_data/dataset/ms-marco_v1.1"
  BASE_PATH="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_gt100.fbin"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.032
  K=10
  DATA_N=1000000
}

dataset_ms_marco_256() {
  DATA_DIM=256
  DATA_DIR="$HOME/workspace/nvme_data/dataset/ms-marco_v1.1"
  BASE_PATH="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_gt100.fbin"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.064
  K=10
  DATA_N=1000000
}

dataset_ms_marco_512() {
  DATA_DIM=512
  DATA_DIR="$HOME/workspace/nvme_data/dataset/ms-marco_v1.1"
  BASE_PATH="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_base.mrl${DATA_DIM}.norm.fbin"
  QUERY_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_query.mrl${DATA_DIM}.norm.fbin"
  GT_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_gt100.fbin"
  PREFIX=msmarco_nomic_${DATA_DIM}
  DATA_TYPE=float
  DIST_FN=l2
  B=0.128
  K=10
  DATA_N=1000000
}


dataset_ms_marco_768() {
  DATA_DIM=768
  DATA_DIR="$HOME/workspace/nvme_data/dataset/ms-marco_v1.1"
  BASE_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_base.fbin"
  QUERY_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_query.fbin"
  GT_FILE="${DATA_DIR}/msmarco_nomic_embed_text_v1.5_gt100.fbin"
  PREFIX=msmarco_nomic_768
  DATA_TYPE=float
  DIST_FN=l2
  B=0.192
  K=10
  DATA_N=1000000
}
