import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/task_notifier.dart';

/// 悬浮添加任务按钮
class AddTaskButton extends ConsumerStatefulWidget {
  const AddTaskButton({super.key});

  @override
  ConsumerState<AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends ConsumerState<AddTaskButton> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isExpanded
          ? _AddTaskForm(
              titleController: _titleController,
              descriptionController: _descriptionController,
              onCancel: () {
                setState(() {
                  _isExpanded = false;
                  _titleController.clear();
                  _descriptionController.clear();
                });
              },
              onSubmit: (title, description) {
                _addTask(title, description);
                setState(() {
                  _isExpanded = false;
                  _titleController.clear();
                  _descriptionController.clear();
                });
              },
            )
          : FloatingActionButton(
              key: const ValueKey('add_button'),
              onPressed: () {
                setState(() {
                  _isExpanded = true;
                });
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  /// 添加任务
  Future<void> _addTask(String title, String description) async {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('任务标题不能为空'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(taskNotifierProvider.notifier).addTask(
            title.trim(),
            description: description.trim(),
          );

      // 成功提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('任务添加成功'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('添加失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 添加任务表单
class _AddTaskForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onCancel;
  final Function(String, String) onSubmit;

  const _AddTaskForm({
    required this.titleController,
    required this.descriptionController,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: '任务标题',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: '任务描述（可选）',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text('取消'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('添加'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isNotEmpty) {
      onSubmit(title, description);
    }
  }
}