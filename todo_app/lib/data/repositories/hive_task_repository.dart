import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import 'task_repository.dart';

/// Hive 任务仓库实现
/// 使用 Hive 进行本地持久化存储
class HiveTaskRepository implements TaskRepository {
  static const String _boxName = 'tasks';
  Box? _taskBox;

  /// 初始化或获取任务盒子
  Future<Box> _getTaskBox() async {
    if (_taskBox == null || !_taskBox!.isOpen) {
      _taskBox = await Hive.openBox(_boxName);
    }
    return _taskBox!;
  }

  /// 获取所有任务
  @override
  Future<List<Task>> getAllTasks() async {
    final box = await _getTaskBox();
    final tasks = <Task>[];

    for (int i = 0; i < box.length; i++) {
      final taskJson = box.getAt(i);
      if (taskJson != null) {
        tasks.add(Task.fromJson(taskJson));
      }
    }

    // 按创建时间降序排序
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  /// 根据 ID 获取任务
  @override
  Future<Task?> getTaskById(String id) async {
    final box = await _getTaskBox();
    final taskJson = box.get(id);
    if (taskJson != null) {
      return Task.fromJson(taskJson);
    }
    return null;
  }

  /// 添加任务
  @override
  Future<void> addTask(Task task) async {
    final box = await _getTaskBox();
    await box.put(task.id, task.toJson());
  }

  /// 更新任务
  @override
  Future<void> updateTask(Task task) async {
    final box = await _getTaskBox();
    if (box.containsKey(task.id)) {
      await box.put(task.id, task.toJson());
    }
  }

  /// 删除任务
  @override
  Future<void> deleteTask(String id) async {
    final box = await _getTaskBox();
    await box.delete(id);
  }

  /// 清空所有任务
  @override
  Future<void> clearAllTasks() async {
    final box = await _getTaskBox();
    await box.clear();
  }

  /// 获取已完成任务
  @override
  Future<List<Task>> getCompletedTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isCompleted).toList();
  }

  /// 获取未完成任务
  @override
  Future<List<Task>> getIncompleteTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => !task.isCompleted).toList();
  }

  /// 切换任务完成状态
  @override
  Future<void> toggleTaskStatus(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      final updatedTask = task.toggleCompleted();
      await updateTask(updatedTask);
    }
  }

  /// 获取任务总数
  Future<int> getTaskCount() async {
    final box = await _getTaskBox();
    return box.length;
  }

  /// 检查任务是否存在
  Future<bool> taskExists(String id) async {
    final box = await _getTaskBox();
    return box.containsKey(id);
  }

  /// 批量删除任务
  Future<void> deleteTasks(List<String> ids) async {
    final box = await _getTaskBox();
    for (final id in ids) {
      await box.delete(id);
    }
  }

  /// 备份数据到 JSON
  Future<String> backupToJson() async {
    final tasks = await getAllTasks();
    return tasks.map((task) => task.toJson()).toList().toString();
  }

  /// 从 JSON 恢复数据
  Future<void> restoreFromJson(String jsonData) async {
    try {
      // 这里需要实现 JSON 解析和任务重建逻辑
      // 为了简化，这个功能留给后续实现
      throw UnimplementedError('JSON 恢复功能待实现');
    } catch (e) {
      throw Exception('恢复数据失败: $e');
    }
  }
}