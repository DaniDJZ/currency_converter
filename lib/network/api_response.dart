class ApiResponse<T> {
  Status status;
  T data;
  String message;
  dynamic error;

  ApiResponse.fetching(this.message) : status = Status.FETCHING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.loaded(this.data) : status = Status.LOADED;
  ApiResponse.error(this.error) : status = Status.ERROR;
}

enum Status { FETCHING, COMPLETED, LOADED, ERROR }