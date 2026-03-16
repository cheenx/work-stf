import 'package:flutter/material.dart';
import '../../data/models/task.dart';

/// 任务列表项
/// 显示任务信息和操作按钮
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey(task.id),
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsetsDirectional.only(end: 16),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onToggleComplete(),
            shape: const CircleBorder(),
            activeColor: Colors.green,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: task.isCompleted ? FontWeight.w400 : FontWeight.w500,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: task.description.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    task.description,
                    style: TextStyle(
                      color: task.isCompleted ? Colors.grey : Colors.grey[700],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          trailing: _buildTrailingWidget(context),
          onTap: onToggleComplete,
        ),
      ),
    );
  }

  /// 构建右侧操作图标
  Widget _buildTrailingWidget(BuildContext context) {
    return Icon(
      task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
      color: task.isCompleted ? Colors.green : Colors.grey,
      size: 24,
    );
  }
}