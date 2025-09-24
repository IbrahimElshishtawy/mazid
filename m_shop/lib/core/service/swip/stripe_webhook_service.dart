// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';

class StripeWebhookService {
  Future<Response> handleRequest(Request request) async {
    if (request.url.path == 'webhook' && request.method == 'POST') {
      final payload = await request.readAsString();
      final headers = request.headers;

      final event = jsonDecode(payload);
      final eventType = event['type'];

      switch (eventType) {
        case 'payment_intent.succeeded':
          if (kDebugMode) {
            print("✅ Payment succeeded: ${event['data']['object']['id']}");
          }
          break;

        case 'charge.refunded':
          if (kDebugMode) {
            print("💸 Refund detected: ${event['data']['object']['id']}");
          }
          break;

        default:
          if (kDebugMode) {
            print("⚠️ Unhandled event: $eventType");
          }
      }

      return Response.ok(jsonEncode({'status': 'received'}));
    }

    return Response.notFound('Not Found');
  }
}
