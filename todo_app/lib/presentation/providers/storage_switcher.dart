import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/hive_task_repository.dart';

/// 存储切换器
/// 提供一个简单的切换功能，在内存和 Hive 存储之间切换
class StorageSwitcher {
  static bool _useHive = false;

  static bool get useHive => _useHive;

  static void setUseHive(bool useHive) {
    _useHive = useHive;
  }

  static TaskRepository getRepository() {
    return _useHive ? HiveTaskRepository() : MemoryTaskRepository();
  }
}

/// 存储类型 Provider
final storageTypeProvider = Provider<bool>((ref) {
  return StorageSwitcher.useHive;
});

/// 动态 Repository Provider
final dynamicTaskRepositoryProvider = Provider<TaskRepository>((ref) {
  return StorageSwitcher.getRepository();
});

/// 存储切换命令
final storageSwitchProvider = NotifierProvider<StorageSwitchNotifier, bool>(
  StorageSwitchNotifier.new,
);

class StorageSwitchNotifier extends Notifier<bool> {
  @override
  bool build() {
    return StorageSwitcher.useHive;
  }

  Future<void> toggleStorage() async {
    final newState = !state;
    StorageSwitcher.setUseHive(newState);
    state = newState;
  }
}