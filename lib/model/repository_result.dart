class RepositoryResult<T> {
  final bool status;
  final String message;
  final T result;
  final Map<String, dynamic> extra;

  const RepositoryResult(
      {required this.message, required this.status, required this.result,this.extra = const {}});
}
