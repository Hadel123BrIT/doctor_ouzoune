import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as dio;
import 'package:ouzoun/models/procedure_model.dart';
import '../../Routes/app_routes.dart';
import '../../models/Implant_model.dart';
import '../../models/additionalTool_model.dart';
import '../../models/kit_model.dart';

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
    String? deviceToken,
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
          'deviceToken': deviceToken,
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




  //LoginUser
  Future<Response> loginUser({required String email,required String password,String? deviceToken,}) async {
  try{
    final response=await dio.post("$baseUrl/users/login",
    data: {
        'email': email,
        'password': password,
      'deviceToken': deviceToken,
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
        print(e.toString());
        throw Exception('Failed to connect to the server: ${e.message}');
      }
    }
  }







  //fetchAllProcedures
  Future<List<Procedure>> postFilteredProcedures({
    DateTime? from,
    DateTime? to,
    int? minNumberOfAssistants,
    int? maxNumberOfAssistants,
    String? doctorName,
    String? clinicName,
    String? clinicAddress,
    int? status,
    List<String>? requestBody,
    required String token,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (from != null) queryParams['from'] = from.toIso8601String();
      if (to != null) queryParams['to'] = to.toIso8601String();
      if (minNumberOfAssistants != null) {
        queryParams['minNumberOfAssistants'] = minNumberOfAssistants;
      }
      if (maxNumberOfAssistants != null) {
        queryParams['maxNumberOfAssistants'] = maxNumberOfAssistants;
      }
      if (doctorName != null && doctorName.isNotEmpty) {
        queryParams['doctorName'] = doctorName;
      }
      if (clinicName != null && clinicName.isNotEmpty) {
        queryParams['clinicName'] = clinicName;
      }
      if (clinicAddress != null && clinicAddress.isNotEmpty) {
        queryParams['clinicAddress'] = clinicAddress;
      }
      if (status != null && status > 0) {
        queryParams['status'] = status;
      }

      print('Sending query params: $queryParams');

      final response = await dio.post(
        '$baseUrl/procedures/FilteredProcedure',
        queryParameters: queryParams,
        data: requestBody ?? [],
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is List && response.data.isNotEmpty && response.data[0] is String) {
          print('No data found: ${response.data[0]}');
          return [];
        }
        if (response.data is List) {
          print('===== RAW PROCEDURES DATA =====');
          for (var item in response.data as List) {
            print(item);
            if (item is Map) {
              print('Assistants data in response: ${item['assistants']}');
              print('Number of assistants in response: ${item['numberOfAssistants']}');
            }
          }
          return (response.data as List).map((p) => Procedure.fromJson(p)).toList();
        }
        print('Unexpected response format: ${response.data}');
        return [];
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.data}');
      if (e.response?.statusCode == 401) {
        Get.offAllNamed(AppRoutes.login);
        Get.snackbar('Session Expired', 'Please login again');
      } else {
        Get.snackbar('Error', e.response?.data.toString() ?? e.message!);
      }
      return [];
    }
  }






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
          validateStatus: (status) => status! < 500, // قبول status codes أقل من 500
        ),
      );

      print('5. Response received. Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("**********done************");

        // تحقق من أن البيانات هي Map
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          print('Unexpected response format: ${response.data.runtimeType}');
          throw Exception('Invalid response format');
        }
      } else {
        print('7. Failed with status: ${response.statusCode}');
        print('Response data: ${response.data}');
        throw Exception('Failed to load procedure details: ${response.statusCode}');
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






  //fetch procedure by paged
  Future<List<Procedure>> getProceduresPaged({
    required int pageSize,
    required int pageNum,
    String? doctorId,
    String? assistantId,
  }) async {
    try {
      final token = GetStorage().read('auth_token');
      final response = await dio.get(
        '$baseUrl/procedures/paged',
        queryParameters: {
          'pageSize': pageSize,
          'pageNum': pageNum,
          if (doctorId != null && doctorId.isNotEmpty) 'doctorId': doctorId,
          if (assistantId != null && assistantId.isNotEmpty) 'assistantId': assistantId,
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



  Future<Response> changeProcedureStatus({
    required int procedureId,
    required int newStatus,
    required String token,
  }) async {
    try {
      final response = await dio.patch(
        '$baseUrl/procedures/ChangeStatus',
        data: {
          'procedureId': procedureId,
          'newStatus': newStatus,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        throw Exception('Failed to connect to the server: ${e.message}');
      }
    }
  }




  //fetch my profile
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final token = GetStorage().read('auth_token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await dio.get(
        '$baseUrl/users/current',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Profile data fetched successfully");
        print(response.data);

        // تأكد أن البيانات هي Map<String, dynamic>
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          // إذا كانت البيانات ليست بالصيغة المتوقعة
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load profile. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
      }
      throw Exception('Failed to load profile: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }







  // update my profile
  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> data) async {
    try {
      final token = GetStorage().read('auth_token');
      final response = await dio.put(
        '$baseUrl/api/Account/update-profile',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to update profile');
    } on DioException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }









  // getAdditionalTools
  Future<List<AdditionalTool>> getAdditionalTools() async {
    try {
      final token = GetStorage().read('auth_token');
      final response = await dio.get(
        'http://ouzon.somee.com/api/tools',
        options: Options(
          headers: {
            if (token != null)
              'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return (response.data as List)
            .map((tool) => AdditionalTool.fromJson(tool))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load tools: ${e.message}');
    }
  }










  Future<Response> submitRating({
    required String note,
    required int rate,
    required String assistantId,
    String? procedureId,
    required String token,
  }) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        "$baseUrl/Ratings",
        data: {
          "note": note,
          "rate": rate,
          "assistantId": assistantId,
          if (procedureId != null) "procedureId": procedureId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to submit rating');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }




  //select assistance
  Future<List<Map<String, dynamic>>> getAssistantsFromProcedures(String token) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "http://ouzon.somee.com/api/procedures/FilteredProcedure",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: [],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final procedures = response.data as List;
        final assistants = <Map<String, dynamic>>[];
        final Set<String> addedAssistantIds = {}; // لتجنب التكرار

        for (var procedure in procedures) {
          if (procedure['assistants'] != null && procedure['assistants'].isNotEmpty) {
            for (var assistant in procedure['assistants']) {
              final assistantId = assistant['id']?.toString();
              if (assistantId != null && !addedAssistantIds.contains(assistantId)) {
                assistants.add({
                  'id': assistantId,
                  'name': assistant['userName'] ?? 'Unknown',
                  'specialization': assistant['specialization'] ?? 'No Specialization',
                  'email': assistant['email'] ?? '',
                  'phone': assistant['phoneNumber'] ?? '',
                  'clinic': assistant['clinic']?['name'] ?? '',
                });
                addedAssistantIds.add(assistantId);
              }
            }
          }
        }

        if (assistants.isEmpty) {
          print('No assistants found in any procedure');
        }

        return assistants;
      } else {
        throw Exception('Failed to load procedures: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load assistants: ${e.message}');
    }
  }


  //get implants
  Future<List<Implant>> getImplants() async {
    try {
      final token = await GetStorage().read('auth_token');
      final response = await dio.get(
        '$baseUrl/implants',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Implants API Response: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : response.data['data'];
        return data.map((json) => Implant.fromJson(json)).toList();
      }
      throw Exception('Failed with status ${response.statusCode}');
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.data}');
      throw e;
    }
  }

  // get kits
  Future<List<Kit>> getKits() async {
    try {
      final token = GetStorage().read('auth_token');
      final response = await dio.get(
        '$baseUrl/kits',
        options: Options(
          headers: {
            if (token != null)
              'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return (response.data as List).map((json) => Kit.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load tools: ${e.message}');
  }}


  Future<Kit> getKitById(int kitId) async {
    try {
      final token = GetStorage().read('auth_token');
      debugPrint('Token: ${token != null ? "Exists" : "NULL"}');

      debugPrint('Requesting kit details for ID: $kitId');
      final response = await dio.get(
        '$baseUrl/kits/$kitId',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 200) {
        try {
          final kit = Kit.fromJson(response.data);
          debugPrint('Parsed kit with ${kit.tools.length} tools');
          return kit;
        } catch (e) {
          debugPrint('Parsing error: $e');
          throw Exception('Failed to parse kit data: $e');
        }
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.message}');
      debugPrint('Error response: ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }


  Future<Response> getCurrentUserNotifications() async {
    try {
      final String? deviceToken = GetStorage().read('device_token');
      final String? authToken =  GetStorage().read('auth_token');

      if (deviceToken == null || authToken == null) {
        throw Exception('Device token or auth token is missing');
      }

      final response = await dio.post(
        '$baseUrl/Notifications/CurrnetUserNotifications',
        data: {'deviceToken': deviceToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      if (e.response != null) {
        return e.response!;
      }
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e) {
      print('General Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }


  Future<Response> sendNotification({
    required String title,
    required String body,
  }) async {
    try {
      final String? authToken =  GetStorage().read('auth_token');

      if (authToken == null) {
        throw Exception('Auth token is missing');
      }

      final response = await dio.post(
        '$baseUrl/Notifications/SendNotification',
        data: {
          'title': title,
          'body': body,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        throw Exception('Failed to connect to the server: ${e.message}');
      }
    }
  }







}