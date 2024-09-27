class PaginationModel {
  final int currentPage;
  final int currentCount;
  final int totalPages;
  final int totalCount;

  const PaginationModel(
      {required this.currentCount,
      required this.currentPage,
      required this.totalCount,
      required this.totalPages});

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
        currentCount: json["currentCount"],
        currentPage: json["currentPage"],
        totalCount: json["totalCount"],
        totalPages: json["totalPages"]);
  }
}