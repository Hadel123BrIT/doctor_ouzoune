import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as dio;
import 'package:ouzoun/routes/app_routes.dart';
import '../../../core/services/api_services.dart';
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
  final RxInt statusFilter = 0.obs;
  final RxBool showMainKitsOnly = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<Procedure?> selectedProcedure = Rx<Procedure?>(null);
  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 3.obs;
  final RxBool hasMore = true.obs;
  final RxString clinicNameFilter = ''.obs;
  final RxString clinicAddressFilter = ''.obs;
  final RxInt minAssistants = 0.obs;
  final RxInt maxAssistants = 10.obs;
  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> toDate = Rx<DateTime?>(null);

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

  //------------------------------------------------------------

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

//-----------------------------------------------------------------

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
      "numberOfAssistants": needsAssistance.value ? assistantsCount.value : 0,
      "date": combinedDateTime.toIso8601String(),
      "categoryId": procedureType.value,
      "toolsIds": getAdditionalToolsData(),
      "kitIds": getFullKitsData(),
      "implantTools": getPartialImplantsData(),
    };
  }

  List<Map<String, dynamic>> getAdditionalToolsData() {
    return kitsController.selectedTools.where((tool) => tool['id'] != null).map((tool) => {
      "toolId": tool['id'],
      "quantity": int.tryParse(tool['quantity']?.toString() ?? '1') ?? 1,
    }).toList();
  }

  List<int> getFullKitsData() {
    return kitsController.selectedImplants.keys
        .map((id) => int.tryParse(id.toString()) ?? 0)
        .where((id) => id > 0)
        .toList();
  }

  List<Map<String, dynamic>> getPartialImplantsData() {
    return kitsController.selectedPartialImplants.map((item) {
      List<int> toolIds = [];
      if (!(item['tools'] as List<String>).contains('No tools')) {
        toolIds = (item['tools'] as List<String>)
            .map((toolName) => kitsController.getToolIdByName(toolName))
            .toList();
      }

      return {
        "implantId": int.parse(item['implantId']),
        "toolIds": toolIds,
      };
    }).toList();
  }

//--------------------------------------------------------------------

  //Post Procedure
  Future<void> postProcedure() async {
    if (patientNameController.text.isEmpty) {
      Get.snackbar('Error'.tr, 'Patient name is required'.tr);
      return;
    }
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(AppRoutes.homepage);
        Get.snackbar('Success'.tr, 'Procedure added successfully'.tr);
        await Future.delayed(const Duration(milliseconds: 700));
      }

      else {
        final errorMsg = response.data['message'] ??
            response.data['error'] ??
            'Failed with status ${response.statusCode}';
        Get.snackbar('Error'.tr, errorMsg.toString().tr);
      }
    } catch (e) {
      Get.snackbar('************************************Error'.tr, 'An error occurred: ${e.toString()}'.tr);
      print(e.toString());
      print('--------------------------------Full error details: $e');
    }
  }

//--------------------------------------------------------------------

  // fetch for all procedures
  Future<void> fetchAllProcedures() async {
    isLoading.value = true;
    try {
      final box = GetStorage();
      final token = box.read('auth_token');

      final procedures = await apiServices.postFilteredProcedures(
        from: fromDate.value,
        to: toDate.value,
        minNumberOfAssistants: minAssistants.value,
        maxNumberOfAssistants: maxAssistants.value,
        doctorName: searchQuery.value.isEmpty ? null : searchQuery.value,
        clinicName: clinicNameFilter.value.isEmpty ? null : clinicNameFilter.value,
        clinicAddress: clinicAddressFilter.value.isEmpty ? null : clinicAddressFilter.value,
        requestBody: [],
        token: token,
      );

      proceduresList.assignAll(procedures);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

//---------------------------------------------------------------------

  //Fetch Procedure by Pages
  Future<void> fetchProceduresPaged({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        currentPage.value = 1;
        proceduresList.clear();
      }

      isLoading.value = true;

      final response = await apiServices.getProceduresPaged(
        pageSize: itemsPerPage.value,
        pageNum: currentPage.value,
        doctorId: 'your_doctor_id',
        assistantId: 'your_assistant_id',
      );

      if (response.isNotEmpty) {
        proceduresList.addAll(response);
        currentPage.value++;
        hasMore.value = response.length >= itemsPerPage.value;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to load procedures'.tr);
    } finally {
      isLoading.value = false;
    }
  }

//------------------------------------------------------------------------

  // get one procedure details
  Future<void> fetchProcedureDetails(int procedureId) async {
    try {
      isLoading.value = true;
      final procedure = await apiServices.getProcedureDetails(procedureId);
      selectedProcedure.value = procedure;
    } catch (e) {
      Get.snackbar('Error'.tr, 'Failed to load procedure details'.tr);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  //---------------------------------------------------------------------

  List<Procedure> get filteredProcedures {
    return proceduresList.where((procedure) {
      final matchesSearch = procedure.doctor.userName
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());

      final matchesStatus = statusFilter.value == 0 ||
          procedure.status == statusFilter.value;

      final matchesKitFilter = !showMainKitsOnly.value ||
          procedure.kits.any((kit) => kit.isMainKit);

      return matchesSearch && matchesStatus && matchesKitFilter;
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

    fetchAllProcedures();
  }
  @override
  void onClose() {
    patientNameController.dispose();
    super.onClose();
  }
}