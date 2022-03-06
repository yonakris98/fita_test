import 'package:dio/dio.dart';
import 'package:fita_test/model/ListMusicModel.dart';
import 'package:fita_test/helper.dart' as helper;
import 'dart:convert';

class MusicProvider {
  Dio _dio = Dio();

  Future getSearchArtist(String artistName) async {
    try {
      _dio.options.connectTimeout = 5000; //5s
      _dio.options.receiveTimeout = 3000;

      Response response = await _dio
          .get(helper.endPoint + 'search?term=$artistName&media=music');
      print(response.data);
      final responseJson = json.decode(response.data);
      return ListMusicModel.fromJson(responseJson);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
