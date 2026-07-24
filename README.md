# KVCache-SSD-Offloading-Benchmarking
Benchmarking KV Cache offloading to SSD using AMOProf

# Setting up Disk
export LS=/opt/ls
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir -p $LS
sudo mount /dev/nvme1n1 $LS 2>/dev/null || true
grep -q "$LS" /etc/fstab || echo "UUID=$(sudo blkid -s UUID -o value /dev/nvme1n1) $LS ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
sudo chown $USER:$USER $LS



# Setup VLLM server
```


```


tmux new -s vllm
nvidia