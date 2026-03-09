import 'models/task.dart';
import 'repositories/task_repository.dart';

/// 数据层功能验证脚本
/// 用于测试数据层的基础功能是否正常工作
void testDataLayer() async {
  print('🧪 开始测试数据层...\n');

  // 1. 创建 Repository 实例
  final repository = MemoryTaskRepository();

  // 2. 测试添加任务
  print('📝 测试添加任务...');
  final task1 = Task.create(title: '学习 Flutter', description: '掌握 Clean Architecture');
  final task2 = Task.create(title: '完成 Phase 2', description: '实现数据层');
  await repository.addTask(task1);
  await repository.addTask(task2);
  print('   ✅ 添加任务成功\n');

  // 3. 测试获取所有任务
  print('📋 测试获取所有任务...');
  final allTasks = await repository.getAllTasks();
  print('   当前任务数: ${allTasks.length}');
  for (var task in allTasks) {
    print('   - ${task.title} (${task.isCompleted ? "已完成" : "未完成"})');
  }
  print('');

  // 4. 测试完成任务
  print('✅ 测试完成任务...');
  await repository.toggleTaskStatus(task1.id);
  final completedTasks = await repository.getCompletedTasks();
  print('   已完成任务数: ${completedTasks.length}');
  print('');

  // 5. 测试更新任务
  print('🔧 测试更新任务...');
  final updatedTask = task2.update(title: '完成 Phase 2 ✅');
  await repository.updateTask(updatedTask);
  print('   ✅ 任务更新成功\n');

  // 6. 测试删除任务
  print('🗑️  测试删除任务...');
  await repository.deleteTask(task1.id);
  final remainingTasks = await repository.getAllTasks();
  print('   删除后任务数: ${remainingTasks.length}');
  print('');

  print('🎉 数据层测试完成！');
}

/// 在 main 函数中调用测试
void main() async {
  testDataLayer();
}
