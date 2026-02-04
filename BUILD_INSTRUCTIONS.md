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

项目已配置 GitHub Actions 工作流，位于 `.github/workflows/build.yml`。工作流采用分步构建策略，包含以下特性：

1. **多架构支持**：同时构建 32 位 (x86) 和 64 位 (x64) 版本
2. **分步构建**：将构建过程分解为 FFmpeg、libbluray 和 LAV Filters 三个独立阶段
3. **依赖管理**：各阶段之间有明确的依赖关系
4. **自动化流程**：自动触发于推送和拉取请求事件
5. **制品管理**：自动打包并上传构建产物

工作流执行步骤：
1. **FFmpeg 构建阶段**：设置 MinGW-w64 交叉编译环境，构建 FFmpeg 库
2. **libbluray 构建阶段**：基于 FFmpeg 构建成果，构建 libbluray 库
3. **LAV Filters 构建阶段**：使用前两个阶段的成果，构建主程序
4. **打包阶段**：收集所有架构的构建产物并打包

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
- libbluray 目录应该包含一个完整的、配置好的 libbluray 仓库，可以从 https://gitea.1f0.de/dekkers/libbluray.git 获取
- 如果构建过程中出现 config.h 找不到的错误，需要确保 libbluray 目录包含正确的文件