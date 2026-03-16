import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants.dart';
import 'core/routes.dart';
import 'core/theme.dart';

void main() async {
  // 确保 Flutter 组件已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await _initHive();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// 初始化 Hive 数据库
Future<void> _initHive() async {
  try {
    // 初始化 Hive Flutter
    await Hive.initFlutter();

    // 注册 Task 适配器
    if (!Hive.isAdapterRegistered(0)) {
      // hive_generator 会生成这个适配器
      // Hive.registerAdapter(TaskAdapter());
    }

    // 打开任务盒子
    await Hive.openBox('tasks');

    print('Hive 初始化成功');
  } catch (e) {
    print('Hive 初始化失败: $e');
    // 即使初始化失败，应用也要继续运行
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
