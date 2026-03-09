import 'package:flutter/material.dart';

/// 应用路由配置
/// 定义应用所有页面路由
class AppRoutes {
  // 路由名称常量
  static const String home = '/home';
  static const String addTask = '/addTask';
  static const String taskDetail = '/taskDetail';

  /// 主路由配置
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => _PlaceholderPage(title: '待办列表'),
        );
      case addTask:
        return MaterialPageRoute(
          builder: (_) => _PlaceholderPage(title: '添加任务'),
        );
      case taskDetail:
        return MaterialPageRoute(
          builder: (_) => _PlaceholderPage(title: '任务详情'),
        );
      default:
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
