
import 'package:dio/dio.dart';

class dio_helper{
  static Dio? dio;

  static init(){
  dio=Dio(
      BaseOptions(
        baseUrl: "https://fcm.googleapis.com/fcm/send",
        receiveDataWhenStatusError: true,
        headers: {
          "Content-Type":"application/json"
        }

      )
  );

  }

  static Future<Response> get_data({
  required String url,
     Map<String,dynamic>? quiries,
    String lang="ar",
    String? token,

})async{

    dio!.options.headers={
      "lang":lang,
      "Authorization":token
    };
    return await dio!.get(url,queryParameters: quiries);


}


  static Future<Response> post_data({
    required String url,

    required Map<String,dynamic> data,


  })async{

    dio!.options.headers={
    "Authorization":"key=AAAAjtmpXN8:APA91bHT4zQOj0Ea47aE8o8E0xRNQrJbF-Vr7Qa0f38DjaN5whged7vrrKnwF5mtzFHwCM6xCZKSZuBL_kdBYocl_PoU9f_l0XR3b6WE6A_0dEqJNtofFQUWBGFEFOVADAKGsLJUUGLK"
    };
    return await dio!.post(url,data: data);


  }



  static Future<Response> put_data({
    required String url,
    String lang="en",
    String? token,

    required Map<String,dynamic> data,


  })async{
    dio!.options.headers={
      "lang":lang,
      "Authorization":token
    };

    return await dio!.put(url,data: data);


  }




}