import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/hive_task_repository.dart';

/// 应用配置 Provider
/// 管理应用的各项设置，如存储方式、主题等
class AppConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() {
    return const AppConfig();
  }

  /// 切换存储方式
  Future<void> toggleStorage() async {
    state = state.copyWith(
      useHiveStorage: !state.useHiveStorage,
    );
  }

  /// 设置是否使用 Hive 存储
  void setUseHiveStorage(bool useHive) {
    state = state.copyWith(useHiveStorage: useHive);
  }
}

/// 应用配置数据类
class AppConfig {
  final bool useHiveStorage; // 是否使用 Hive 存储

  const AppConfig({this.useHiveStorage = false});

  AppConfig copyWith({
    bool? useHiveStorage,
  }) {
    return AppConfig(
      useHiveStorage: useHiveStorage ?? this.useHiveStorage,
    );
  }
}

/// 应用配置 Provider
final appConfigProvider = NotifierProvider<AppConfigNotifier, AppConfig>(() {
  return AppConfigNotifier();
});

/// 动态 Repository Provider
/// 根据 AppConfig 选择使用哪种存储实现
final dynamicTaskRepositoryProvider = Provider<TaskRepository>((ref) {
  final config = ref.watch(appConfigProvider);

  if (config.useHiveStorage) {
    return HiveTaskRepository();
  } else {
    return MemoryTaskRepository();
  }
});

/// 存储类型枚举
enum StorageType {
  memory,
  hive,
}

/// 存储类型 Provider
final storageTypeProvider = Provider<StorageType>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.useHiveStorage ? StorageType.hive : StorageType.memory;
});