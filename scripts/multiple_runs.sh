#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RUN_SCRIPT="${SCRIPT_DIR}/run_benchmark.sh"

BASE_CONFIG_FILE="${BASE_CONFIG_FILE:-${SCRIPT_DIR}/config_local.sh}"
CONFIG_DATASET_FILE="${CONFIG_DATASET_FILE:-${SCRIPT_DIR}/config_dataset.sh}"

print_usage_and_exit() {
  echo "Usage: ./multiple_runs.sh [debug/release] [build/build_mem/freq/gp/search] [knn/range] [dataset_fn ...]"
  echo
  echo "Examples:"
  echo "  ./multiple_runs.sh release build dataset_ms_marco_nomic_16 dataset_ms_marco_nomic_32"
  echo "  ./multiple_runs.sh release search knn dataset_ms_marco_mxbai_256 dataset_ms_marco_mxbai_512"
  echo "  ./multiple_runs.sh release search range"
  exit 1
}

if [ "$#" -lt 2 ]; then
  print_usage_and_exit
fi

BUILD_TYPE="$1"
ACTION="$2"

if [ ! -f "$RUN_SCRIPT" ]; then
  echo "run_benchmark script not found: $RUN_SCRIPT"
  exit 1
fi

if [ ! -f "$BASE_CONFIG_FILE" ]; then
  echo "Base config file not found: $BASE_CONFIG_FILE"
  exit 1
fi

if [ ! -f "$CONFIG_DATASET_FILE" ]; then
  echo "Dataset config file not found: $CONFIG_DATASET_FILE"
  exit 1
fi

SEARCH_MODE=""
DATASET_START_ARG=3
if [ "$ACTION" = "search" ]; then
  if [ "$#" -lt 3 ]; then
    echo "search action requires third arg: knn or range"
    print_usage_and_exit
  fi
  SEARCH_MODE="$3"
  DATASET_START_ARG=4
fi

source "$CONFIG_DATASET_FILE"

DATASET_FUNCS=()
if [ "$#" -ge "$DATASET_START_ARG" ]; then
  for ((i = DATASET_START_ARG; i <= $#; i++)); do
    fn="${!i}"
    DATASET_FUNCS+=("$fn")
  done
else
  mapfile -t DATASET_FUNCS < <(
    grep -oE '^dataset_[A-Za-z0-9_]+[[:space:]]*\(\)' "$CONFIG_DATASET_FILE" \
      | sed -E 's/[[:space:]]*\(\)//' \
      | sort -u
  )
fi

if [ "${#DATASET_FUNCS[@]}" -eq 0 ]; then
  echo "No dataset function selected."
  exit 1
fi

for fn in "${DATASET_FUNCS[@]}"; do
  if ! declare -F "$fn" >/dev/null; then
    echo "Dataset function not found in config_dataset.sh: $fn"
    exit 1
  fi
done

TMP_CONFIG_DIR="${SCRIPT_DIR}/.tmp_multi_configs"
mkdir -p "$TMP_CONFIG_DIR"
trap 'rm -rf "$TMP_CONFIG_DIR"' EXIT

FAILED_DATASETS=()

for fn in "${DATASET_FUNCS[@]}"; do
  TMP_CONFIG_FILE="${TMP_CONFIG_DIR}/config_${fn}.sh"

  {
    echo "#!/bin/sh"
    echo "source \"$CONFIG_DATASET_FILE\""
    echo "$fn"
    awk '
      /^[[:space:]]*source[[:space:]]+config_dataset\.sh[[:space:]]*$/ { next }
      /^[[:space:]]*dataset_[A-Za-z0-9_]+[[:space:]]*$/ { next }
      { print }
    ' "$BASE_CONFIG_FILE"
  } > "$TMP_CONFIG_FILE"

  echo "============================================================"
  echo "Running dataset: $fn"
  echo "Config: $TMP_CONFIG_FILE"

  if [ "$ACTION" = "search" ]; then
    if ! CONFIG_FILE="$TMP_CONFIG_FILE" "$RUN_SCRIPT" "$BUILD_TYPE" "$ACTION" "$SEARCH_MODE"; then
      FAILED_DATASETS+=("$fn")
    fi
  else
    if ! CONFIG_FILE="$TMP_CONFIG_FILE" "$RUN_SCRIPT" "$BUILD_TYPE" "$ACTION"; then
      FAILED_DATASETS+=("$fn")
    fi
  fi
done

echo "============================================================"
if [ "${#FAILED_DATASETS[@]}" -eq 0 ]; then
  echo "All dataset runs completed successfully."
else
  echo "Failed datasets: ${FAILED_DATASETS[*]}"
  exit 1
fi
