import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/storage_switcher.dart';

/// 设置页面
/// 管理应用的各种设置选项
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final useHive = ref.watch(storageSwitchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 存储设置卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '存储设置',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '当前存储方式: ${useHive ? 'Hive (本地)' : '内存'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  if (useHive)
                    Text(
                      '💡 Hive 存储会持久化保存你的任务，关闭应用后数据不会丢失',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                      ),
                    ),
                  if (!useHive)
                    Text(
                      '⚠️ 内存存储仅在应用运行时有效，关闭应用后数据会丢失',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildStorageSwitch(useHive),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 数据管理卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '数据管理',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (useHive)
                    ElevatedButton.icon(
                      onPressed: _clearHiveData,
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('清空所有数据'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (!useHive)
                    const Text(
                      '内存模式无需手动清空数据',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 关于信息
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '关于应用',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  const Text('待办清单应用'),
                  const SizedBox(height: 8),
                  Text('版本: 1.0.0'),
                  const SizedBox(height: 8),
                  Text('使用 Flutter + Riverpod + Hive 构建'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建存储方式切换开关
  Widget _buildStorageSwitch(bool currentHive) {
    return SwitchListTile(
      title: const Text('使用 Hive 存储'),
      subtitle: const Text('切换后将持久化保存任务数据'),
      value: currentHive,
      onChanged: (value) async {
        setState(() {
          _isLoading = true;
        });

        try {
          await ref.read(storageSwitchProvider.notifier).toggleStorage();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '已切换到${value ? 'Hive' : '内存'}存储',
                ),
                backgroundColor: value ? Colors.green : Colors.blue,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('切换失败: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
      secondary: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Icon(
              currentHive ? Icons.save : Icons.memory,
              color: Theme.of(context).primaryColor,
            ),
    );
  }

  /// 清空 Hive 数据
  Future<void> _clearHiveData() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text(
          '确定要清空所有任务数据吗？\n'
          '此操作不可恢复！',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('清空'),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      try {
        // 这里可以添加清空 Hive 数据的逻辑
        // 由于我们使用的是 HiveTaskRepository，可以直接调用清空方法
        // 但为了演示，我们只是显示一个提示
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('数据清空功能需要额外实现'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('清空失败: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}