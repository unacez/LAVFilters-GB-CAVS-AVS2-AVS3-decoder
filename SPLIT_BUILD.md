# LAV Filters 分步构建指南

## 概述

LAV Filters 项目的构建过程可以分为三个主要阶段，每个阶段都有其特定的目的和依赖关系。

## 构建阶段

### 阶段 1: FFmpeg 库构建
- **目的**: 构建核心音视频编解码库
- **输出**: FFmpeg 头文件和库文件
- **依赖**: MinGW-w64 编译器、YASM 汇编器等工具
- **命令示例**:
  ```bash
  # 构建 32 位
  ./build_ffmpeg.sh x86
  
  # 构建 64 位
  ./build_ffmpeg.sh x64
  ```

### 阶段 2: libbluray 库构建
- **目的**: 构建 Blu-ray 播放支持库
- **依赖**: 阶段 1 的 FFmpeg 库
- **输出**: libbluray.dll 和相关库文件
- **命令示例**:
  ```bash
  cd libbluray
  msbuild libbluray.vcxproj /p:Configuration=Release /p:Platform=Win32
  cd ..
  ```
- **注意**: libbluray 目录应该包含一个完整的、配置好的 libbluray 仓库，可以从 `https://gitea.1f0.de/dekkers/libbluray.git` 获取

### 阶段 3: LAV Filters 主程序构建
- **目的**: 构建 LAV Filters 主程序
- **依赖**: 阶段 1 和阶段 2 的所有输出
- **输出**: LAV Splitter、LAV Audio、LAV Video 等滤镜
- **命令示例**:
  ```bash
  msbuild LAVFilters.sln /m /t:Rebuild /property:Configuration=Release,Platform=Win32
  ```

## 分步构建的优势

1. **故障隔离**: 单个阶段的失败不会影响其他阶段
2. **增量构建**: 只需重新构建受影响的阶段
3. **并行构建**: 不同架构可以并行构建
4. **调试便利**: 更容易定位问题所在阶段

## GitHub Actions 中的实现

在 GitHub Actions 中，这三个阶段被实现为相互依赖的作业：
- `build-ffmpeg` 作业负责构建 FFmpeg
- `build-libbluray` 作业依赖于 `build-ffmpeg` 的成果
- `build-lavfilters` 作业依赖于前两个作业的成果
- `package` 作业收集所有构建产物

这种设计确保了构建的可重现性和可靠性。