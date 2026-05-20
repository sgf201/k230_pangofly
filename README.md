# K230 RTOS Only SDK 开发指南

## 概述

K230 RTOS Only SDK 是基于K230芯片和RT-Smart实时操作系统的软件开发套件，提供完整的开发环境和工具链，帮助开发者快速构建嵌入式应用。本仓库包含 Pangofly 共享内存通信库，支持跨进程通信。

## 目录结构

```
k230_pangofly/
├── boards/        # 开发板配置
├── configs/       # 编译配置
├── src/           # 源代码
│   └── rtsmart/   # RT-Smart 内核（含共享内存修复）
├── pangofly/      # Pangofly 共享内存通信库 (submodule)
│   ├── pangofly/  # 核心代码
│   ├── examples/  # 示例程序
│   └── rtos_k230/ # K230 平台适配层
└── tools/         # 工具脚本
```

### 关于 Pangofly Submodule

Pangofly 作为独立库通过 Git Submodule 方式集成。首次克隆仓库后需要初始化 submodule：

```bash
# 克隆仓库（包含 submodule）
git clone <repository-url> k230_pangofly
cd k230_pangofly

# 初始化并更新 submodule
git submodule init
git submodule update

# 或者一步完成
git clone --recurse-submodules <repository-url> k230_pangofly
```

如果已有仓库但缺少 submodule 内容：
```bash
git submodule update --init --recursive
```

更新 Pangofly 到最新版本：
```bash
cd pangofly
git checkout main
git pull origin main
cd ..
git add pangofly
git commit -m "Update pangofly submodule"
```

## 获取镜像

