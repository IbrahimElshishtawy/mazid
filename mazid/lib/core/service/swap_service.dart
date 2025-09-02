import 'package:flutter/foundation.dart';

import '../models/swap_request_model.dart';

class SwapService {
  final List<SwapRequestModel> _requests = [];

  List<SwapRequestModel> getAllRequests() => List.unmodifiable(_requests);

  List<SwapRequestModel> getRequestsBySender(String senderId) =>
      _requests.where((r) => r.senderId == senderId).toList();

  List<SwapRequestModel> getRequestsByReceiver(String receiverId) =>
      _requests.where((r) => r.receiverId == receiverId).toList();

  List<SwapRequestModel> getRequestsByStatus(SwapStatus status) =>
      _requests.where((r) => r.status == status).toList();

  void sendSwapRequest(SwapRequestModel request) {
    _requests.add(request);
    if (kDebugMode) {
      print("✅ Swap request sent: ${request.id}");
    }
  }

  bool acceptRequest(String requestId) {
    try {
      final request = _requests.firstWhere((r) => r.id == requestId);
      request.status = SwapStatus.accepted;
      if (kDebugMode) {
        print("✅ Swap request accepted: $requestId");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Accept failed: $e");
      }
      return false;
    }
  }

  bool rejectRequest(String requestId) {
    try {
      final request = _requests.firstWhere((r) => r.id == requestId);
      request.status = SwapStatus.rejected;
      if (kDebugMode) {
        print("❌ Swap request rejected: $requestId");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Reject failed: $e");
      }
      return false;
    }
  }

  bool updateRequest(SwapRequestModel updatedRequest) {
    try {
      final index = _requests.indexWhere((r) => r.id == updatedRequest.id);
      if (index != -1) {
        _requests[index] = updatedRequest;
        if (kDebugMode) {
          print("🔄 Swap request updated: ${updatedRequest.id}");
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Update failed: $e");
      }
      return false;
    }
  }

  bool deleteRequest(String requestId) {
    try {
      _requests.removeWhere((r) => r.id == requestId);
      if (kDebugMode) {
        print("🗑 Swap request deleted: $requestId");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Delete failed: $e");
      }
      return false;
    }
  }
}
