#!/usr/bin/env bash
set -euo pipefail
cd "$LS/vllm"
source .venv/bin/activate

unset CUDA_VISIBLE_DEVICES
unset VLLM_ATTENTION_BACKEND
export LMCACHE_CONFIG_FILE="$LS/vllm/lmcache_disk_config.yaml"
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
export PYTHONHASHSEED=0
export VLLM_CACHE_ROOT=$LS/vllm-cache


if pgrep -f "vllm serve" > /dev/null; then
  echo "ERROR: vllm serve already running. Kill it first: pkill -9 -f 'vllm serve'"
  exit 1
fi

vllm serve Qwen/Qwen3-8B-AWQ \
  --dtype float16 \
  --tensor-parallel-size 1 \
  --max-model-len 16384 \
  --gpu-memory-utilization 0.7 \
  --no-enable-prefix-caching \
  --kv-transfer-config '{"kv_connector":"LMCacheConnectorV1", "kv_role":"kv_both"}' \
  --port 8000 2>&1 | tee vllm_server.log