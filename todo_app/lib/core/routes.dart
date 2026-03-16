import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/pages/tasks_list_page.dart';
import '../presentation/pages/settings_page.dart';

/// 应用路由配置
/// 定义应用所有页面路由
class AppRoutes {
  // 路由名称常量
  static const String home = '/home';
  static const String addTask = '/addTask';
  static const String taskDetail = '/taskDetail';
  static const String settings = '/settings';

  /// 主路由配置
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    if (name == home) {
      return MaterialPageRoute(
        builder: (_) => const ProviderScope(
          child: TasksListPage(),
        ),
      );
    } else if (name == addTask) {
      return MaterialPageRoute(
        builder: (_) => const ProviderScope(
          child: TasksListPage(),
        ),
      );
    } else if (name == taskDetail) {
      return MaterialPageRoute(
        builder: (_) => _PlaceholderPage(title: '任务详情'),
      );
    } else if (name == settings) {
      return MaterialPageRoute(
        builder: (_) => const ProviderScope(
          child: SettingsPage(),
        ),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => _PlaceholderPage(title: '404'),
      );
    }
  }
}

/// 占位页面，用于路由配置验证
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title - 待实现'),
      ),
    );
  }
}