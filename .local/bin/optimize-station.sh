#!/bin/bash
# --- Station Optimization Script (Lead Architect Edition) ---
# Purpose: Maintain peak performance on 4GB RAM station.

echo "--- 🚀 Starting Station Optimization ---"

# 1. Sysctl Tuning (Requires sudo)
echo "[1/4] Applying Kernel Optimizations..."
sudo sysctl -w vm.vfs_cache_pressure=125
sudo sysctl -w vm.swappiness=180
sudo sysctl -w vm.dirty_ratio=10
sudo sysctl -w vm.dirty_background_ratio=5

# 2. Memory Purge
echo "[2/4] Purging Caches and Reclaiming Memory..."
sudo sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
# Swapoff -a is risky on 4GB; just swapoff the swapfile to keep zram or restore it.
sudo swapoff -a && sudo swapon -a
# Ensure zram is re-triggered if using zram-generator
sudo systemctl daemon-reload && sudo systemctl restart systemd-zram-setup@zram0.service || sudo zramctl --size 4G --algorithm zstd && sudo mkswap /dev/zram0 && sudo swapon /dev/zram0 -p 100

# 3. Process Cleanup
echo "[3/4] Cleaning up orphaned processes..."
# Kill any defunct processes if they exist
ps aux | grep '<defunct>' | grep -v grep | awk '{print $2}' | xargs -r sudo kill -9

# 4. Storage Maintenance
echo "[4/4] Trimming SSD and cleaning logs..."
sudo fstrim -va
sudo journalctl --vacuum-time=2d

echo "--- ✅ Optimization Complete. Station is Lean and Mean. ---"
