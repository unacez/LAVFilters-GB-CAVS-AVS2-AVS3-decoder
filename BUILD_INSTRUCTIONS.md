# LAV Filters 构建说明

## 构建流程概述

LAV Filters 项目的构建需要两个主要步骤：
1. 首先构建 FFmpeg 库（生成必要的头文件，如 `avconfig.h`）
2. 然后构建 LAV Filters 主项目

## 本地构建

### Windows (使用 Visual Studio)

要完整构建项目，请按以下顺序执行：

```batch
# 构建 FFmpeg (32位)
sh build_ffmpeg_msvc.sh x86

# 构建 FFmpeg (64位)
sh build_ffmpeg_msvc.sh x64

# 或者使用批处理文件一次性构建所有架构
build.bat
```

### Linux/macOS (交叉编译 Windows 版本)

```bash
# 构建 32 位 FFmpeg
sh build_ffmpeg_avs23_x86.sh

# 构建 64 位 FFmpeg
sh build_ffmpeg_avs23_x64.sh
```

## GitHub Actions 构建

更新后的工作流文件现在正确地：

1. 先构建 FFmpeg 库（包括 32 位和 64 位版本）
2. 然后使用这些库来构建 LAV Filters
3. 最终打包包含两个架构的发布版本

## 关键修复

修复了原始构建流程中的问题：
- 原始流程直接构建 LAV Filters 而没有先构建 FFmpeg
- 导致 `libavutil/avconfig.h` 等必需的头文件缺失
- 现在确保构建顺序正确，避免此类错误

## 依赖项

构建前确保安装了以下工具：
- Visual Studio 2019 或更高版本
- MSBuild
- NuGet
- YASM 汇编器
- Windows SDK