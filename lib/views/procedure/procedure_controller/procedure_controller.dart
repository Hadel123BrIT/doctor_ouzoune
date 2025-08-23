import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as dio;
import 'package:ouzoun/routes/app_routes.dart';
import '../../../core/services/api_services.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/kit_model.dart';
import '../../../models/procedure_model.dart';
import '../../kits/Kits_Controller/kits_controller.dart';

class ProcedureController extends GetxController {
  final KitsController kitsController = Get.put(KitsController());
  final ApiServices apiServices = Get.put(ApiServices());
  final patientNameController = TextEditingController();
  final needsAssistance = false.obs;
  final assistantsCount = 1.obs;
  final procedureType = 1.obs;
  final procedureDate = Rx<DateTime?>(null);
  final procedureTime = Rx<TimeOfDay?>(null);
  final RxList<Procedure> proceduresList = <Procedure>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool showMainKitsOnly = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<Procedure?> selectedProcedure = Rx<Procedure?>(null);
  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 3.obs;
  final RxBool hasMore = true.obs;
  final RxString clinicNameFilter = ''.obs;
  final RxString clinicAddressFilter = ''.obs;
  final RxInt minAssistants = 0.obs;
  final RxInt maxAssistants = 0.obs;
  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> toDate = Rx<DateTime?>(null);
  final statusFilter = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProcedures();
  }

  // Select Data
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[800]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[800]!,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != procedureDate.value) {
      procedureDate.value = picked;
    }
  }




  //Select Time
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[800]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[800]!,
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: Colors.green[800]!,
              dialBackgroundColor: Colors.green[50]!,
              hourMinuteColor: Colors.green[100]!,
              hourMinuteTextColor: Colors.black,
              dayPeriodColor: Colors.green[100]!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != procedureTime.value) {
      procedureTime.value = picked;
    }
  }





 //Fetch one  Procedure Information
  Map<String, dynamic> getProcedureData() {
    final combinedDateTime = DateTime(
      procedureDate.value!.year,
      procedureDate.value!.month,
      procedureDate.value!.day,
      procedureTime.value!.hour,
      procedureTime.value!.minute,
    );

    return {
      "numberOfAssistants": assistantsCount.value,
      "date": combinedDateTime.toIso8601String(),
      "categoryId": procedureType.value,
      "toolsIds": getAdditionalToolsData(),
      "kitIds": getFullKitsData(),
      "implantTools": getPartialImplantsData(),
    };
  }

  List<Map<String, dynamic>> getAdditionalToolsData() {
    final kitsController = Get.find<KitsController>();

    return kitsController.selectedAdditionalTools.map((tool) {
      final index = kitsController.additionalTools.indexOf(tool);
      final quantity = kitsController.additionalToolQuantities[index] ?? 1;

      return {
        "toolId": tool.id,
        "quantity": quantity,
      };
    }).toList();
  }

  List<int> getFullKitsData() {
    final kitsController = Get.find<KitsController>();

    return kitsController.selectedImplants.values
        .map((implant) => implant.kitId)
        .where((kitId) => kitId != null)
        .cast<int>()
        .toList();
  }

  List<Map<String, dynamic>> getPartialImplantsData() {
    final kitsController = Get.find<KitsController>();

    return kitsController.selectedPartialImplants.map((implant) {
      final implantId = implant.id.toString();

      final toolIds = kitsController.selectedToolsForImplants[implantId] ?? [];

      print('Implant ${implant.id} has selected tools: $toolIds');

      return {
        "implantId": implant.id,
        "toolIds": toolIds,
      };
    }).toList();
  }








  //Post Procedure
  Future<void> postProcedure() async {
    if (procedureDate.value == null || procedureTime.value == null) {
      Get.snackbar('Error'.tr, 'Procedure date and time are required'.tr);
      return;
    }

    try {
      final procedureData = getProcedureData();
      print('Sending procedure data: $procedureData');

      final box = GetStorage();
      final token = box.read('auth_token');

      final response = await apiServices.addProcedure(
        procedureData,
        token: token,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');
      print('Headers: ${response.headers}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(AppRoutes.homepage);
        Get.snackbar('Success'.tr, 'Procedure added successfully'.tr);
        await Future.delayed(const Duration(milliseconds: 700));
      }

      else {
        if (response.data is Map<String, dynamic>) {
          final errorMsg = response.data['message'] ??
              response.data['error'] ??
              'Failed with status ${response.statusCode}';
          Get.snackbar('Error'.tr, errorMsg
              .toString()
              .tr);
        } else if (response.data is String) {
          Get.snackbar('Error'.tr, response.data.tr);
        }
      }
    } catch (e) {
      print('Error type: ${e.runtimeType}');
      Get.snackbar('Error'.tr, 'An error occurred: ${e.toString()}'.tr);
    }
  }






  // fetch for all procedures
  Future<void> fetchAllProcedures() async {
    isLoading.value = true;
    try {
      final token = GetStorage().read('auth_token') as String?;

      if (token == null || token.isEmpty) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      final procedures = await apiServices.postFilteredProcedures(
        from: fromDate.value,
        to: toDate.value,
        minNumberOfAssistants: minAssistants.value > 0 ? minAssistants.value : null,
        maxNumberOfAssistants: maxAssistants.value > 0 ? maxAssistants.value : null,
        doctorName: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        clinicName: clinicNameFilter.value.isNotEmpty ? clinicNameFilter.value : null,
        clinicAddress: clinicAddressFilter.value.isNotEmpty ? clinicAddressFilter.value : null,
        status: statusFilter.value > 0 ? statusFilter.value : null,
        requestBody: [],
        token: token,
      );

      print('====== Fetched Procedures (${procedures.length}) ======');
      for (var i = 0; i < procedures.length; i++) {
        print('Procedure #${i + 1}:');
        print('  ID: ${procedures[i].id}');
        print('  Status: ${procedures[i].status}');
        print('  Date: ${procedures[i].date}');
        print('  Doctor: ${procedures[i].doctor.userName} (ID: ${procedures[i].doctor.id})');
        print('  Number of Assistants: ${procedures[i].numberOfAssistants}');
        print('  Ids of Assistants: ${procedures[i].assistantIds}');
      //  print('  Name of Assistants: ${procedures[i].assistants[i].userName}');
        print('----------------------------------');
        if (procedures[i].numberOfAssistants != procedures[i].assistants.length) {
          print('Warning: Mismatch in assistants count!');
          print('Expected: ${procedures[i].numberOfAssistants}, Actual: ${procedures[i].assistants.length}');
        }
      }

      proceduresList.assignAll(procedures);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('Error details: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }







  //Fetch Procedure by Pages
  Future<void> fetchProceduresPaged({
    bool loadMore = false,
    String? doctorId,
  }) async {
    try {
      if (!loadMore) {
        currentPage.value = 1;
        proceduresList.clear();
      }

      isLoading.value = true;

      String? targetDoctorId = doctorId;
      if (targetDoctorId == null && proceduresList.isNotEmpty) {
        targetDoctorId = proceduresList.first.doctor.id;
      }

      final response = await apiServices.getProceduresPaged(
        pageSize: itemsPerPage.value,
        pageNum: currentPage.value,
        doctorId: targetDoctorId ?? "",
        assistantId: '',
      );

      if (response.isNotEmpty) {
        proceduresList.addAll(response);
        currentPage.value++;
        hasMore.value = response.length >= itemsPerPage.value;
        print('Fetched procedures for doctor IDs:');
        for (var proc in response) {
          print('- Procedure ${proc.id} -> Doctor ${proc.doctor.id}');
        }
      } else {
        hasMore.value = false;
        print('No procedures found for doctorId: $targetDoctorId');
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to load procedures: ${e.toString()}'.tr);
      print('Error fetching procedures: $e');
    } finally {
      isLoading.value = false;
    }
  }





  // get one procedure details
  Future<void> fetchProcedureDetails(int procedureId) async {
    try {
      isLoading(true);
      final response = await apiServices.getProcedureDetails(procedureId);

      print('API Response: $response');

      if (response != null) {
        selectedProcedure.value = Procedure.fromJson(response);

        // طباعة تفصيلية للبيانات
        print('Procedure Details:');
        print('- ID: ${selectedProcedure.value?.id}');
        print('- AssisitancsId: ${selectedProcedure.value?.assistantIds}');
        print('- Assistants: ${selectedProcedure.value?.assistants?.length ?? 0}');
        print('- Tools: ${selectedProcedure.value?.tools?.length ?? 0}');
        print('- Kits: ${selectedProcedure.value?.kits?.length ?? 0}');
      }
    } catch (e) {
      print('Error fetching procedure: $e');
    } finally {
      isLoading(false);
    }
  }

  //---------------------------------------------------------------------

  List<Procedure> get filteredProcedures {
    return proceduresList.where((procedure) {
      final matchesSearch = procedure.doctor.userName
          ?.toLowerCase()
          .contains(searchQuery.value.toLowerCase());

      final matchesStatus = statusFilter.value == 0 ||
          procedure.status == statusFilter.value;

      final matchesKitFilter = !showMainKitsOnly.value ||
          procedure.kits.any((kit) => kit.isMainKit);

      return matchesSearch! && matchesStatus && matchesKitFilter;
    }).toList();
  }


  //-------------------------------------------------------------

  //Update the list
  void updateItemsPerPage(int value) {
    itemsPerPage.value = value;
    fetchProceduresPaged();
  }

  //--------------------------------------------------------------
  void resetFilters() {
    searchQuery.value = '';
    clinicNameFilter.value = '';
    clinicAddressFilter.value = '';
    minAssistants.value = 0;
    maxAssistants.value = 10;
    fromDate.value = null;
    toDate.value = null;
    statusFilter.value=0;
    fetchAllProcedures();
  }


  Future<void> changeProcedureStatus(int procedureId, int newStatus) async {
    try {
      final token = GetStorage().read('auth_token') as String?;

      if (token == null || token.isEmpty) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      final response = await apiServices.changeProcedureStatus(
        procedureId: procedureId,
        newStatus: newStatus,
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201 ) {

        final procedureIndex = proceduresList.indexWhere((p) => p.id == procedureId);
        if (procedureIndex != -1) {
          proceduresList[procedureIndex].status = newStatus;
          proceduresList.refresh();
        }

        Get.snackbar(
          'Success'.tr,
          'Procedure status updated successfully'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to change status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to update procedure status: ${e.response?.data ?? e.message}'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'An unexpected error occurred: ${e.toString()}'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    patientNameController.dispose();
    super.onClose();
  }
}