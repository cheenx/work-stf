# 数据层（Data Layer）

数据层是 Clean Architecture 的最内层，负责数据的存储、读取和转换。

## 📁 文件结构

```
data/
├── models/              # 数据模型（与存储格式一一对应）
│   └── task.dart       # Task 模型
├── repositories/        # 数据访问抽象层（依赖倒置）
│   └── task_repository.dart  # TaskRepository 接口和实现
└── services/           # 具体数据服务（如 Hive、SQLite、API）
```

## 🏗️ 架构设计

### 1. Models（数据模型）
- **职责**：定义数据的结构，与存储格式对应
- **示例**：`Task` 模型包含 `id`、`title`、`description` 等字段
- **设计原则**：
  - 不可变性：所有字段使用 `final`
  - 工厂方法：提供便捷的创建方法（如 `Task.create()`）
  - 复制更新：提供 `copyWith()` 方法更新字段

### 2. Repositories（数据仓库）
- **职责**：定义数据访问的抽象接口
- **设计原则**：
  - **依赖倒置**：业务层依赖抽象接口，不依赖具体实现
  - **单一职责**：每个 Repository 负责一个实体
  - **易于测试**：可以注入 Mock Repository 进行单元测试

### 3. Services（数据服务）
- **职责**：具体的数据存储实现（Hive、SQLite、网络 API）
- **后续实现**：将 `MemoryTaskRepository` 迁移到 `HiveTaskRepository`

## 🔄 数据流向

```
用户操作 → UI 层 → Domain 层（Provider）→ Repository 接口 → Service 实现 → 数据存储
```

## 🧪 测试策略

- **单元测试**：使用 Mock Repository 测试业务逻辑
- **集成测试**：测试具体的数据服务实现
- **端到端测试**：测试完整的数据流程

## 📦 后续优化

1. **添加 Hive 适配器**：运行 `flutter pub run build_runner build` 生成代码
2. **实现持久化存储**：创建 `HiveTaskRepository`
3. **添加数据验证**：在 Model 层添加字段验证逻辑
4. **错误处理**：完善异常处理和重试机制
