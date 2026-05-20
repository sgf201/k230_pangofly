# K230 Pangofly SDK

## 概述

K230 Pangofly SDK 是基于 K230 芯片和 RT-Smart 实时操作系统的软件开发套件，核心集成 **Pangofly 共享内存通信库**，提供高效的跨进程通信能力。

**Pangofly** 是一个高性能的共享内存通信库，支持：
- ✅ 跨进程消息传递
- ✅ 固定地址映射
- ✅ Non-POD 类型支持（Vector、String）
- ✅ 原子操作同步

---

## 快速开始

### 克隆仓库

```bash
# 克隆主仓库（包含 Pangofly submodule）
git clone --recurse-submodules https://github.com/sgf201/k230_pangofly.git
cd k230_pangofly
```

如果已有仓库但缺少 submodule：
```bash
git submodule update --init --recursive
```

---

## Pangofly 共享内存通信

### 核心功能

| 功能 | 描述 |
|------|------|
| **跨进程通信** | Writer 和 Reader 进程间高效消息传递 |
| **固定地址映射** | 使用固定虚拟地址访问共享内存 |
| **Non-POD 支持** | 支持 `pangofly::Vector<T>` 和 `pangofly::String` |
| **虚拟内存预留** | 256MB 专用共享内存区域 |
| **原子同步** | 使用 atomic 和内存屏障确保同步 |

### 编译 Pangofly

```bash
# 编译 K230 平台测试程序
cd pangofly/rtos_k230
make

# 编译 x86 平台测试程序（需要 CMake）
cd pangofly
mkdir -p build && cd build
cmake ..
make pangofly_nonpod_test
```

### 测试 Pangofly

**K230 平台**：
```bash
# 在开发板上执行
msh /sdcard> ./pangofly_writer.elf &
msh /sdcard> ./pangofly_reader.elf
```

**x86 平台**：
```bash
LD_LIBRARY_PATH=. ./pangofly_nonpod_test
```

### 测试结果示例

```
[INFO] Creating shm with key: d867f5e821b9528d, size: 79112
[INFO] Successfully mapped shm to fixed address: 0x104d00000
Writer: Sent message id=0, success=1
Reader: Received message id=0, value=3.14, name=Hello Pangofly
```

### Non-POD 数据类型

Pangofly 支持复杂数据类型：

```cpp
struct FaceDetectionResult {
    int32_t id;
    float score;
    pangofly::String name;           // 可变长度字符串
    pangofly::Vector<int32_t> landmarks;  // 动态数组
};
```

### 虚拟内存预留区域

通过 `make menuconfig` 配置：

```
RT_USING_LWP  --->
  [*] Enable Pangofly shared memory reserved region
    (0x120000000) Start address
    (0x80000000) Size (256MB)
```

---

## 目录结构

```
k230_pangofly/
├── pangofly/          # Pangofly 共享内存通信库 (submodule)
│   ├── pangofly/      # 核心代码
│   ├── examples/      # 示例程序
│   ├── rtos_k230/     # K230 平台适配
│   ├── idl/           # IDL 定义和容器类
│   └── test/          # 单元测试
├── src/               # RT-Smart 内核源代码
│   └── rtsmart/       # 含共享内存修复
├── configs/           # 编译配置
├── boards/            # 开发板配置
└── tools/             # 工具脚本
```

---

## 更新 Pangofly Submodule

```bash
cd pangofly
git checkout main
git pull origin main
cd ..
git add pangofly
git commit -m "Update pangofly submodule"
git push
```

---

---

## SDK 编译指南

> 以下为 K230 RT-Smart SDK 原有编译说明，供参考

### 系统要求

- Ubuntu 20.04/22.04 LTS（64位）
- 至少 16GB 内存
- 至少 50GB 磁盘空间

### 安装依赖

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
    build-essential \
    bison \
    flex \
    scons \
    python3 \
    python3-pip \
    lbzip2 \
    git
```

### 下载工具链

```bash
make dl_toolchain
```

### 编译系统镜像

```bash
# 配置编译选项（立创开发板）
make k230_rtos_lckfb_defconfig

# 编译
make -j$(nproc)

# 输出位置
# output/k230_rtos_lckfb_defconfig/images/
# output/k230_rtos_lckfb_defconfig/rtsmart/
```

### 支持的开发板

| 配置 | 描述 |
|------|------|
| `k230_rtos_lckfb_defconfig` | 立创开发板 |
| `k230_rtos_evb_defconfig` | 官方评估板 |
| `k230_canmv_lckfb_defconfig` | CanMV 立创开发板 |

---

## 镜像烧录

### Linux 系统

```bash
lsblk                                    # 查看设备
sudo umount /dev/sdX*                    # 卸载分区
sudo dd if=output/.../RtSmart-*.img of=/dev/sdX bs=1M status=progress conv=fsync
sync
```

### Windows 系统

参考：[K230 CanMV 固件烧录教程](https://www.kendryte.com/k230_rtos/zh/main/userguide/how_to_flash.html)

---

## 获取预构建镜像

### 每日构建版本
- [Daily Build 镜像](https://kendryte-download.canaan-creative.com/developer/releases/canmv_k230_micropython/daily_build/)

### 稳定发布版本
- 访问 [嘉楠开发者社区资源中心](https://www.kendryte.com/resource)
- 在 `K230/Images` 分类中查找 `RtSmart_*.img.gz`

---

## 内核修改说明

本仓库包含对 RT-Smart 内核的修改以支持 Pangofly：

1. **`src/rtsmart/.../lwp_shm.c`** - 固定地址映射支持
2. **`src/rtsmart/.../lwp_user_mm.c`** - 预留区域跳过逻辑
3. **`src/rtsmart/.../lwp_arch.h`** - 预留区域定义
4. **`src/rtsmart/.../Kconfig`** - 配置选项

---

## 开发环境配置

### 代理设置

```bash
export http_proxy=http://your-proxy:port
export https_proxy=http://your-proxy:port
```

### Git 配置

```bash
git config --global user.email "your.email@example.com"
git config --global user.name "Your Name"
```

---

## 贡献与支持

- **技术支持邮箱**: support@canaan-creative.com
- **官方文档**: [K230 RT-Smart 文档中心](https://www.kendryte.com/k230_rtos)

---

> **提示**：建议定期关注 [官方 GitHub 仓库](https://github.com/kendryte/k230_rtos_sdk) 获取最新更新。
