import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SwapRequestsPage extends StatefulWidget {
  const SwapRequestsPage({super.key});

  @override
  State<SwapRequestsPage> createState() => _SwapRequestsPageState();
}

class _SwapRequestsPageState extends State<SwapRequestsPage> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = fetchRequests();
  }

  Future<List<Map<String, dynamic>>> fetchRequests() async {
    final userId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('swap_requests')
        .select()
        .eq('receiver_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateRequestStatus(String id, String status) async {
    await supabase
        .from('swap_requests')
        .update({'status': status})
        .eq('id', id);
    setState(() {
      _requestsFuture = fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("طلبات المقايضة")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data!;
          if (requests.isEmpty) {
            return const Center(child: Text("لا توجد طلبات"));
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("طلب مقايضة"),
                  subtitle: Text("الحالة: ${req['status']}"),
                  trailing: req['status'] == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () =>
                                  updateRequestStatus(req['id'], 'accepted'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () =>
                                  updateRequestStatus(req['id'], 'rejected'),
                            ),
                          ],
                        )
                      : Text(req['status']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
