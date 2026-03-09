# AI Work - 移动端开发学习项目

> 基于 Flutter + Clean Architecture + Riverpod 的移动应用开发学习与实践

## 📁 项目结构

```
AI-work/
├── CLAUDE.md                 # Claude Code 项目配置与指导文件
├── README.md                 # 项目说明文档
├── .gitignore               # Git 忽略规则
├── todo_app/               # Flutter 待办清单应用（Clean Architecture）
│   ├── lib/
│   │   ├── core/           # 核心基础设施
│   │   ├── data/           # 数据层
│   │   ├── domain/         # 业务层
│   │   └── presentation/   # UI 层
│   └── pubspec.yaml        # 依赖配置
└── progress/               # 学习进度追踪
    ├── mobile-dev-tracker.md       # 技能成长追踪器
    └── 2026-03-10-daily-summary.md # 每日学习总结
```

## 🎯 当前项目：待办清单应用（todo_app）

### 技术栈
- **框架**：Flutter 3.32.6
- **语言**：Dart 3.8.1
- **架构**：Clean Architecture
- **状态管理**：Riverpod 2.6.1
- **本地存储**：Hive 2.2.3

### 架构设计
采用 Clean Architecture 三层架构：
- **UI 层（presentation）**：负责数据展示和用户交互
- **业务层（domain）**：处理业务逻辑和状态管理
- **数据层（data）**：负责数据存储、读取和转换

### 当前进度
- ✅ Phase 1：项目初始化与目录搭建
- ✅ Phase 2：数据层实现（Task 模型、Repository 接口、内存存储）
- ⏳ Phase 3：业务层实现（待开发）
- ⏳ Phase 4：UI 层实现（待开发）

---

## 📚 学习资源

### 官方文档
- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言指南](https://dart.dev/guides)
- [Riverpod 文档](https://riverpod.dev/)
- [Hive 文档](https://docs.hivedb.dev/)

### 架构设计
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture 最佳实践](https://resocoder.com/flutter-clean-architecture/)

---

## 🤖 Claude Code 开发指南

本项目已集成 AI 导师系统，请使用以下指令获得最佳开发体验：

### 常用指令
- `Review this module` -> 启动架构审查，检查代码规范与设计模式
- `Analyze performance` -> 启动性能诊断流程，引导使用 Profiler 工具
- `Explain [concept]` -> 触发导师模式，结合项目代码讲解技术难点

### 注意事项
1. **不要直接索要代码：** 除非是简单的脚本，否则请尝试描述你的问题，导师会引导你完成
2. **保持追踪：** 每完成一个里程碑，提醒 Claude 更新 `/progress/mobile-dev-tracker.md`
3. **架构思维：** 始终从架构角度思考问题，而不是仅仅关注功能实现

---

## 📝 开发规范

### 代码规范
- 严格遵循 Clean Architecture 三层架构原则
- 不可变数据模型（使用 `final` 字段）
- 依赖倒置（外层依赖内层，内层不依赖外层）
- 单一职责原则

### Git 提交规范
- 提交信息使用中文，清晰描述变更内容
- 遵循 Conventional Commits 规范（如 `feat:`, `fix:`, `docs:` 等）
- 在提交前运行 `flutter analyze` 确保代码质量

---

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.32.0
- Dart SDK >= 3.8.0
- Android Studio / VS Code（推荐）

### 安装依赖
```bash
cd todo_app
flutter pub get
```

### 运行应用
```bash
flutter run
```

---

## 📖 学习路线

### 阶段 1：基础架构
- ✅ Clean Architecture 理解与实践
- ✅ Riverpod 状态管理基础
- ✅ 数据层设计与实现

### 阶段 2：业务逻辑（进行中）
- ⏳ Riverpod StateNotifier 深入应用
- ⏳ 业务逻辑封装与状态管理
- ⏳ 任务筛选与排序逻辑

### 阶段 3：UI 实现
- ⏳ Material Design 3 应用
- ⏳ Composable Widgets 设计
- ⏳ 响应式布局与动画

### 阶段 4：性能优化
- ⏳ Flutter 性能分析工具使用
- ⏳ 避免不必要的 Widget 重建
- ⏳ 内存泄漏检测与优化

---

## 📄 许可证

本项目仅用于学习目的，请勿用于商业用途。

---

**最后更新**：2026-03-10
