#!/bin/bash
export LS=/opt/ls

# ---------- 0. mount (your starting point, + nofail) ----------
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir -p $LS
sudo mount /dev/nvme1n1 $LS 2>/dev/null || true
grep -q "$LS" /etc/fstab || echo "UUID=$(sudo blkid -s UUID -o value /dev/nvme1n1) $LS ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
sudo chown $USER:$USER $LS

# ---------- 1. directory skeleton ----------
mkdir -p $LS/{cache,tmp,conda/pkgs,conda/envs,models,data,venvs,cargo,go,npm}
sudo mkdir -p $LS/docker
sudo chmod 1777 $LS/tmp

# ---------- 2. env redirects (covers pip, HF, uv, triton, torch, flashinfer, numba) ----------
sudo tee /etc/environment > /dev/null <<'EOF'
XDG_CACHE_HOME=/opt/ls/cache
HF_HOME=/opt/ls/cache/huggingface
PIP_CACHE_DIR=/opt/ls/cache/pip
UV_CACHE_DIR=/opt/ls/cache/uv
TORCH_EXTENSIONS_DIR=/opt/ls/cache/torch-extensions
TRITON_CACHE_DIR=/opt/ls/cache/triton
TORCHINDUCTOR_CACHE_DIR=/opt/ls/cache/torchinductor
NUMBA_CACHE_DIR=/opt/ls/cache/numba
CARGO_HOME=/opt/ls/cargo
GOPATH=/opt/ls/go
NPM_CONFIG_CACHE=/opt/ls/npm
TMPDIR=/opt/ls/tmp
EOF

rm -rf ~/.cache && ln -s $LS/cache ~/.cache


sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
  "data-root": "/opt/ls/docker",
  "log-driver": "json-file",
}
EOF