import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:currency_converter/network/api_exception.dart';
import 'dart:async';

class ApiBase {
  final String _baseUrl = 'http://api.currencylayer.com/';
  final String _accessKey = '9b165383a981936866b3b778248b752b';

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url + '?access_key=' + _accessKey);
      responseJson = _response(response);
      if (responseJson['success'] == false) {
        throw ApiRequestException(responseJson['error']['info']);
      }
    } on SocketException {
      throw NoInternetException();
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with Server with StatusCode : ${response.statusCode}');
    }
  }
}