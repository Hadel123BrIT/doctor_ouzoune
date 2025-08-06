import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as dio;
import 'package:ouzoun/models/procedure_model.dart';

import '../../Routes/app_routes.dart';
import '../../models/additionalTool_model.dart';

class ApiServices  {
final Dio dio=Dio();
static const String baseUrl="http://ouzon.somee.com/api";

// RegisterUser
  Future<Response> registerUser({
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String clinicName,
    required String address,
    required double longitude,
    required double latitude,
    String role = 'User',
  }) async {
    try {
      final response = await dio.post(
        "$baseUrl/users/register",
        data: {
          "userName": userName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'clinicName': clinicName,
          'address': address,
          "longtitude": longitude,
          'latitude': latitude,
          "role": role,
        },
        options: Options(
          receiveTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
        ),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      if (e.response != null) {
        print("Error Response Data: ${e.response?.data}");
        print("Error Status Code: ${e.response?.statusCode}");
        return e.response!;
      }
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e) {
      print("General Error: $e");
      throw Exception('An unexpected error occurred: $e');
    }
  }
//------------------------------------------------------------------------

  //LoginUser
  Future<Response> loginUser({required String email,required String password}) async {
  try{
    final response=await dio.post("$baseUrl/users/login",
    data: {
        'email': email,
        'password': password,
        },
      options: Options(
      headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      },
    ),
    );
    print("--------------------------------login");
    print(response.data);
    return response;
  }
  on DioException catch(e){
    if (e.response != null) {
      return e.response!;
    } else {
      throw Exception('Failed to connect to the server: ${e.message}');
    }
  }
}

//---------------------------------------------------------------------------
  //add procedure
  Future<Response> addProcedure(
      Map<String, dynamic> procedureData, {
        String? token,
      }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.post(
        "$baseUrl/procedures",
        data: procedureData,
        options: Options(headers: headers),
      );

      print(response.statusCode);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        throw Exception('Failed to connect to the server: ${e.message}');
      }
    }
  }

//----------------------------------------------------------------------

  //fetchAllProcedures
  Future<List<Procedure>> postFilteredProcedures({
    DateTime? from,
    DateTime? to,
    int? minNumberOfAssistants,
    int? maxNumberOfAssistants,
    String? doctorName,
    String? clinicName,
    String? clinicAddress,
    List<String>? requestBody,
    String? token,
  }) async {
    try {
      final queryParams = {
        if (from != null)
          'from': from.toIso8601String(),
        if (to != null)
          'to': to.toIso8601String(),
        if (minNumberOfAssistants != null)
          'minNumberOfAssistants': minNumberOfAssistants.toString(),
        if (maxNumberOfAssistants != null)
          'maxNumberOfAssistants': maxNumberOfAssistants.toString(),
        if (doctorName != null)
          'doctorName': doctorName,
        if (clinicName != null)
          'clinicName': clinicName,
        if (clinicAddress != null)
          'clinicAddress': clinicAddress,
      };
      final response = await dio.post(
        '$baseUrl/procedures/FilteredProcedure',
        queryParameters: queryParams,
        data: requestBody ?? [],
        options: Options(
          headers: {
            if (token != null)
              'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Full Response: ${response.data}');
      if (response.statusCode == 200) {
        return (response.data as List).map((p) => Procedure.fromJson(p)).toList();
      } else {
        throw Exception('Failed with status: ${response.statusCode}');

      }
    } on DioException catch (e) {
      print('*****************Error: ${e.response?.data}');
      print(e.toString());
      rethrow;
    }
  }

//-----------------------------------------------------------------

  // fetch one procedure
  Future<Map<String, dynamic>> getProcedureDetails(int procedureId) async {
    print('1. Starting getProcedureDetails for ID: $procedureId');
    try {


      final url = '$baseUrl/procedures/$procedureId';
      print('4. Making request to: $url');

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('5. Response received. Status: ${response.statusCode}');
      print('6. Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("**********done************");
        return response.data as Map<String, dynamic>;
      } else {
        print('7. Failed with status: ${response.statusCode}');
        throw Exception('Failed to load procedure details');
      }
    } on DioException catch (e) {
      print('8. DioError: ${e.message}');
      print('9. DioError response: ${e.response?.data}');
      if (e.response?.statusCode == 401) {
        print('10. Unauthorized - redirecting to login');
        Get.offAllNamed(AppRoutes.login);
        throw Exception('Session expired, please login again');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('11. General error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

//--------------------------------------------------------------------

  //fetch procedure by paged
  Future<List<Procedure>> getProceduresPaged({
    required int pageSize,
    required int pageNum,
    required String doctorId,
    required String assistantId,
  }) async {
    try {
      final token = GetStorage().read('auth_token');
      final response = await dio.get(
        '$baseUrl/api/Procedures/GetProceduresPaged',
        queryParameters: {
          'pageSize': pageSize,
          'pageNum': pageNum,
          'DoctorId': doctorId,
          'AssistantId': assistantId,
        },
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => Procedure.fromJson(item))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load paged procedures: ${e.message}');
    }
  }
  //--------------------------------------------------------------------
}