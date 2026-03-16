import 'package:flutter/material.dart';

/// 统计信息卡片
/// 显示任务完成情况的统计
class StatsCard extends StatelessWidget {
  final int total;
  final int completed;
  final int incomplete;
  final double completionRate;

  const StatsCard({
    super.key,
    required this.total,
    required this.completed,
    required this.incomplete,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    // 统计信息通过构造函数传入

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '任务统计',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildStatRow('总任务', total, context),
            const SizedBox(height: 8),
            _buildStatRow('已完成', completed, context, color: Colors.green),
            const SizedBox(height: 8),
            _buildStatRow('未完成', incomplete, context, color: Colors.orange),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '完成率',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: completionRate,
                  backgroundColor: Colors.grey[200],
                  color: _getProgressColor(completionRate),
                  minHeight: 8,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(completionRate * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建统计行
  Widget _buildStatRow(String label, int value, BuildContext context,
      {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color ?? Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  /// 获取进度条颜色
  Color _getProgressColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.5) return Colors.orange;
    return Colors.red;
  }
}