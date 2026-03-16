import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task.dart';
import '../../data/repositories/task_repository.dart';
import 'storage_switcher.dart';

/// 任务状态管理器
/// 使用 StateNotifier 管理任务相关的复杂状态
class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier(this.ref) : super([]) {
    // 初始化时加载任务
    _loadTasks();
  }

  final Ref ref;

  /// 依赖注入的 Repository
  TaskRepository get _repository => ref.read(dynamicTaskRepositoryProvider);

  /// 加载所有任务
  Future<void> _loadTasks() async {
    try {
      final tasks = await _repository.getAllTasks();
      state = tasks;
    } catch (e) {
      // 错误处理：可以添加错误状态管理
      state = [];
    }
  }

  /// 添加新任务
  Future<void> addTask(String title, {String description = ''}) async {
    try {
      final newTask = Task.create(title: title, description: description);
      await _repository.addTask(newTask);
      // 重新加载列表以确保数据一致性
      await _loadTasks();
    } catch (e) {
      throw Exception('添加任务失败: $e');
    }
  }

  /// 更新任务
  Future<void> updateTask(Task task) async {
    try {
      await _repository.updateTask(task);
      await _loadTasks();
    } catch (e) {
      throw Exception('更新任务失败: $e');
    }
  }

  /// 删除任务
  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      await _loadTasks();
    } catch (e) {
      throw Exception('删除任务失败: $e');
    }
  }

  /// 切换任务状态
  Future<void> toggleTaskStatus(String id) async {
    try {
      await _repository.toggleTaskStatus(id);
      await _loadTasks();
    } catch (e) {
      throw Exception('切换任务状态失败: $e');
    }
  }

  /// 清空已完成任务
  Future<void> clearCompletedTasks() async {
    try {
      final completedTasks = await _repository.getCompletedTasks();
      for (final task in completedTasks) {
        await _repository.deleteTask(task.id);
      }
      await _loadTasks();
    } catch (e) {
      throw Exception('清空已完成任务失败: $e');
    }
  }

  /// 获取任务统计信息
  TaskStats get taskStats {
    final allTasks = state;
    final completedTasks = allTasks.where((t) => t.isCompleted).length;
    final incompleteTasks = allTasks.length - completedTasks;

    return TaskStats(
      total: allTasks.length,
      completed: completedTasks,
      incomplete: incompleteTasks,
      completionRate: allTasks.isEmpty ? 0 : completedTasks / allTasks.length,
    );
  }
}

/// 任务统计信息
class TaskStats {
  final int total;
  final int completed;
  final int incomplete;
  final double completionRate;

  TaskStats({
    required this.total,
    required this.completed,
    required this.incomplete,
    required this.completionRate,
  });
}

/// StateNotifier Provider
/// 管理所有任务的状态
final taskNotifierProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ref);
});

/// 任务统计 Provider
/// 使用 Provider.select 优化性能，避免不必要的重建
final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(taskNotifierProvider);
  return TaskStats(
    total: tasks.length,
    completed: tasks.where((t) => t.isCompleted).length,
    incomplete: tasks.where((t) => !t.isCompleted).length,
    completionRate: tasks.isEmpty ? 0 : tasks.where((t) => t.isCompleted).length / tasks.length,
  );
});

/// 过滤已完成的任务 Provider
final completedTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(taskNotifierProvider).where((task) => task.isCompleted).toList();
});

/// 过滤未完成的任务 Provider
final incompleteTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(taskNotifierProvider).where((task) => !task.isCompleted).toList();
});

/// 按创建时间排序的任务 Provider
final sortedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskNotifierProvider);
  return List<Task>.from(tasks)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});