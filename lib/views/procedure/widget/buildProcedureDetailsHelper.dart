import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/Implant_model.dart';
import '../../../models/kit_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/procedure_model.dart';

Widget buildHeaderCard(BuildContext context, bool isDarkMode, Color textColor,Procedure procedure) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: isDarkMode ? Colors.grey[800] : Colors.white,
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Procedure #${procedure.id}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Chip(
                label: Text(procedure.statusText,
                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
                ),
                backgroundColor: procedure.statusColor,
              ),
            ],
          ),
          Divider(color: Colors.grey[400], height: 20),
          buildDetailRow('Doctor', procedure.doctor.userName, textColor),
          buildDetailRow('Date', DateFormat('dd-MM-yyyy').format(procedure.date), textColor),
          buildDetailRow('Time', DateFormat('HH:mm').format(procedure.date), textColor),
          buildDetailRow('Assistants', '${procedure.numberOfAssistants}', textColor),
        ],
      ),
    ),
  );
}

Widget buildDetailRow(String label, String value, Color textColor) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
      ),
    ),
  );
}

Widget buildAssistantsList(Procedure procedure , bool isDarkMode) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: procedure.assistants.map((assistant) => ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryGreen,
            child: Text(
              assistant.userName[0],
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            assistant.userName,
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          subtitle: Text(
            assistant.phoneNumber!,
            style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
          ),
        )).toList(),
      ),
    ),
  );
}

Widget buildToolsList(List<AdditionalTool> tools,isDarkMode) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    child: Column(
      children: tools.map((tool) => ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          tool.name!,
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                buildToolDetailRow('Quantity', '${tool.quantity}'),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      )).toList(),
    ),
  );
}

Widget buildToolDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      ],
    ),
  );
}

Widget buildKitCard(Kit kit, BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return Card(
    elevation: 2,
    margin: EdgeInsets.only(top: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 3,
      ),
    ),
    child: ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      leading: kit.isMainKit
          ? Icon(Icons.medical_services, color: Colors.green)
          : Icon(Icons.construction, color: Colors.blue),
      title: Text(
        kit.name,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : AppColors.deepBlack,
        ),
      ),
      subtitle: kit.isMainKit
          ? Text('Surgical Kit', style: TextStyle(color: Colors.green, fontFamily: 'Montserrat'))
          : null,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Implants (${kit.implants.length})'),
              ...kit.implants.map((implant) => buildImplantItem(implant,isDarkMode)).toList(),

              SizedBox(height: 10),

              buildSectionTitle('Tools (${kit.tools.length})'),
              ...kit.tools.map((tool) => buildToolItem(tool,isDarkMode)).toList(),

              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildImplantItem(Implant implant,isDarkMode) {

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 3,
      ),
    ),
    elevation: 1,
    margin: EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(Icons.medication, color: AppColors.primaryGreen),
      title: Text(
        implant.brand,
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(implant.description, style: TextStyle(fontFamily: 'Montserrat',color: Colors.grey)),
          SizedBox(height: 4),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Qty: ${implant.quantity}',
            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget buildToolItem(AdditionalTool tool,isDarkMode) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 2,
      ),
    ),
    elevation: 1,
    margin: EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(Icons.build, color: AppColors.primaryGreen),
      title: Text(
        tool.name!,
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
      ),
      subtitle:  Text(
        'Quantity: ${tool.quantity}',
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold,
        color: Colors.grey
        ),
      ),

    ),
  );
}