import 'package:lost_items/model/pagination_model.dart';

class ListData<T> {
  final List<T> list;
  final PaginationModel model;

  const ListData({required this.list, required this.model});
}