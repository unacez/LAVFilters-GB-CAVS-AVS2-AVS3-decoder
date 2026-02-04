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

项目已配置 GitHub Actions 工作流，位于 `.github/workflows/build.yml`。工作流包含以下特性：

1. **多架构支持**：同时构建 32 位 (x86) 和 64 位 (x64) 版本
2. **跨平台编译**：使用 MinGW-w64 进行交叉编译
3. **自动化流程**：自动触发于推送和拉取请求事件
4. **制品管理**：自动打包并上传构建产物

工作流执行步骤：
1. 设置 MinGW-w64 交叉编译环境
2. 安装必要依赖（GCC、YASM、make 等）
3. 配置 Visual Studio 开发环境
4. 准备目录结构
5. 构建对应架构的 FFmpeg 库
6. 使用 MSBuild 构建 LAV Filters
7. 打包并上传构建产物

## 关键修复

修复了原始构建流程中的问题：
- 原始流程直接构建 LAV Filters 而没有先构建 FFmpeg
- 导致 `libavutil/avconfig.h` 等必需的头文件缺失
- 修复了 GitHub Actions 中的 artifact 路径配置，确保在不同平台上正确上传和下载构建产物
- 更新了 GitHub Actions 中使用的 action 版本，使用较新的 v4 版本的 upload-artifact 和 download-artifact
- 现在确保构建顺序正确，避免此类错误

## 依赖项

构建前确保安装了以下工具：
- Visual Studio 2019 或更高版本
- MSBuild
- NuGet
- YASM 汇编器
- Windows SDK
- MinGW-w64 (用于交叉编译)
- Git (用于子模块)

## 构建注意事项

- 构建顺序很重要：必须先构建 FFmpeg，再构建 libbluray，最后构建 LAV Filters
- libbluray 项目需要 config.h 文件，该文件位于 libbluray 根目录
- 在某些构建环境中，可能需要确保 $(ProjectDir) 正确指向包含 config.h 的目录