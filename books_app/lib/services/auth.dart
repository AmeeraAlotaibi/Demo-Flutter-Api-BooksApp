import 'package:books_app/models/user.dart';
import 'package:books_app/services/client.dart';
import 'package:dio/dio.dart';

class AuthService {
  Future<String> signup({required User user}) async {
    late String token;
    try {
      Response response = await Client.dio.post('/signup', data: user.toJson());
      token = response.data["token"];
      print("you have created a new account with token $token");
    } on DioError catch (error) {
      print(error);
    }
    return token;
  }

  Future<String> signin({required User user}) async {
    late String token;
    try {
      Response response = await Client.dio.post('/signin', data: user.toJson());
      token = response.data["token"];
      print("you have logged in with token $token");
    } on DioError catch (error) {
      print(error);
    }
    return token;
  }
}
