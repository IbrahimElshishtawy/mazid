//barter_model المقايضه

class BarterModel {
  final String id;
  final String offeredItemId;
  final String requestedItemId;
  final String proposerId;
  final String status;

  BarterModel({
    required this.id,
    required this.offeredItemId,
    required this.requestedItemId,
    required this.proposerId,
    required this.status,
  });

  factory BarterModel.fromJson(Map<String, dynamic> json) {
    return BarterModel(
      id: json['id'],
      offeredItemId: json['offered_item_id'],
      requestedItemId: json['requested_item_id'],
      proposerId: json['proposer_id'],
      status: json['status'],
    );
  }
}
