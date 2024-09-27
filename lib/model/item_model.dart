import 'dart:convert';

class Items {
  Items(
      {required this.canClaim,
      required this.otherInfo,
      required this.isFound,
      this.claimCode});

  final bool canClaim;
  final bool isFound;
  final String? claimCode;
  final OtherInfo otherInfo;

  Items copyWith(
      {bool? canClaim,
      OtherInfo? otherInfo,
      bool? isFound,
      String? claimCode}) {
    return Items(
        canClaim: canClaim ?? this.canClaim,
        otherInfo: otherInfo ?? this.otherInfo,
        claimCode: claimCode ?? this.claimCode,
        isFound: isFound ?? this.isFound);
  }

  factory Items.fromJson(Map<String, dynamic> json) {
    print(json["claim_code"]);
    return Items(
      canClaim: json["can_claim"] == true,
      isFound: json["is_found"] == true,
      claimCode: json["claim_code"],
      otherInfo: OtherInfo.fromJson(json["other_info"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "can_claim": canClaim,
        "other_info": otherInfo.toJson(),
      };

  @override
  String toString() {
    return "$canClaim, $otherInfo, ";
  }
}

class OtherInfo {
  OtherInfo({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.matchId,
    required this.description,
    required this.otherDescription,
    required this.lastSeen,
    required this.lastSeenLocation,
    required this.itemImages,
    required this.isClaimed,
    this.tip,
    required this.hasTip,
    required this.status,
  });

  final String id;
  final String userId;
  final String itemId;
  final String? matchId;
  final String? description;
  final String? otherDescription;
  final DateTime? lastSeen;
  final String? lastSeenLocation;
  final List<String> itemImages;
  final bool isClaimed;
  final double? tip;
  final bool hasTip;
  final bool status;

  OtherInfo copyWith({
    String? id,
    String? userId,
    String? itemId,
    String? matchId,
    String? description,
    String? otherDescription,
    DateTime? lastSeen,
    String? lastSeenLocation,
    List<String>? itemImages,
    bool? isClaimed,
    double? tip,
    bool? hasTip,
    bool? status,
  }) {
    return OtherInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      matchId: matchId ?? this.matchId,
      description: description ?? this.description,
      otherDescription: otherDescription ?? this.otherDescription,
      lastSeen: lastSeen ?? this.lastSeen,
      lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
      itemImages: itemImages ?? this.itemImages,
      isClaimed: isClaimed ?? this.isClaimed,
      tip: tip ?? this.tip,
      hasTip: hasTip ?? this.hasTip,
      status: status ?? this.status,
    );
  }

  factory OtherInfo.fromJson(Map<String, dynamic> json) {
    List images = [];
    if (json["item_images"].runtimeType.toString() == "String") {
      images = jsonDecode(json["item_images"]) as List;
    } else {
      images = json["item_images"] ?? [];
    }
    return OtherInfo(
      id: json["id"].toString(),
      userId: json["user_id"].toString(),
      itemId: json["item_id"],
      matchId: json["match_id"],
      description: json["description"],
      otherDescription: json["other_description"],
      lastSeen:
          DateTime.tryParse(json["last_seen"] ?? json["created_at"] ?? ""),
      lastSeenLocation: json["last_seen_location"],
      itemImages: images.map((e) => e.toString()).toList(),
      isClaimed: json["is_claimed"] == 1,
      tip: double.tryParse(json["tip"].toString()) ?? 0.00,
      hasTip: json["has_tip"] == true,
      status: json["status"] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "item_id": itemId,
        "match_id": matchId,
        "description": description,
        "other_description": otherDescription,
        "last_seen": lastSeen?.toIso8601String(),
        "last_seen_location": lastSeenLocation,
        "item_images": itemImages.map((x) => x).toList(),
        "is_claimed": isClaimed,
        "status": status,
        "tip": tip,
        "has_tip": hasTip,
      };

  @override
  String toString() {
    return "$id, $userId, $itemId, $matchId, $description, $otherDescription, $lastSeen, $lastSeenLocation, $itemImages, $isClaimed, $status, ";
  }
}
