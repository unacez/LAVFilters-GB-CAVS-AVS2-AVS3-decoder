# GitHub Actions 构建系统

## 工作流说明

本项目使用 GitHub Actions 进行持续集成和自动构建，具体配置在 [.github/workflows/build.yml](../.github/workflows/build.yml) 文件中定义。

## 构建流程

1. **触发条件**：当代码推送到主分支或创建拉取请求时自动触发
2. **环境设置**：配置 MinGW-w64 交叉编译环境和 Visual Studio 开发环境
3. **依赖安装**：安装编译所需的工具链（GCC、YASM、make 等）
4. **FFmpeg 构建**：为 x86 和 x64 架构分别构建 FFmpeg 库
5. **LAV Filters 构建**：使用 MSBuild 构建主项目
6. **制品打包**：收集并上传构建产物

## 架构支持

- x86 (32位)
- x64 (64位)

## 构建产物

构建完成后，可以在 Actions 页面下载对应架构的构建产物，最终会打包成完整的发布版本。