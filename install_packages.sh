
# Install and run code-server in tmux
mkdir -p $LS/code-server
cd $LS/code-server
curl -fL -o code-server.tar.gz \
  https://github.com/coder/code-server/releases/download/v4.129.0/code-server-4.129.0-linux-amd64.tar.gz
tar -xzf code-server.tar.gz --strip-components=1
tmux new -s code-server
$LS/code-server/bin/code-server --bind-addr 127.0.0.1:8080
# Detach ctrl+b and d

# Get password for code-server
cat /home/ubuntu/.config/code-server/config.yaml | grep password:
# 5f4f9151d419f0a107f4ac13

# Install nvidia driver
sudo apt update
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers devices
sudo ubuntu-drivers autoinstall
sudo reboot
sudo apt install nvidia-cuda-toolkit

