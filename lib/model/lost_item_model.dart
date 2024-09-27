import 'dart:convert';

class LostItem {
  LostItem({
    required this.userId,
    required this.itemId,
    required this.description,
    required this.otherDescription,
    required this.lastSeenLocation,
    required this.tip,
    required this.hasTip,
    required this.itemImages,
    required this.isClaimed,
    required this.status,
    required this.createdAt,
  });

  final String userId;
  final String itemId;
  final String description;
  final String? otherDescription;
  final String? lastSeenLocation;
  final double? tip;
  final bool hasTip;
  final List<String> itemImages;
  final int? isClaimed;
  final int? status;
  final DateTime? createdAt;

  LostItem copyWith({
    String? userId,
    String? itemId,
    String? description,
    String? otherDescription,
    String? lastSeenLocation,
    double? tip,
    bool? hasTip,
    List<String>? itemImages,
    int? isClaimed,
    int? status,
    DateTime? createdAt,
  }) {
    return LostItem(
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      description: description ?? this.description,
      otherDescription: otherDescription ?? this.otherDescription,
      lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
      tip: tip ?? this.tip,
      hasTip: hasTip ?? this.hasTip,
      itemImages: itemImages ?? this.itemImages,
      isClaimed: isClaimed ?? this.isClaimed,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory LostItem.fromJson(Map<String, dynamic> json) {
    List images = [];
    if (json["item_images"].runtimeType.toString() == "String") {
      images = jsonDecode(json["item_images"]) as List;
    } else {
      images = json["item_images"];
    }
    return LostItem(
      userId: json["user_id"].toString(),
      itemId: json["item_id"],
      description: json["description"],
      otherDescription: json["other_description"],
      lastSeenLocation: json["last_seen_location"],
      tip: double.tryParse(json["tip"].toString()) ?? 0.00,
      hasTip: json["has_tip"]==true,
      itemImages:
          images.map((e) => e.toString()).toList(),
      isClaimed: json["is_claimed"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "item_id": itemId,
        "description": description,
        "other_description": otherDescription,
        "last_seen_location": lastSeenLocation,
        "tip": tip,
        "has_tip": hasTip,
        "item_images": itemImages.map((x) => x).toList(),
        "is_claimed": isClaimed,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
      };

  @override
  String toString() {
    return "$userId, $itemId, $description, $otherDescription, $lastSeenLocation, $tip, $hasTip, $itemImages, $isClaimed, $status, $createdAt, ";
  }
}
