import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Routes/app_routes.dart';
import '../../../Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),
        color: Colors.white, onPressed: () { Get.back(); },
        ),
        toolbarHeight: media.height* 0.1, // 80 replaced
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(media.width * 0.06), // 22 replaced
          ),
        ),
        title: Text(
          "Setting",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(media.width * 0.04),
        child: Column(
          children: [
            _buildAccountCard(context, media),
            _buildSettingsSection(context, title: "public", icon: Icons.settings,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.language,
                  title: "Languages",
                  value: "Arabic",
                  onTap: () => _changeLanguage(context),
                ),
                _buildSettingItem(
                  trailing: Switch(value: true, onChanged: (_) {},
                  activeColor: AppColors.primaryGreen,
                  ),
                  context,
                  icon: Icons.color_lens,
                  title: "Apperance",
                  value: "dark",
                  onTap: () => _changeTheme(context),
                ),
              ],
            ),
            _buildSettingsSection(context, title: "Security", icon: Icons.security,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.lock,
                  title: "change password",
                  onTap: () => {},
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.email,
                  title: "change email",

                ),
              ],
            ),
            _buildSettingsSection(context, title: "Support", icon: Icons.support_agent,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.help,
                  title: "Help",
                  onTap: () => {},
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.phone,
                  title: "Call us ",
                  onTap: () => {},
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: media.height * 0.03),
              child: SizedBox(
                width: double.infinity,
                child:   CustomButton(
                  onTap: (){;
                  },
                  text: 'Log out'.tr, color: AppColors.primaryGreen,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAccountCard(BuildContext context, MediaQueryHelper media) {
    return Card(
      color: AppColors.primaryGreen,
      margin: EdgeInsets.only(bottom: media.height * 0.03),
      child: Padding(
        padding: EdgeInsets.all(media.width * 0.04),
        child: Row(
          children: [
            CircleAvatar(
              radius: media.width * 0.1,
              backgroundColor: AppColors.lightGreen,
              child:  Icon(Icons.person,
              color: Colors.grey[300],
              ),
            ),
            SizedBox(width: media.width * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr.Ahmad",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                      fontFamily: 'Montserrat',
                  )
                ),
                Text(
                  "ahmed@ouzoun.com",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Widget> children,
      }) {return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryGreen),
                SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ...children,
        ],
      ),
    );}

  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? value,
        Widget? trailing,
        Function()? onTap,
      }) {return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      subtitle: value != null
          ? Text(value, style: Theme.of(context).textTheme.titleMedium)
          : null,
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryGreen),
      onTap: onTap,
    );}

  void _changeLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("choose languages",
        style:  Theme.of(context).textTheme.titleMedium
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Arabic",
                  style:  Theme.of(context).textTheme.headlineSmall
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text("English",
                  style:  Theme.of(context).textTheme.headlineSmall
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _changeTheme(BuildContext context) {
    // يمكن تفعيل Dark/Light Mode هنا
  }
  void _logout(BuildContext context) {

  }
}