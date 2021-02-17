class ApiResponse<T> {
  Status status;
  T data;
  String message;
  dynamic error;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.error) : status = Status.ERROR;
}

enum Status { LOADING, COMPLETED, ERROR }