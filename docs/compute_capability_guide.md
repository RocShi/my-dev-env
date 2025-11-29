# Compute Capability 查找指南

## 什么是 Compute Capability？

**Compute Capability（计算能力）** 是 NVIDIA 为 GPU 定义的架构版本号，格式为 `x.y`（如 `6.1`、`7.5`、`8.6`）。它表示：

- GPU 的硬件架构版本
- 支持的 CUDA 功能集
- 可执行的 CUDA 指令集

不同的 compute capability 对应不同的 GPU 架构：
- **6.x**: Pascal 架构（GTX 10 系列）
- **7.x**: Volta/Turing 架构（RTX 20 系列、Titan V）
- **8.x**: Ampere 架构（RTX 30 系列、A100）
- **9.x**: Ada/Hopper 架构（RTX 40 系列、H100）

## 如何查找 GPU 的 Compute Capability

### 方法 1: NVIDIA 官方列表

访问 NVIDIA 官方文档：
- **CUDA GPUs 列表**: https://developer.nvidia.com/cuda-gpus
- 在页面中搜索您的 GPU 型号

### 方法 2: 使用 nvidia-smi 和 CUDA 工具

```bash
# 查看 GPU 信息
nvidia-smi --query-gpu=name,compute_cap --format=csv

# 或使用 CUDA 工具
/usr/local/cuda/extras/demo_suite/deviceQuery
```

### 方法 3: 在 Python 中使用 PyTorch 查询

```python
import torch

if torch.cuda.is_available():
    device = torch.cuda.current_device()
    major, minor = torch.cuda.get_device_capability(device)
    print(f"GPU: {torch.cuda.get_device_name(device)}")
    print(f"Compute Capability: {major}.{minor}")
else:
    print("CUDA not available")
```

### 方法 4: 常见 GPU 型号对照表

| GPU 型号 | Compute Capability | 架构 |
|---------|-------------------|------|
| GTX 1060 | 6.1 | Pascal |
| GTX 1070/1080 | 6.1 | Pascal |
| RTX 2060/2070/2080 | 7.5 | Turing |
| RTX 3060/3070/3080 | 8.6 | Ampere |
| RTX 4060/4070/4080/4090 | 8.9 | Ada |
| A100 | 8.0 | Ampere |
| H100 | 9.0 | Hopper |

## 如何查找 PyTorch 支持的 Compute Capability

### 方法 1: 在 Python 中查询

```python
import torch

# 查看 PyTorch 编译时支持的 GPU 架构
print("PyTorch 支持的 GPU 架构:")
print(torch.cuda.get_arch_list())

# 输出示例: ['sm_70', 'sm_75', 'sm_80', 'sm_86']
# sm_XX 表示 compute capability X.X
```

### 方法 2: 查看 PyTorch 官方文档

访问 PyTorch 官网：
- **PyTorch 安装页面**: https://pytorch.org/get-started/previous-versions/
- 查看各版本 PyTorch 支持的 CUDA 版本和 GPU 架构

### 方法 3: PyTorch 版本与 Compute Capability 支持

| PyTorch 版本 | 最低支持 | 最高支持 | 说明 |
|-------------|---------|---------|------|
| 1.13.x | sm_50 (5.0) | sm_86 (8.6) | 最后一个支持 GTX 1060 (6.1) 的版本 |
| 2.0.x | sm_70 (7.0) | sm_90 (9.0) | 不再支持 compute capability < 7.0 |
| 2.1.x | sm_70 (7.0) | sm_90 (9.0) | |
| 2.2.x+ | sm_70 (7.0) | sm_100 (10.0) | |

**重要提示**: 
- PyTorch 2.0+ **不再支持** compute capability < 7.0 的 GPU
- GTX 10 系列（compute capability 6.1）需要使用 PyTorch 1.13.x 或更早版本

## 兼容性检查

### 检查当前环境兼容性

### 常见错误

如果 GPU 和 PyTorch 不兼容，会出现以下错误：

```
CUDA error: no kernel image is available for execution on the device
```

或

```
NVIDIA GeForce GTX 1060 with CUDA capability sm_61 is not compatible 
with the current PyTorch installation.
```

## 参考资料

- [NVIDIA CUDA GPUs](https://developer.nvidia.com/cuda-gpus)
- [PyTorch Previous Versions](https://pytorch.org/get-started/previous-versions/)
- [CUDA Compute Capability](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#compute-capabilities)

