import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ouzoun/core/constants/app_colors.dart';

import '../../../models/Implant_model.dart';
import '../../../models/assistant_model.dart';
import '../../../models/clinic_model.dart';
import '../../../models/doctor_model.dart';
import '../../../models/kit_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/procedure_controller.dart';
import 'buildProcedureCard.dart';

// Widget buildProceduresList() {
//   final ProcedureController controller = Get.put(ProcedureController());
//   // دالة لإنشاء بيانات وهمية
//   List<Procedure> createDummyProcedures() {
//     final now = DateTime.now();
//     return [
//       Procedure(
//         id: 1,
//         doctorId: "doc1",
//         numberOfAssistants: 2,
//         assistantIds: ["ast1", "ast2"],
//         categoryId: 1,
//         status: 2,
//         date: now.add(Duration(days: 2)),
//         doctor: Doctor(
//           id: "doc1",
//           userName: "Dr. Ahmed Mohamed",
//           email: "ahmed@example.com",
//           phoneNumber: "0123456789",
//           role: "Surgeon",
//           clinic: Clinic(
//             id: 1,
//             name: "Green Dental Clinic",
//             address: "123 Main St, Damascus",
//             longitude: 36.2765,
//             latitude: 33.5102,
//             rate: 4.5,
//           ),
//           rate: 4.8,
//         ),
//         tools: [
//           AdditionalTool(
//             id: 1,
//             name: "Surgical Scissors",
//             width: 12.0,
//             height: 4.0,
//             thickness: 0.5,
//             quantity: 3,
//             kitId: null,
//             categoryId: 1,
//           ),
//         ],
//         kits: [
//           Kit(
//             id: 1,
//             name: "Basic Implant Kit",
//             isMainKit: true,
//             implantCount: 1,
//             toolCount: 1,
//             implants: [
//               Implant(
//                 id: 1,
//                 radius: 3.5,
//                 width: 3.5,
//                 height: 10.0,
//                 quantity: 5,
//                 brand: "Implant Tech",
//                 description: "Standard implant",
//                 imagePath: "",
//                 kitId: 1,
//               ),
//             ],
//             tools: [
//               AdditionalTool(
//                 id: 3,
//                 name: "Dental Drill",
//                 width: 15.0,
//                 height: 3.0,
//                 thickness: 2.0,
//                 quantity: 1,
//                 kitId: 1,
//                 categoryId: 1,
//               ),
//             ],
//           ),
//         ],
//         assistants: [
//           Assistant(
//             id: "ast1",
//             userName: "Nurse Sarah",
//             email: "sarah@example.com",
//             phoneNumber: "0111222333",
//             role: "Nurse",
//             clinic: Clinic(
//               id: 1,
//               name: "Green Dental Clinic",
//               address: "123 Main St, Damascus",
//               longitude: 36.2765,
//               latitude: 33.5102,
//             ),
//             rate: 4.2,
//           ),
//           Assistant(
//             id: "ast1",
//             userName: "Nurse Sarah",
//             email: "sarah@example.com",
//             phoneNumber: "0111222333",
//             role: "Nurse",
//             clinic: Clinic(
//               id: 1,
//               name: "Green Dental Clinic",
//               address: "123 Main St, Damascus",
//               longitude: 36.2765,
//               latitude: 33.5102,
//             ),
//             rate: 4.2,
//           ),
//         ],
//       ),
//       Procedure(
//         id: 2,
//         doctorId: "doc2",
//         numberOfAssistants: 1,
//         assistantIds: ["ast3"],
//         categoryId: 2,
//         status: 3, // Accepted
//         date: now.subtract(Duration(days: 1)),
//         doctor: Doctor(
//           id: "doc2",
//           userName: "Dr. Fatma Mahmoud",
//           email: "fatma@example.com",
//           phoneNumber: "0100123456",
//           role: "Dentist",
//           clinic: Clinic(
//             id: 2,
//             name: "Premium Dental Care",
//             address: "456 Oak Ave, Aleppo",
//             longitude: 37.1345,
//             latitude: 36.2023,
//             rate: 4.7,
//           ),
//           rate: 4.9,
//         ),
//         tools: [
//           AdditionalTool(
//             id: 4,
//             name: "Retractor",
//             width: 20.0,
//             height: 5.0,
//             thickness: 1.0,
//             quantity: 1,
//             kitId: null,
//             categoryId: 2,
//           ),
//         ],
//         kits: [
//           Kit(
//             id: 2,
//             name: "Custom Kit",
//             isMainKit: false,
//             implantCount: 1,
//             toolCount: 1,
//             implants: [
//               Implant(
//                 id: 2,
//                 radius: 4.1,
//                 width: 4.1,
//                 height: 12.0,
//                 quantity: 3,
//                 brand: "Dental Care",
//                 description: "Premium implant",
//                 imagePath: "",
//                 kitId: 2,
//               ),
//             ],
//             tools: [
//               AdditionalTool(
//                 id: 5,
//                 name: "Prosthetic Kit",
//                 width: 20.0,
//                 height: 15.0,
//                 thickness: 3.0,
//                 quantity: 1,
//                 kitId: 2,
//                 categoryId: 2,
//               ),
//             ],
//           ),
//         ],
//         assistants: [
//           Assistant(
//             id: "ast3",
//             userName: "Assistant Samir",
//             email: "samir@example.com",
//             phoneNumber: "0100555666",
//             role: "Assistant",
//             clinic: Clinic(
//               id: 2,
//               name: "Premium Dental Care",
//               address: "456 Oak Ave, Aleppo",
//               longitude: 37.1345,
//               latitude: 36.2023,
//             ),
//             rate: 4.3,
//           ),
//         ],
//       ),
//       Procedure(
//         id: 1,
//         doctorId: "doc1",
//         numberOfAssistants: 2,
//         assistantIds: ["ast1", "ast2"],
//         categoryId: 1,
//         status: 4,
//         date: now.add(Duration(days: 2)),
//         doctor: Doctor(
//           id: "doc1",
//           userName: "Dr. Ahmed Mohamed",
//           email: "ahmed@example.com",
//           phoneNumber: "0123456789",
//           role: "Surgeon",
//           clinic: Clinic(
//             id: 1,
//             name: "Green Dental Clinic",
//             address: "123 Main St, Damascus",
//             longitude: 36.2765,
//             latitude: 33.5102,
//             rate: 4.5,
//           ),
//           rate: 4.8,
//         ),
//         tools: [
//           AdditionalTool(
//             id: 1,
//             name: "Surgical Scissors",
//             width: 12.0,
//             height: 4.0,
//             thickness: 0.5,
//             quantity: 3,
//             kitId: null,
//             categoryId: 1,
//           ),
//         ],
//         kits: [
//           Kit(
//             id: 1,
//             name: "Basic Implant Kit",
//             isMainKit: true,
//             implantCount: 1,
//             toolCount: 1,
//             implants: [
//               Implant(
//                 id: 1,
//                 radius: 3.5,
//                 width: 3.5,
//                 height: 10.0,
//                 quantity: 5,
//                 brand: "Implant Tech",
//                 description: "Standard implant",
//                 imagePath: "",
//                 kitId: 1,
//               ),
//             ],
//             tools: [
//               AdditionalTool(
//                 id: 3,
//                 name: "Dental Drill",
//                 width: 15.0,
//                 height: 3.0,
//                 thickness: 2.0,
//                 quantity: 1,
//                 kitId: 1,
//                 categoryId: 1,
//               ),
//             ],
//           ),
//         ],
//         assistants: [
//           Assistant(
//             id: "ast1",
//             userName: "Nurse Sarah",
//             email: "sarah@example.com",
//             phoneNumber: "0111222333",
//             role: "Nurse",
//             clinic: Clinic(
//               id: 1,
//               name: "Green Dental Clinic",
//               address: "123 Main St, Damascus",
//               longitude: 36.2765,
//               latitude: 33.5102,
//             ),
//             rate: 4.2,
//           ),
//         ],
//       ),
//       Procedure(
//         id: 2,
//         doctorId: "doc2",
//         numberOfAssistants: 1,
//         assistantIds: ["ast3"],
//         categoryId: 2,
//         status: 3, // Accepted
//         date: now.subtract(Duration(days: 1)),
//         doctor: Doctor(
//           id: "doc2",
//           userName: "Dr. Fatma Mahmoud",
//           email: "fatma@example.com",
//           phoneNumber: "0100123456",
//           role: "Dentist",
//           clinic: Clinic(
//             id: 2,
//             name: "Premium Dental Care",
//             address: "456 Oak Ave, Aleppo",
//             longitude: 37.1345,
//             latitude: 36.2023,
//             rate: 4.7,
//           ),
//           rate: 4.9,
//         ),
//         tools: [
//           AdditionalTool(
//             id: 4,
//             name: "Retractor",
//             width: 20.0,
//             height: 5.0,
//             thickness: 1.0,
//             quantity: 1,
//             kitId: null,
//             categoryId: 2,
//           ),
//         ],
//         kits: [
//           Kit(
//             id: 2,
//             name: "Custom Kit",
//             isMainKit: false,
//             implantCount: 1,
//             toolCount: 1,
//             implants: [
//               Implant(
//                 id: 2,
//                 radius: 4.1,
//                 width: 4.1,
//                 height: 12.0,
//                 quantity: 3,
//                 brand: "Dental Care",
//                 description: "Premium implant",
//                 imagePath: "",
//                 kitId: 2,
//               ),
//             ],
//             tools: [
//               AdditionalTool(
//                 id: 5,
//                 name: "Prosthetic Kit",
//                 width: 20.0,
//                 height: 15.0,
//                 thickness: 3.0,
//                 quantity: 1,
//                 kitId: 2,
//                 categoryId: 2,
//               ),
//             ],
//           ),
//         ],
//         assistants: [
//           Assistant(
//             id: "ast3",
//             userName: "Assistant Samir",
//             email: "samir@example.com",
//             phoneNumber: "0100555666",
//             role: "Assistant",
//             clinic: Clinic(
//               id: 2,
//               name: "Premium Dental Care",
//               address: "456 Oak Ave, Aleppo",
//               longitude: 37.1345,
//               latitude: 36.2023,
//             ),
//             rate: 4.3,
//           ),
//         ],
//       ),
//     ];
//   }
//   final dummyProcedures = createDummyProcedures();
//   return Obx(() {
//     if (controller.isLoading.value) {
//       return Center(child: CircularProgressIndicator(
//         color: AppColors.primaryGreen,
//       ),
//       );
//     }
//
//     // if (controller.filteredProcedures.isEmpty) {
//     //   return Center(child: Text('No procedures found'));
//     // }
//     if (dummyProcedures.isEmpty) {
//       return Center(child: Text('No procedures found'));
//     }
//
//     return  ListView.builder(
//       itemCount: dummyProcedures
//           .where((p) => controller.statusFilter.value == 0 ||
//           p.status == controller.statusFilter.value)
//           .length,
//       itemBuilder: (context, index) {
//         final filtered = dummyProcedures
//             .where((p) => controller.statusFilter.value == 0 ||
//             p.status == controller.statusFilter.value)
//             .toList();
//         return buildProcedureCard(filtered[index], context);
//       },
//     );
//   });
// }
Widget buildProceduresList() {
  final controller = Get.find<ProcedureController>();

  return Obx(() {
    if (controller.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        ),
      );
    }
    if (controller.proceduresList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No procedures found'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.fetchAllProcedures(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchAllProcedures();
      },
      child: ListView.builder(
        itemCount: controller.filteredProcedures.length,
        itemBuilder: (context, index) {
          final procedure = controller.filteredProcedures[index];
          return buildProcedureCard(procedure, context);
        },
      ),
    );
  });
}