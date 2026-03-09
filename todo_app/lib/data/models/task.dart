import 'package:hive/hive.dart';

part 'task.g.dart';

/// 任务数据模型
/// 使用 Hive 进行本地存储
@HiveType(typeId: 0)
class Task {
  /// 任务唯一标识
  @HiveField(0)
  final String id;

  /// 任务标题
  @HiveField(1)
  final String title;

  /// 任务描述
  @HiveField(2)
  final String description;

  /// 是否已完成
  @HiveField(3)
  final bool isCompleted;

  /// 创建时间
  @HiveField(4)
  final DateTime createdAt;

  /// 更新时间
  @HiveField(5)
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 创建新任务（自动生成 ID 和时间戳）
  factory Task.create({
    required String title,
    String description = '',
  }) {
    final now = DateTime.now();
    return Task(
      id: '${now.millisecondsSinceEpoch}',
      title: title,
      description: description,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 复制并更新任务
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 切换完成状态
  Task toggleCompleted() {
    return copyWith(
      isCompleted: !isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// 更新任务内容
  Task update({
    String? title,
    String? description,
  }) {
    return copyWith(
      title: title ?? this.title,
      description: description ?? this.description,
      updatedAt: DateTime.now(),
    );
  }

  /// 转换为 JSON（用于调试和日志）
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'Task(id: $id, title: $title, isCompleted: $isCompleted)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
