import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as DIO;
import 'package:dio/io.dart';
import 'package:get/get.dart';
import '../util/CommonWidget.dart';
import '../util/Injection.dart';
import '../util/RouteHelper.dart';
import '../util/local_storage.dart';
import 'WebService.dart';

class ApiService extends GetxService {
  final DIO.Dio dio =DIO.Dio(); //getDio();
  final int timeoutInSeconds = 30;
  final DIO.LogInterceptor loggingInterceptor = DIO.LogInterceptor();

  //For getMethod
  Future<dynamic> getMethod(String endPoint,{Map<String, dynamic>? header}) async {
    DIO.Response? response;

    try {
      print("baseUrl --- ${DI<WebService>().BASE_URL + endPoint} ");

      response = await dio.get(DI<WebService>().BASE_URL + endPoint,
          options: DIO.Options(
          headers:header?? {
            "Content-Type": "application/json", // Ensure it's sent as raw JSON
          },
          ),);
      return returnResponse(response);
    } catch (e) {
      if (e is DIO.DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response!);
  }

  Future<dynamic> getMethodWithBody(String endPoint,{Map<String, dynamic>? header,Map<String,dynamic>? body}) async {
    DIO.Response? response;

    var data = json.encode(body);

    try {
      print("baseUrl --- ${DI<WebService>().BASE_URL + endPoint} ");
      response = await dio.get(DI<WebService>().BASE_URL + endPoint,
          options: DIO.Options(
            headers:header?? {
              "Content-Type": "application/json", // Ensure it's sent as raw JSON
            },
          ),
          data: data);
      return returnResponse(response);
    } catch (e) {
      if (e is DIO.DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response!);
  }

  //For postMethod
  Future<dynamic> postMethod(
      String endPoint, Map<String, dynamic>? body,
      {Map<String, dynamic>? header})
  async {
    DIO.Response? response;
    try {
      print("baseUrl post--- ${DI<WebService>().BASE_URL}$endPoint");
      print("header--- $header");

      final formData = DIO.FormData.fromMap(body??{});

      response = await dio.post(
        "${DI<WebService>().BASE_URL}$endPoint",
        data: formData,
        options: DIO.Options(
          headers: {
            "Content-Type": "application/json",
            ...?header,
          },
        ),
      );
      return returnResponse(response);
    } catch (e) {
      if (e is DIO.DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error:-- ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response!);
  }

  //For putMethod
  Future<dynamic> putMethod(
      String endPoint, Map<String, dynamic>? body,
      {Map<String, dynamic>? header})
  async {
    DIO.Response? response;
    try {
      print("baseUrl post--- ${DI<WebService>().BASE_URL}$endPoint");
      print("header--- $header");

      final formData = DIO.FormData.fromMap(body??{});

      response = await dio.put(
        "${DI<WebService>().BASE_URL}$endPoint",
        data: body,
        options: DIO.Options(
          headers: {
            "Content-Type": "application/json",
            ...?header,
          },
        ),
      );
      return returnResponse(response);
    } catch (e) {
      if (e is DIO.DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error:-- ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response!);
  }

  //For post method with FormData (file upload)
  Future<dynamic> postMethodWithFormData(
      String endPoint, DIO.FormData formData,
      {Map<String, dynamic>? header})
  async {
    DIO.Response? response;
    try {
      print("baseUrl postFormData--- ${DI<WebService>().BASE_URL}$endPoint");

      response = await dio.post(
        "${DI<WebService>().BASE_URL}$endPoint",
        data: formData,
        options: DIO.Options(
          headers: {
            "Content-Type": "multipart/form-data",
            ...?header,
          },
        ),
      );
      return returnResponse(response);
    } catch (e) {
      if (e is DIO.DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error:-- ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response!);
  }

  //For multipart method
  Future<dynamic> multipartPostMethod(String endPoint, String profileKeyName,
      String filePath, Map<String, dynamic> body, header)
  async {
    print("filePath2 : $profileKeyName");
    DIO.FormData? formData;

    formData = DIO.FormData.fromMap({
      ...body, // Spread operator to add existing map data
      if (filePath.isNotEmpty)
        profileKeyName: await DIO.MultipartFile.fromFile(filePath,
            filename: filePath.split('/').last.toString(),
            contentType: DIO.DioMediaType(
                'image', filePath.split('/').last.split('.').last.toString())),
    });

    var response;

    try {
      response = await dio.post(
        DI<WebService>().BASE_URL + endPoint,
        data: formData,
        options: DIO.Options(headers: header),
      );
    } catch (e) {
      if (e is DIO.DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error: ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response);
  }

  //For Multiple multipart method
  Future<dynamic> multipartMultiplePostMethod(String endPoint, String mainImageKey,
      String mainImageFilePath,String galleryImageKey, List<File> galleryImagePaths, Map<String, dynamic> body, header)
  async {
    print("mainImageKey : $mainImageKey");
    DIO.FormData? formData;

    formData = DIO.FormData.fromMap({
      ...body, // Spread operator to add existing map data
    });
    if (mainImageFilePath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          mainImageKey,
          await DIO.MultipartFile.fromFile(
            mainImageFilePath,
            filename: mainImageFilePath.split('/').last,
            contentType: DIO.DioMediaType(
              'image',
              mainImageFilePath.split('.').last,
            ),
          ),
        ),
      );
    }




    for (final file in galleryImagePaths) {
      if (file.path.isNotEmpty) {
        formData.files.add(
          MapEntry(
            galleryImageKey, // SAME key every time
            await DIO.MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: DIO.DioMediaType(
                'image',
                file.path.split('.').last,
              ),
            ),
          ),
        );
      }
    }
    var response;

    try {
      response = await dio.post(
        DI<WebService>().BASE_URL + endPoint,
        data: formData,
        options: DIO.Options(headers: header),
      );
    } catch (e) {
      if (e is DIO.DioException) {
        if (e.response != null) {
          response = e.response;
          return returnResponse(e.response!);
        } else {
          log("Error: ${e.message}");
        }
      } else {
        log("NO Dio Error: $e");
      }
    }
    return returnResponse(response);
  }


  Future<DIO.Response> returnResponse(DIO.Response response) async {
    if(response.data["success"].toString() == "false"){


      if(response.data["message"].toString() == "Invalid access token"){

          DI<MyLocalStorage>().clearLocalStorage();
          Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
          return response;
        }

      DI<CommonWidget>().errorDialog(response.data["message"].toString(), () {
      
        Get.back();
      });

      return response;
    }

    if (response.statusCode != 200) {
      print("response code:-- ${response.data["error"]["code"]}");
      print("response :-- ${response.data["error"]["message"]}");

        DI<CommonWidget>().errorDialog(response.data["error"]["message"], () {
          Get.back();
        });

      return response;
    }
    return response;
  }
}

DIO.Dio getDio() {
  final dio = DIO.Dio();

  // Bypass SSL error
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  return dio;
}