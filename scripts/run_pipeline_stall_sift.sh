#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

BUILD_MODE="${1:-release}"   # release|debug
SEARCH_MODE="${2:-knn}"       # knn|range

if [[ "$BUILD_MODE" != "release" && "$BUILD_MODE" != "debug" ]]; then
  echo "Usage: $0 [release|debug] [knn|range]"
  exit 1
fi
if [[ "$SEARCH_MODE" != "knn" && "$SEARCH_MODE" != "range" ]]; then
  echo "Usage: $0 [release|debug] [knn|range]"
  exit 1
fi

NVME_SIFT_DIR="${NVME_SIFT_DIR:-/home/yeojinoh/workspace/nvme_data/starling/sift}"
FALLBACK_SIFT_DIR="${FALLBACK_SIFT_DIR:-/home/yeojinoh/workspace/data/sift}"

mkdir -p "$NVME_SIFT_DIR"

ensure_input_file() {
  local fname="$1"
  local dst="$NVME_SIFT_DIR/$fname"
  if [[ -f "$dst" ]]; then
    return 0
  fi

  local src="$FALLBACK_SIFT_DIR/$fname"
  if [[ -f "$src" ]]; then
    ln -sf "$src" "$dst"
    echo "[INFO] linked missing input: $dst -> $src"
    return 0
  fi

  echo "[ERROR] Missing required file: $dst"
  echo "        Also not found in fallback path: $src"
  exit 1
}

ensure_input_file "sift_base.fbin"
ensure_input_file "sift_query.fbin"
ensure_input_file "sift_query_base_gt100"

mkdir -p "$NVME_SIFT_DIR/index" "$NVME_SIFT_DIR/result"

TMP_CONFIG="$SCRIPT_DIR/.config_pipeline_stall_sift.tmp.sh"
cat > "$TMP_CONFIG" <<EOF
#!/bin/sh
BASE_PATH=$NVME_SIFT_DIR/sift_base.fbin
QUERY_FILE=$NVME_SIFT_DIR/sift_query.fbin
GT_FILE=$NVME_SIFT_DIR/sift_query_base_gt100
PREFIX=$NVME_SIFT_DIR/index/sift_base
DATA_TYPE=float
DIST_FN=l2
B=1.2
K=10
DATA_DIM=128

R=32
BUILD_L=50
M=32
BUILD_T=8

USE_SQ=0

MEM_R=32
MEM_BUILD_L=50
MEM_ALPHA=1.2
MEM_RAND_SAMPLING_RATE=0.01
MEM_USE_FREQ=0
MEM_FREQ_USE_RATE=0.01

FREQ_QUERY_FILE=\$QUERY_FILE
FREQ_QUERY_CNT=0
FREQ_BM=4
FREQ_L=100
FREQ_T=16
FREQ_CACHE=0
FREQ_MEM_L=0
FREQ_MEM_TOPK=10

GP_TIMES=16
GP_T=16
GP_LOCK_NUMS=0
GP_USE_FREQ=0
GP_CUT=4096

BM_LIST=(1 2 4 8 16)
T_LIST=(1 2 4 8 16)
CACHE=0
MEM_L=0
MEM_TOPK=3

USE_PAGE_SEARCH=1
PS_USE_RATIO=1.0

LS="100"

RADIUS=1000
RS_LS="80"
RS_ITER_KNN_TO_RANGE_SEARCH=1
KICKED_SIZE=0
RS_CUSTOM_ROUND=0
EOF

cleanup() {
  rm -f "$TMP_CONFIG"
}
trap cleanup EXIT

source "$TMP_CONFIG"
INDEX_PREFIX_PATH="${PREFIX}_M${M}_R${R}_L${BUILD_L}_B${B}/"

if [[ -z "$INDEX_PREFIX_PATH" || "$INDEX_PREFIX_PATH" == "/" ]]; then
  echo "[ERROR] Refusing to clean unsafe path: $INDEX_PREFIX_PATH"
  exit 1
fi

if [[ -d "$INDEX_PREFIX_PATH" ]]; then
  echo "[INFO] removing existing output directory: $INDEX_PREFIX_PATH"
  rm -rf "$INDEX_PREFIX_PATH"
fi

pushd "$SCRIPT_DIR" >/dev/null

run_stage() {
  local stage="$1"
  echo "[RUN] stage=$stage mode=$BUILD_MODE search=$SEARCH_MODE"
  CONFIG_FILE="$TMP_CONFIG" ./run_benchmark.sh "$BUILD_MODE" "$stage" "$SEARCH_MODE"
}

run_stage build
run_stage build_mem
run_stage gp
run_stage search

popd >/dev/null

echo "[DONE] Full pipeline finished (build -> build_mem -> gp -> search)."
echo "       Search logs are under: $NVME_SIFT_DIR/index/"
