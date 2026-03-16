import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import 'hive_task_repository.dart';

/// 任务数据仓库接口
/// 定义数据访问的抽象契约，符合依赖倒置原则（Dependency Inversion Principle）
///
/// 为什么使用接口？
/// 1. 依赖倒置：业务层依赖抽象，不依赖具体实现
/// 2. 易于测试：可以注入 Mock Repository 进行单元测试
/// 3. 灵活切换：可以轻松从内存存储切换到 Hive、SQLite 或网络存储
abstract class TaskRepository {
  /// 获取所有任务
  Future<List<Task>> getAllTasks();

  /// 根据 ID 获取任务
  Future<Task?> getTaskById(String id);

  /// 添加任务
  Future<void> addTask(Task task);

  /// 更新任务
  Future<void> updateTask(Task task);

  /// 删除任务
  Future<void> deleteTask(String id);

  /// 清空所有任务
  Future<void> clearAllTasks();

  /// 获取已完成任务
  Future<List<Task>> getCompletedTasks();

  /// 获取未完成任务
  Future<List<Task>> getIncompleteTasks();

  /// 切换任务完成状态
  Future<void> toggleTaskStatus(String id);
}

/// 内存任务仓库实现
/// 用于快速验证业务逻辑，后续可以替换为 Hive 或其他持久化存储
class MemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getAllTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task?> getTaskById(String id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<void> clearAllTasks() async {
    _tasks.clear();
  }

  @override
  Future<List<Task>> getCompletedTasks() async {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  @override
  Future<List<Task>> getIncompleteTasks() async {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  @override
  Future<void> toggleTaskStatus(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      await updateTask(task.toggleCompleted());
    }
  }
}

/// TaskRepository Provider
/// 使用 ProviderScope 注入 Repository 实例
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  // 先使用内存实现，避免循环依赖
  return MemoryTaskRepository();
  // 后续可以通过配置切换
  // return ref.watch(appConfigProvider).useHiveStorage
  //   ? HiveTaskRepository()
  //   : MemoryTaskRepository();
});
