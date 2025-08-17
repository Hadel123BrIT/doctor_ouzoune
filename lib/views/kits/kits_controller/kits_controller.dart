import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/services/api_services.dart';
import '../../../models/Implant_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/kit_model.dart';

class KitsController extends GetxController {
  final List<Map<String, dynamic>> surgicalKits = [
    {
      'name': 'Dental Drill',
      'image': 'assets/images/forceps.png',
      'length': '15 cm',
      'width': '3 cm',
      'thickness': '2 cm',
      'quantity': "0",
    },
    {
      'name': 'Surgical Scissors',
      'image': 'assets/images/mouth-mirror.png',
      'length': '12 cm',
      'width': '4 cm',
      'thickness': '0.5 cm',
      'quantity': "3",
    },
    {
      'name': 'Bone File',
      'image': 'assets/images/probe.png',
      'length': '18 cm',
      'width': '2 cm',
      'thickness': '0.8 cm',
      'quantity': "2",
    },
    {
      'name': 'Retractor',
      'image': 'assets/images/tooth.png',
      'length': '20 cm',
      'width': '5 cm',
      'thickness': '1 cm',
      'quantity': "1",
    },
    {
      'name': 'Dental Drill',
      'image': 'assets/images/forceps.png',
      'length': '15 cm',
      'width': '3 cm',
      'thickness': '2 cm',
      'quantity': "4",
    },
    {
      'name': 'Surgical Scissors',
      'image': 'assets/images/mouth-mirror.png',
      'length': '12 cm',
      'width': '4 cm',
      'thickness': '0.5 cm',
      'quantity': "5",
    },
  ];
  final RxList<Implant> implants = <Implant>[].obs;
  final RxList<Kit> kits = <Kit>[].obs;
  final RxList<AdditionalTool> additionalTools = <AdditionalTool>[].obs;
  final RxList<int> additionalToolQuantities = <int>[].obs;
  final RxList<AdditionalTool> selectedAdditionalTools = <AdditionalTool>[].obs;
  final RxList<int> toolQuantities = <int>[].obs;
  final RxMap<String, bool> tools = <String, bool>{}.obs;
  final RxInt selectedToolsCount = 0.obs;
  final RxList<int> surgicalToolQuantities = <int>[].obs;
  final RxList<Map<String, dynamic>> selectedSurgicalTools = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> selectedTools = <Map<String, dynamic>>[].obs;
  final RxMap<String, Implant> selectedImplantDetails = <String, Implant>{}.obs;
  final RxList<Implant> selectedPartialImplants = <Implant>[].obs;
  final Rx<Kit?> selectedKit = Rx<Kit?>(null);
  final RxBool isLoading = true.obs;
  final RxMap<int, String> implantNames = <int, String>{}.obs;
  final RxMap<int, List<String>> kitToolNames= <int, List<String>>{}.obs;
  final RxMap<String, Implant> selectedImplants = <String, Implant>{}.obs;
  final RxMap<String, List<int>> selectedToolsForImplants = <String, List<int>>{}.obs;
  final RxMap<int, List<AdditionalTool>> kitTools = <int, List<AdditionalTool>>{}.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading(true);
      await Future.wait([
        fetchImplants(),
        fetchKits(),
        fetchAdditionalTools(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchImplants() async {
    try {
      final data = await ApiServices().getImplants();
      if (data.isEmpty) {
        Get.snackbar('Info', 'No implants found');
      }
      implants.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load implants: ${e.toString()}',
        duration: Duration(seconds: 5),
      );
      implants.clear();
      rethrow;
    }
  }

  Future<void> fetchKits() async {
    try {
      final List<Kit> kitsData = await ApiServices().getKits();
      debugPrint('Number of kits loaded: ${kitsData.length}');

      kits.assignAll(kitsData);

      for (final kit in kits) {
        debugPrint('Kit ID: ${kit.id} has ${kit.tools.length} tools');
      }
    } catch (e) {
      debugPrint('Error fetching kits: $e');
      Get.snackbar('Error', 'Failed to load kits: ${e.toString()}');
      kits.clear();
    }
  }

  Future<void> fetchAdditionalTools() async {
    try {
      final data = await ApiServices().getAdditionalTools();
      additionalTools.assignAll(data);
      additionalToolQuantities.assignAll(List.filled(data.length, 0));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tools: ${e.toString()}');
      additionalTools.clear();
    }
  }




  String getImplantName() {
    return selectedKit.value?.name ?? 'No Kit Loaded';
  }

  List<AdditionalTool> getKitTools() {
    return selectedKit.value?.tools ?? [];
  }

  List<String?> getKitToolNames() {
    if (selectedKit.value == null) return ['No kit loaded'];
    return selectedKit.value!.tools.map((tool) => tool.name).toList();
  }



  List<String> getToolNamesByKitId(int kitId) {
    // التحقق من الذاكرة المؤقتة أولاً
    if (kitToolNames.containsKey(kitId)) {
      return kitToolNames[kitId]!;
    }

    final tools = getToolsByKitId(kitId);
    return tools.map((tool) => tool.name ?? 'Unknown Tool').toList();
  }

  List<AdditionalTool> getToolsByKitId(int kitId) {
    return kitTools[kitId] ?? [];
  }

  Future<void> fetchKitById(int kitId) async {
    try {
      final Kit kit = await ApiServices().getKitById(kitId);
      kitTools[kitId] = kit.tools.cast<AdditionalTool>();
      update();
    } catch (e) {
      throw Exception('Failed to load tools: $e');
    }
  }
  // Initialize
  void initializeToolQuantities() {
    toolQuantities.value = List.filled(surgicalKits.length, 0);
    surgicalToolQuantities.value = List.filled(surgicalKits.length, 0);
    fetchAdditionalTools();

  }


  List<int> getSelectedToolsIds() {
    List<int> ids = [];
    for (int i = 0; i < toolQuantities.length; i++) {
      if (toolQuantities[i] > 0) {
        ids.add(i + 1);
      }
    }
    return ids;
  }

  String getImplantNameByKitId(int kitId) {

    if (implantNames.containsKey(kitId)) {
      return implantNames[kitId]!;
    }

    // إذا كان الـ kit محملاً حالياً
    if (selectedKit.value != null && selectedKit.value!.id == kitId) {
      return selectedKit.value!.name;
    }

    // البحث في قائمة الـ kits إذا كانت متاحة
    try {
      final kit = kits.firstWhere((k) => k.id == kitId);
      return kit.name;
    } catch (e) {
      return 'Loading...';
    }
  }



  List<String> getAllSurgicalToolsNames() {
    return surgicalKits.map((tool) => tool['name'].toString()).toList();
  }




  void updateToolsSelection() {
    selectedAdditionalTools.clear();
    for (int i = 0; i < additionalTools.length; i++) {
      if (additionalToolQuantities[i] > 0) {
        selectedAdditionalTools.add(additionalTools[i]);
      }
    }
  }





  void updateAdditionalToolQuantity(int toolIndex, int newQuantity) {
    if (toolIndex >= 0 && toolIndex < additionalTools.length) {
      additionalToolQuantities[toolIndex] = newQuantity;
      _updateSelectedAdditionalTools();
    }
  }

  void _updateSelectedAdditionalTools() {
    selectedAdditionalTools.clear();
    for (int i = 0; i < additionalToolQuantities.length; i++) {
      if (additionalToolQuantities[i] > 0) {
        selectedAdditionalTools.add(additionalTools[i]);
      }
    }
  }

  List<Map<String, dynamic>> getSelectedToolsForApi() {
    return selectedAdditionalTools.map((tool) {
      return {
        'toolId': tool.id,
        'quantity': additionalToolQuantities[additionalTools.indexOf(tool)],
      };
    }).toList();
  }

  void updateSelectedTools() {
    selectedTools.clear();
    for (int i = 0; i < additionalTools.length; i++) {
      if (additionalToolQuantities[i] > 0) {
        selectedTools.add({
          'id': additionalTools[i].id,
          'name': additionalTools[i].name,
          'quantity': additionalToolQuantities[i],
        });
      }
    }
    update();
  }






  //Function For Surgical kits

  void clearSurgicalToolsSelection() {
    surgicalToolQuantities.assignAll(List.filled(surgicalKits.length, 0));
    update();
  }

  bool hasSelectedSurgicalTools() {
    return surgicalToolQuantities.any((quantity) => quantity > 0);
  }







  // Function For Implants kits
  void toggleImplantSelection(String implantId, Implant implantData) {
    if (selectedImplants.containsKey(implantId)) {
      selectedImplants.remove(implantId);
      selectedToolsForImplants.remove(implantId); // إزالة الأدوات المرتبطة أيضًا
    } else {
      selectedImplants[implantId] = implantData;
    }
    update();
  }

  void toggleToolSelection(String implantId, int toolId) {
    selectedToolsForImplants[implantId] ??= RxList<int>();

    if (selectedToolsForImplants[implantId]!.contains(toolId)) {
      selectedToolsForImplants[implantId]!.remove(toolId);
    } else {
      selectedToolsForImplants[implantId]!.add(toolId);
    }
    update();
  }

  bool isImplantSelected(String implantId) {
    return selectedImplants.containsKey(implantId);
  }


  bool isToolSelectedForImplant(String implantId, int toolId) {
    return selectedToolsForImplants[implantId]?.contains(toolId) ?? false;
  }
  void toggleTool(String toolName) {
    tools[toolName] = !(tools[toolName] ?? false);
    update();
  }

  int get selectedImplantsCount => selectedImplants.length;








  // Function For PartialImplants

  void addPartialImplant(Implant implant, {List<String>? tools}) {

    final associatedKit = kits.firstWhere(
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

    // إنشاء كائن Implant جديد مع البيانات المحدثة
    final updatedImplant = Implant(
      id: implant.id,
      radius: implant.radius,
      width: implant.width,
      height: implant.height,
      quantity: implant.quantity,
      brand: implant.brand,
      description: implant.description,
      imagePath: implant.imagePath,
      kitId: implant.kitId,
      //tools: tools ?? associatedKit.tools.map((t) => t.name).toList(),
    );

    // إزالة الزرعة إذا كانت موجودة مسبقاً
    selectedPartialImplants.removeWhere((item) => item.id == implant.id);

    // إضافة الزرعة المحدثة
    selectedPartialImplants.add(updatedImplant);

    update();
  }

  void removePartialImplant(String implantId) {
    selectedPartialImplants.removeWhere((implant) => implant.id.toString() == implantId);
    update();
  }

  bool isImplantPartial(String implantId) {
    return selectedPartialImplants.any((implant) => implant.id.toString() == implantId);
  }

  void clearPartialImplants() {
    selectedPartialImplants.clear();
    selectedPartialImplants.refresh();
  }



  List<dynamic> getToolsForImplant(int implantId) {
    try {
      final kit = kits.firstWhere(
            (k) => k.implants.any((imp) => imp.id == implantId),
      );
      return kit.tools;
    } catch (e) {
      return [];
    }
  }




  int getToolIdByName(String toolName) {
    if (toolName == 'No tools') return 0;

    for (var implant in implants.cast<Map<String, dynamic>>()) {
      for (var tool in (implant['tools'] as List).cast<Map<String, dynamic>>()) {
        if (tool['name'] == toolName && tool['id'] != null) {
          return tool['id'] as int;
        }
      }
    }

    for (var tool in [...additionalTools.cast<Map<String, dynamic>>(), ...surgicalKits.cast<Map<String, dynamic>>()]) {
      if (tool['name'] == toolName && tool['id'] != null) {
        return tool['id'] as int;
      }
    }

    return 0;
  }

  bool isImplantFullKit(String implantId) {
    return selectedImplants.containsKey(implantId);
  }




  Map<String, dynamic> prepareProcedureData() {
    return {
      'toolsIds': selectedTools.map((tool) => {
        'toolId': tool['id'],
        'quantity': int.parse(tool['quantity']),
      }).toList(),
      'kitIds': selectedImplants.keys.map(int.parse).toList(),
      'implantTools': selectedPartialImplants.map((implant) => {
        'implantId': implant.id,
        'toolIds': (implant.tools as List<String>).map((toolName) =>
            getToolIdByName(toolName)
        ).toList(),
      }).toList(),
    };
  }



}