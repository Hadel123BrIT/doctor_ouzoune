import 'package:get/get.dart';

import '../../../core/services/api_services.dart';
import '../../../models/additionalTool_model.dart';

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
  final List<Map<String, dynamic>> implants = [
    {
      "id": 1,
      'name': 'Nobel Biocare',
      'height': '10 mm',
      'width': '3.5 mm',
      'radius': '3.5 mm',
      'brand': "Implant Tech",
      'quantity': 15,
      'description': 'High Quality Premium implant for anterior region',
      'image': 'assets/images/implant1.png',
      'tools': [
        {
          'id': 101,
          'name': 'Dental Drill',
          'image': 'assets/images/dental_drill.png',
          'length': '15 cm',
          'width': '3 cm',
          'thickness': '2 cm',
          'quantity': "0",
        },
        {
          'id': 102,
          'name': 'Surgical Guide',
          'image': 'assets/images/surgical_guide.png',
          'length': '12 cm',
          'width': '4 cm',
          'thickness': '0.5 cm',
          'quantity': "0",
        },
        {
          'id': 103,
          'name': 'Healing Abutment',
          'image': 'assets/images/healing_abutment.png',
          'length': '8 cm',
          'width': '2 cm',
          'thickness': '1 cm',
          'quantity': "0",
        },
        {
          'id': 104,
          'name': 'No tools',
        }
      ]
    },
    {
      "id": 2,
      'name': 'Straumann',
      'height': '12 mm',
      'width': '4.1 mm',
      'radius': '4.1 mm',
      'brand': "Implant Tech",
      'quantity': 8,
      'description': 'Roxolid SLActive surface for doctor and his operation',
      'image': 'assets/images/implant2.png',
      'tools': [
        {
          'id': 201,
          'name': 'Dental Drill',
          'image': 'assets/images/dental_drill.png',
          'length': '15 cm',
          'width': '3 cm',
          'thickness': '2 cm',
          'quantity': "0",
        },
        {
          'id': 202,
          'name': 'Torque Wrench',
          'image': 'assets/images/torque_wrench.png',
          'length': '18 cm',
          'width': '5 cm',
          'thickness': '1.5 cm',
          'quantity': "0",
        },
        {
          'id': 203,
          'name': 'Scan Body',
          'image': 'assets/images/scan_body.png',
          'length': '10 cm',
          'width': '2.5 cm',
          'thickness': '1 cm',
          'quantity': "0",
        },
        {
          'id': 204,
          'name': 'No tools',
        }
      ]
    },
    {
      "id": 3,
      'name': 'BioHorizons',
      'height': '11.5 mm',
      'width': '4.6 mm',
      'radius': '4.6 mm',
      'brand': "Implant Tech",
      'quantity': 10,
      'description': 'Laser-Lok microchannel technology',
      'image': 'assets/images/implant3.png',
      'tools': [
        {
          'id': 301,
          'name': 'Dental Drill',
          'image': 'assets/images/dental_drill.png',
          'length': '15 cm',
          'width': '3 cm',
          'thickness': '2 cm',
          'quantity': "0",
        },
        {
          'id': 302,
          'name': 'Prosthetic Kit',
          'image': 'assets/images/prosthetic_kit.png',
          'length': '20 cm',
          'width': '15 cm',
          'thickness': '3 cm',
          'quantity': "0",
        },
        {
          'id': 303,
          'name': 'Impression Coping',
          'image': 'assets/images/impression_coping.png',
          'length': '8 cm',
          'width': '2 cm',
          'thickness': '1 cm',
          'quantity': "0",
        },
        {
          'id': 304,
          'name': 'No tools',
        }
      ]
    },
    {
      "id": 4,
      'name': 'Nobel Biocare',
      'height': '10 mm',
      'width': '3.5 mm',
      'radius': '3.5 mm',
      'brand': "Implant Tech",
      'quantity': 15,
      'description': 'High Quality Premium implant for anterior region',
      'image': 'assets/images/implant1.png',
      'tools': [
        {
          'id': 401,
          'name': 'Dental Drill',
          'image': 'assets/images/dental_drill.png',
          'length': '15 cm',
          'width': '3 cm',
          'thickness': '2 cm',
          'quantity': "0",
        },
        {
          'id': 402,
          'name': 'Surgical Guide',
          'image': 'assets/images/surgical_guide.png',
          'length': '12 cm',
          'width': '4 cm',
          'thickness': '0.5 cm',
          'quantity': "0",
        },
        {
          'id': 403,
          'name': 'No tools',
        }

      ]
    },
    {
      "id": 5,
      'name': 'Straumann',
      'height': '12 mm',
      'width': '4.1 mm',
      'radius': '4.1 mm',
      'brand': "Implant Tech",
      'quantity': 8,
      'description': 'Roxolid SLActive surface',
      'image': 'assets/images/implant2.png',
      'tools': [
        {
          'id': 501,
          'name': 'Dental Drill',
          'image': 'assets/images/dental_drill.png',
          'length': '15 cm',
          'width': '3 cm',
          'thickness': '2 cm',
          'quantity': "0",
        },
        {
          'id': 502,
          'name': 'Abutment',
          'image': 'assets/images/abutment.png',
          'length': '10 cm',
          'width': '3 cm',
          'thickness': '1.5 cm',
          'quantity': "0",
        },
        {
          'id': 503,
          'name': 'Cover Screw',
          'image': 'assets/images/cover_screw.png',
          'length': '5 cm',
          'width': '2 cm',
          'thickness': '1 cm',
          'quantity': "0",
        },
        {
          'id': 504,
          'name': 'No tools',
        }
      ]
    }
  ];
  final RxList<AdditionalTool> additionalTools = <AdditionalTool>[].obs;
  final RxList<int> additionalToolQuantities = <int>[].obs;
  final RxList<AdditionalTool> selectedAdditionalTools = <AdditionalTool>[].obs;
  final RxList<int> toolQuantities = <int>[].obs;
  final RxMap<String, bool> tools = <String, bool>{}.obs;
  final RxInt selectedToolsCount = 0.obs;
  final RxList<int> surgicalToolQuantities = <int>[].obs;
  final RxList<Map<String, dynamic>> selectedSurgicalTools = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> selectedTools = <Map<String, dynamic>>[].obs;
  final RxMap<String, Map<String, dynamic>> selectedImplants = <String, Map<String, dynamic>>{}.obs;
  final RxMap<String, List<String>>selectedToolsForImplants = <String, List<String>>{}.obs;
  final RxMap<String, Map<String, dynamic>> selectedImplantDetails = <String, Map<String, dynamic>>{}.obs;
  final RxList<Map<String, dynamic>> selectedPartialImplants = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
    initializeToolQuantities();
  }

  // Initialize
  void initializeToolQuantities() {
    toolQuantities.value = List.filled(surgicalKits.length, 0);
    surgicalToolQuantities.value = List.filled(surgicalKits.length, 0);
    fetchAdditionalTools();
    //updateSelectedTools();
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



  void updateToolsSelection() {
    selectedAdditionalTools.clear();
    for (int i = 0; i < additionalTools.length; i++) {
      if (additionalToolQuantities[i] > 0) {
        selectedAdditionalTools.add(additionalTools[i]);
      }
    }
  }




  // Function For Additional tools
  Future<void> fetchAdditionalTools() async {
    try {
      final tools = await ApiServices().getAdditionalTools();
      additionalTools.assignAll(tools);
      additionalToolQuantities.assignAll(List.filled(tools.length, 0));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tools: ${e.toString()}');
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

  List<String> getAllSurgicalToolsNames() {
    return surgicalKits.map((tool) => tool['name'] as String).toList();
  }

  bool hasSelectedSurgicalTools() {
    return surgicalToolQuantities.any((quantity) => quantity > 0);
  }







  // Function For Implants kits
  void toggleImplantSelection(String implantId, Map<String, dynamic> implantData) {
    if (selectedImplants.containsKey(implantId)) {
      selectedImplants.remove(implantId);
    } else {
      selectedImplants[implantId] = implantData;
    }
    update();
  }

  bool isImplantSelected(String implantId) {
    return selectedImplants.containsKey(implantId);
  }

  void toggleToolForImplant(String implantId, String toolName) {
    selectedToolsForImplants[implantId] ??= [];
    final toolsList = selectedToolsForImplants[implantId]!;

    if (toolName == 'No tools') {
      if (toolsList.contains('No tools')) {
        toolsList.remove('No tools');
      } else {
        toolsList.clear();
        toolsList.add('No tools');
      }
    }
    else {
      if (toolsList.contains('No tools')) {
        toolsList.remove('No tools');
      }

      if (toolsList.contains(toolName)) {
        toolsList.remove(toolName);
      }
      else {
        toolsList.add(toolName);
      }
    }
    update();
  }

  bool isToolSelectedForImplant(String implantId, String toolName) {
    return selectedToolsForImplants[implantId]?.contains(toolName) ?? false;
  }

  List<String> getToolsForImplant(String implantId) {
    return selectedToolsForImplants[implantId] ?? [];
  }

  void toggleTool(String toolName) {
    tools[toolName] = !(tools[toolName] ?? false);
    update();
  }

  int get selectedImplantsCount => selectedImplants.length;








  // Function For PartialImplants

  void addPartialImplant(String implantId, String implantName, {List<String>? tools}) {
    selectedPartialImplants.removeWhere((item) => item['implantId'] == implantId);
    selectedPartialImplants.add({
      'implantId': implantId,
      'implantName': implantName,
      'tools': tools ?? [],
    });
    update();
  }

  void removePartialImplant(String implantId) {
    selectedPartialImplants.removeWhere((item) => item['implantId'] == implantId);
    selectedPartialImplants.refresh();
  }


  void clearPartialImplants() {
    selectedPartialImplants.clear();
    selectedPartialImplants.refresh();
  }

  Map<String, dynamic>? getImplantDetails(String implantId) {
    try {
      return implants.firstWhere(
            (implant) => implant['id'].toString() == implantId,
      );
    } catch (e) {
      return null;
    }
  }





  int getToolIdByName(String toolName) {
    if (toolName == 'No tools') return 0;

    // تحويل implants إلى List<Map<String, dynamic>>
    for (var implant in implants.cast<Map<String, dynamic>>()) {
      for (var tool in (implant['tools'] as List).cast<Map<String, dynamic>>()) {
        if (tool['name'] == toolName && tool['id'] != null) {
          return tool['id'] as int;
        }
      }
    }

    // تحويل additionalTools و surgicalKits إلى List<Map<String, dynamic>>
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

  bool isImplantPartial(String implantId) {
    return selectedPartialImplants.any((item) => item['implantId'] == implantId);
  }


  Map<String, dynamic> prepareProcedureData() {
    return {
      'toolsIds': selectedTools.map((tool) => {
        'toolId': tool['id'],
        'quantity': int.parse(tool['quantity']),
      }).toList(),
      'kitIds': selectedImplants.keys.map((id) => int.parse(id)).toList(),
      'implantTools': selectedPartialImplants.map((item) => {
        'implantId': int.parse(item['implantId']),
        'toolIds': (item['tools'] as List<String>).map((toolName) =>
            getToolIdByName(toolName)
        ).toList(),
      }).toList(),
    };
  }



}