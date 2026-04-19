import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iamfertilizer/services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  bool isLoading = true;
  List<dynamic> historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final data = await _historyService.getCropHistory();
      if (!mounted) return;
      setState(() {
        historyList = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _showDetails(dynamic item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item['disease'] ?? 'Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Confidence: ${item['confidence']}"),
            const SizedBox(height: 10),
            Text("Recommendation: ${item['recommendation']}"),
            const SizedBox(height: 10),
            Text("Image: ${item['image_name'] ?? 'N/A'}"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Crop History", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
          ? const Center(child: Text("No history found yet"))
          : RefreshIndicator(
        onRefresh: _loadHistory,
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final item = historyList[index];
            final formattedDate = item['created_at'] != null
                ? DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.parse(item['created_at']).toLocal())
                : "Unknown";

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xff11998e).withOpacity(0.1),
                    child: const Icon(Icons.eco, color: Color(0xff11998e)),
                  ),
                ),
                title: Text(
                  item['disease'] ?? "Unknown",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: $formattedDate"),
                    Text(
                      "Recommendation: ${item['recommendation']}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => _showDetails(item),
              ),
            );
          },
        ),
      ),
    );
  }
}