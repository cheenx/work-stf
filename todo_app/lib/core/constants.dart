/// 应用常量定义
/// 存放应用级别的常量，避免硬编码
class AppConstants {
  // 应用信息
  static const String appName = '待办清单';
  static const String appVersion = '1.0.0';

  // Hive 数据库配置
  static const String hiveBoxName = 'todoBox';

  // UI 常量
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // 任务相关
  static const int maxTaskTitleLength = 100;
  static const int maxTaskDescriptionLength = 500;
}
