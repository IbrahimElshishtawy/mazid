import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/swap_request_model.dart';

class SwapService {
  final supabase = Supabase.instance.client;

  /// جلب كل الطلبات
  Future<List<SwapRequestModel>> getAllRequests() async {
    final response = await supabase.from('swap_requests').select();
    return (response as List)
        .map((json) => SwapRequestModel.fromJson(json))
        .toList();
  }

  /// جلب الطلبات المرسلة من مستخدم
  Future<List<SwapRequestModel>> getRequestsBySender(String senderId) async {
    final response = await supabase
        .from('swap_requests')
        .select()
        .eq('sender_id', senderId);
    return (response as List)
        .map((json) => SwapRequestModel.fromJson(json))
        .toList();
  }

  /// جلب الطلبات المستلمة من مستخدم
  Future<List<SwapRequestModel>> getRequestsByReceiver(
    String receiverId,
  ) async {
    final response = await supabase
        .from('swap_requests')
        .select()
        .eq('receiver_id', receiverId);
    return (response as List)
        .map((json) => SwapRequestModel.fromJson(json))
        .toList();
  }

  /// إرسال طلب جديد
  Future<void> sendSwapRequest(SwapRequestModel request) async {
    await supabase.from('swap_requests').insert(request.toJson());
    if (kDebugMode) {
      print("✅ Swap request sent: ${request.id}");
    }
  }

  /// قبول الطلب
  Future<void> acceptRequest(String requestId) async {
    await supabase
        .from('swap_requests')
        .update({'status': 'accepted'})
        .eq('id', requestId);

    if (kDebugMode) {
      print("✅ Swap request accepted: $requestId");
    }
  }

  /// رفض الطلب
  Future<void> rejectRequest(String requestId) async {
    await supabase
        .from('swap_requests')
        .update({'status': 'rejected'})
        .eq('id', requestId);

    if (kDebugMode) {
      print("❌ Swap request rejected: $requestId");
    }
  }

  /// تحديث الطلب
  Future<void> updateRequest(SwapRequestModel updatedRequest) async {
    await supabase
        .from('swap_requests')
        .update(updatedRequest.toJson())
        .eq('id', updatedRequest.id);

    if (kDebugMode) {
      print("🔄 Swap request updated: ${updatedRequest.id}");
    }
  }

  /// حذف الطلب
  Future<void> deleteRequest(String requestId) async {
    await supabase.from('swap_requests').delete().eq('id', requestId);

    if (kDebugMode) {
      print("🗑 Swap request deleted: $requestId");
    }
  }
}