### 每日构建版本
- **下载地址**: [Daily Build镜像](https://kendryte-download.canaan-creative.com/developer/releases/canmv_k230_micropython/daily_build/)
- **特点**:
  - 自动构建的开发分支最新版本
  - 适合测试和尝鲜使用
  - 仅保留最新构建版本

### 稳定发布版本
- **获取方式**:
  1. 访问[嘉楠开发者社区资源中心](https://www.kendryte.com/resource)
  2. 在`K230/Images`分类中查找
  3. 下载文件名包含`RTSmart`的镜像文件（格式示例：`RtSmart_*.img.gz`）

> **注意**: 下载的镜像为gzip压缩格式，使用前需先解压

## 快速入门

### 1. 系统镜像编译指南

#### 方法一：使用Docker环境（推荐）
- 优势：环境隔离，依赖完整
- 参考文档：[BUILD编译指南](BUILD.md)

#### 方法二：本地环境编译

**系统要求**：Ubuntu 20.04/22.04 LTS（64位）

**前置条件**：确保系统已更新并安装基础依赖

```bash
# 更新系统
sudo apt-get update && sudo apt-get upgrade -y
```

**安装编译依赖**：
```bash
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

**克隆仓库**：
```bash
git clone <repository-url> k230_pangofly
cd k230_pangofly
```

**下载工具链**（约450MB，需耐心等待）：
```bash
make dl_toolchain
```

**编译步骤**：

```bash
# 1. 进入仓库目录（如果还未进入）
cd k230_pangofly

# 2. 配置编译选项（以立创开发板为例）
make k230_rtos_lckfb_defconfig

# 3. 编译镜像（-j 后接CPU核心数，建议使用全部核心）
make -j$(nproc)

# 4. 编译完成后，输出文件位于：
# output/k230_rtos_lckfb_defconfig/images/
# output/k230_rtos_lckfb_defconfig/rtsmart/
```

**支持的开发板配置**：
- `k230_rtos_lckfb_defconfig` - 立创开发板（LCKFB）
- `k230_rtos_evb_defconfig` - 官方评估板（EVB）
- `k230_canmv_lckfb_defconfig` - CanMV 立创开发板

**编译时间参考**：
- 首次编译：约30-60分钟（取决于网络和CPU性能）
- 增量编译：约5-15分钟

**常见问题排查**：

**问题1：toolchain 下载失败**
```bash
# 检查网络连接
ping -c 3 kendryte-download.canaan-creative.com

# 如果官方下载地址无法访问，可以手动下载工具链
# 工具链地址：https://kendryte-download.canaan-creative.com/k230/toolchain/
# 下载 riscv64-unknown-linux-musl-rv64imafdcv-lp64d-20230420.tar.bz2
# 解压到 ~/.kendryte/k230_toolchains/ 目录
```

**问题2：缺少依赖**
```bash
# 重新安装所有依赖
sudo apt-get install -y build-essential bison flex scons python3 lbzip2
```

**问题3：编译权限问题**
```bash
# 确保当前用户对仓库目录有读写权限
chown -R $USER:$USER k230_pangofly
```

### 2. Pangofly 编译指南

> ⚠️ **重要提示**：确保已按上文说明初始化 Pangofly submodule，否则 `pangofly/` 目录可能为空。

#### 编译 Pangofly 测试程序

```bash
# 1. 进入 Pangofly K230 适配层目录（submodule）
cd pangofly/rtos_k230

# 2. 编译（生成三个测试程序）
make

# 3. 编译完成后，生成以下 ELF 文件：
# - pangofly_writer.elf   - 消息发送进程
# - pangofly_reader.elf   - 消息接收进程  
# - pangofly_test.elf     - 多进程测试程序

# 4. 复制到开发板
# 编译后的 ELF 文件会自动复制到：
# ../../src/rtsmart/examples/elf/mpp/
```

#### 清理 Pangofly 构建产物

```bash
cd pangofly/rtos_k230
make clean
```

#### 测试 Pangofly

**方法一：使用独立进程（推荐）**

```bash
# 在开发板上执行
cd /app/examples

# 后台启动 reader
./pangofly_reader.elf &

# 等待 2 秒
sleep 2

# 启动 writer 发送消息
./pangofly_writer.elf
```

**测试结果示例**：

```
msh /sdcard>./pangofly_writer.elf 
Starting Pangofly SHM Writer... 
[INFO] Creating shm with key: d867f5e821b9528d, size: 79112, fixed_addr: 0x104d00000 
[INFO] Successfully mapped shm to fixed address: 0x104d00000 
[INFO] create shm, channel: test_channel, shm name: /pangofly_shm_335535812839717219, ceiling size: 1024 
Writer: Creating shared memory channel... 
Writer: Sent message id=0, success=1 
Reader: Received message id=0, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=1, success=1 
Reader: Received message id=1, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=2, success=1 
Reader: Received message id=2, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=3, success=1 
Reader: Received message id=3, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=4, success=1 
Reader: Received message id=4, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=5, success=1 
Reader: Received message id=5, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=6, success=1 
Reader: Received message id=6, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=7, success=1 
Reader: Received message id=7, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=8, success=1 
Reader: Received message id=8, value=3.14, name=Hello Pangofly, seq=1 
Writer: Sent message id=9, success=1 
Reader: Received message id=9, value=3.14, name=Hello Pangofly, seq=1 
Reader: All 10 messages received! 
Reader done! 
Writer: All 10 messages sent! 
Writer done!
```

**测试结果说明**：
- ✅ 共享内存创建成功，使用固定地址 `0x104d00000`
- ✅ Writer 进程成功发送 10 条消息
- ✅ Reader 进程成功接收 10 条消息
- ✅ 消息内容正确：`value=3.14, name=Hello Pangofly`
- ✅ 跨进程通信正常工作

**方法二：使用多进程测试程序**

```bash
# 在开发板上执行
cd /app/examples
./pangofly_test.elf
```

#### Pangofly 核心功能

- **跨进程共享内存通信**：支持 Writer 和 Reader 进程间的高效消息传递
- **固定地址映射**：支持使用固定虚拟地址访问共享内存
- **原子操作同步**：使用 atomic 和内存屏障确保跨进程同步

### 3. 镜像烧录方法

**Linux系统**:
```bash
# 查看磁盘设备（确保选择正确的SD卡设备）
lsblk

# 卸载SD卡分区（如果已挂载）
sudo umount /dev/sdX*

# 烧录镜像（/dev/sdX 替换为你的SD卡设备，注意：这会清除SD卡上的所有数据！）
sudo dd if=output/k230_rtos_lckfb_defconfig/images/RtSmart-K230_LCKFB_rtsmart_local_nncase_v2.11.0.img of=/dev/sdX bs=1M status=progress conv=fsync

# 同步缓存
sync
```

**Windows系统**:
- 推荐使用专业烧录工具
- 操作指南：[K230 CanMV 固件烧录教程](https://www.kendryte.com/k230_rtos/zh/main/userguide/how_to_flash.html)

## 内核修改说明

本仓库包含对 RT-Smart 内核的修改，以支持 Pangofly 共享内存通信：

1. **`src/rtsmart/rtsmart/kernel/rt-thread/components/lwp/lwp_shm.c`**
   - 新增 `_lwp_find_existing_mapping()` 函数，支持固定地址映射检测
   - 修改 `_lwp_shmat()`，支持多进程共享同一虚拟地址
   - 修改 `_lwp_shmdt()`，只有引用计数为0时才解映射

2. **`src/rtsmart/rtsmart/kernel/rt-thread/components/lwp/lwp_user_mm.c`**
   - 添加调试输出，便于追踪 mmap 操作
   - 修改 `_lwp_map_user()` 函数，自动跳过 Pangofly 预留区域

3. **`src/rtsmart/rtsmart/kernel/rt-thread/components/lwp/arch/risc-v/rv64/lwp_arch.h`**
   - 添加 Pangofly 预留区域定义和检测函数

4. **`src/rtsmart/rtsmart/kernel/rt-thread/components/lwp/Kconfig`**
   - 添加 `LWP_PANGOFLY_RESERVE_ENABLE` 配置选项
   - 添加 `LWP_PANGOFLY_RESERVE_ADDR` 预留区域起始地址配置
   - 添加 `LWP_PANGOFLY_RESERVE_SIZE` 预留区域大小配置

### Pangofly 虚拟内存预留区域

为了避免固定地址映射与自动内存分配冲突，系统支持配置专用的虚拟内存预留区域：

**配置选项**（通过 `make menuconfig` 配置）：

```
RT_USING_LWP  --->
  [*] Enable Pangofly shared memory reserved region
    (0x104D00000) Pangofly reserved region start address
    (0x1000000) Pangofly reserved region size
```

**默认配置**：
- 预留区域起始地址：`0x104D00000`
- 预留区域大小：`0x1000000` (16MB)

**工作原理**：
1. 内核在自动分配用户空间内存时，会自动跳过预留区域
2. Pangofly 使用预留区域内的固定地址进行共享内存映射
3. 预留区域对其他进程不可见，避免地址冲突

**优势**：
- ✅ 消除固定地址与自动分配的地址冲突
- ✅ 支持多个 Pangofly 通道同时使用
- ✅ 配置灵活，可根据需求调整预留区域大小
- ✅ 向后兼容，不影响现有应用

## 开发环境配置

### 设置代理（可选）

如果需要通过代理访问网络，可以设置环境变量：

```bash
# 设置代理（替换为你的代理地址）
export http_proxy=http://192.168.96.1:7890
export https_proxy=http://192.168.96.1:7890

# 写入 bashrc 使其永久生效
echo "export http_proxy=http://192.168.96.1:7890" >> ~/.bashrc
echo "export https_proxy=http://192.168.96.1:7890" >> ~/.bashrc
source ~/.bashrc
```

### 配置 Git

```bash
git config --global user.email "your.email@example.com"
git config --global user.name "Your Name"
```

## 贡献与支持

### 参与贡献
我们欢迎各种形式的贡献，包括但不限于：
- 问题反馈
- 文档改进
- 代码提交

请阅读[贡献指南](CONTRIBUTING.md)了解详细流程。

### 技术支持
**北京嘉楠捷思信息技术有限公司**  
网址:[www.kendryte.com](https://www.kendryte.com/)
技术支持邮箱：[support@canaan-creative.com](mailto:support@canaan-creative.com)  
商务合作：[salesAI@canaan-creative.com](mailto:salesAI@canaan-creative.com)

---

> **提示**：建议开发者定期关注[官方GitHub仓库](https://github.com/kendryte/k230_rtos_sdk)获取最新更新和安全补丁。