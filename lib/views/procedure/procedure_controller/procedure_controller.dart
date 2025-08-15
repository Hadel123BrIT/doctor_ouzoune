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
      "numberOfAssistants": assistantsCount ,
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
    return kitsController.selectedPartialImplants.map((implant) {
      final kit = kitsController.kits.firstWhere(
            (k) => k.id == implant.kitId,
        orElse: () => Kit(
          id: 0,
          name: 'Unknown Kit',
          isMainKit: false,
          implantCount: 0,
          toolCount: 0,
          implants: [],
          tools: [],
        ),
      );

      List<int>? toolIds = [];
      if (implant.tools != null && !implant.tools!.contains('No tools')) {
        toolIds = implant.tools!.map((toolName) {

          final tool = kit.tools.firstWhere(
                (t) => t.name == toolName,
            orElse: () => AdditionalTool(
              id: 0,
              name: '',
              width: 0,
              height: 0,
              thickness: 0,
              quantity: 0,
              categoryId: 0,
            ),
          );
          return tool.id;
        }).where((id) => id != 0).cast<int>().toList(); // تصفية الأدوات غير المعروفة
      }

      return {
        "implantId": implant.id,
        "toolIds": toolIds,
      };
    }).toList();
  }

//--------------------------------------------------------------------

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

//--------------------------------------------------------------------

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

//---------------------------------------------------------------------

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

//------------------------------------------------------------------------

  // get one procedure details
  Future<void> fetchProcedureDetails(int procedureId) async {
    try {
      isLoading(true);
      final responseData = await apiServices.getProcedureDetails(procedureId);

      if (responseData != null) {
        selectedProcedure.value = Procedure.fromJson(responseData);
        print( selectedProcedure.value);
      } else {
        throw Exception('No data received');
      }

    } on DioException catch (e) {
      Get.snackbar('Error'.tr, 'Failed to load procedure details: ${e.message}'.tr);
    } catch (e) {
      Get.snackbar('Error'.tr, 'Unexpected error: ${e.toString()}'.tr);
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
  @override
  void onClose() {
    patientNameController.dispose();
    super.onClose();
  }
}