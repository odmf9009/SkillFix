import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/trade.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import 'video_list_screen.dart';

class TaskListScreen extends StatelessWidget {
  final Trade trade;

  const TaskListScreen({super.key, required this.trade});

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = MockData.tasksForTrade(trade.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: trade.color,
        title: Text(trade.name),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: trade.color,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Icon(trade.icon, color: Colors.white54, size: 20),
                const SizedBox(width: 8),
                Text(
                  trade.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks available yet.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => TaskCard(
                      task: tasks[index],
                      tradeColor: trade.color,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoListScreen(
                            trade: trade,
                            task: tasks[index],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
