import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task.dart';
import '../../presentation/providers/task_notifier.dart';
import '../../presentation/providers/storage_switcher.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_button.dart';
import '../widgets/stats_card.dart';

/// 任务列表页面
/// 展示所有任务，支持过滤、排序和批量操作
class TasksListPage extends ConsumerStatefulWidget {
  const TasksListPage({super.key});

  @override
  ConsumerState<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends ConsumerState<TasksListPage> {
  // 当前选中的过滤选项
  TaskFilter _currentFilter = TaskFilter.all;
  // 搜索关键词
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // 监听任务列表
    final tasks = ref.watch(sortedTasksProvider);
    // 监听任务统计
    final stats = ref.watch(taskStatsProvider);
    // 监听存储类型
    final useHive = ref.watch(storageSwitchProvider);

    // 根据过滤条件筛选任务
    final filteredTasks = _filterTasks(tasks);

    return Scaffold(
      appBar: AppBar(
        title: const Text('待办清单'),
        actions: [
          // 存储类型指示器
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(
                useHive ? '本地存储' : '内存',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: useHive
                  ? Colors.green.shade100
                  : Colors.blue.shade100,
              labelStyle: TextStyle(
                color: useHive
                    ? Colors.green.shade800
                    : Colors.blue.shade800,
              ),
            ),
          ),
          // 统计信息按钮
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showStatsDialog(stats),
          ),
          // 过滤选项菜单
          PopupMenuButton<TaskFilter>(
            onSelected: _handleFilterSelect,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskFilter.all,
                child: Text('所有任务'),
              ),
              const PopupMenuItem(
                value: TaskFilter.active,
                child: Text('未完成'),
              ),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('已完成'),
              ),
              const PopupMenuItem(
                value: TaskFilter.settings,
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('设置'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '搜索任务',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 统计卡片
          StatsCard(
            total: stats.total,
            completed: stats.completed,
            incomplete: stats.incomplete,
            completionRate: stats.completionRate,
          ),

          // 任务列表
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentFilter == TaskFilter.completed
                              ? Icons.check_circle_outline
                              : Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getEmptyMessage(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskItem(
                        task: task,
                        onToggleComplete: () => _toggleTaskStatus(task),
                        onDelete: () => _deleteTask(task.id),
                      );
                    },
                  ),
          ),

          const AddTaskButton(),
        ],
      ),
    );
  }

  /// 根据过滤条件筛选任务
  List<Task> _filterTasks(List<Task> tasks) {
    var filtered = tasks;

    // 应用过滤
    switch (_currentFilter) {
      case TaskFilter.active:
        filtered = filtered.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        filtered = filtered.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.all:
      case TaskFilter.settings:
        break;
    }

    // 应用搜索
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(_searchQuery) ||
            t.description.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  /// 切换任务状态
  Future<void> _toggleTaskStatus(Task task) async {
    try {
      await ref.read(taskNotifierProvider.notifier).toggleTaskStatus(task.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作失败: $e')),
        );
      }
    }
  }

  /// 删除任务
  Future<void> _deleteTask(String id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个任务吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await ref.read(taskNotifierProvider.notifier).deleteTask(id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('删除失败: $e')),
          );
        }
      }
    }
  }

  /// 显示统计信息对话框
  void _showStatsDialog(TaskStats stats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('任务统计'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatItem(label: '总任务数', value: '${stats.total}'),
            _StatItem(label: '已完成', value: '${stats.completed}'),
            _StatItem(label: '未完成', value: '${stats.incomplete}'),
            const SizedBox(height: 8),
            const Text('完成率:'),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: LinearProgressIndicator(
                value: stats.completionRate,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
              ),
            ),
            Text(
              '${(stats.completionRate * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 获取空状态消息
  String _getEmptyMessage() {
    switch (_currentFilter) {
      case TaskFilter.all:
        return _searchQuery.isNotEmpty
            ? '没有找到匹配的任务'
            : '还没有任务，点击右下角按钮添加';
      case TaskFilter.active:
        return '没有未完成的任务';
      case TaskFilter.completed:
        return '还没有已完成的任务';
      case TaskFilter.settings:
        return '';
    }
  }

  /// 处理过滤选项选择
  void _handleFilterSelect(TaskFilter filter) {
    if (filter == TaskFilter.settings) {
      Navigator.pushNamed(context, '/settings');
    } else {
      setState(() {
        _currentFilter = filter;
      });
    }
  }
}

/// 过滤选项枚举
enum TaskFilter {
  all,
  active,
  completed,
  settings,
}

/// 统计项组件
class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}