import 'package:deep_sight_ai_labs/constants/constant.dart';
import 'package:deep_sight_ai_labs/provider/auth_provider.dart';
import 'package:deep_sight_ai_labs/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 4,
          ),
          Consumer<ThemeProvider>(builder: (context, data, _) {
            return ListTile(
              title: Text("Theme"),
              leading: Icon(Icons.light_mode_outlined),
              trailing: ToggleSwitch(
                inactiveBgColor: Colors.blue.withOpacity(.2),
                initialLabelIndex: data.switchIndex,
                totalSwitches: 2,
                labels: ['Light', 'Dark'],
                onToggle: (index) {
                  data.setTheme(index: index ?? 0, context: context);
                  print('switched to: $index');
                },
              ),
            );
          }),
          Constant().getDivider(),
          SwitchListTile(
            secondary: Icon(Icons.notifications_active_outlined),
            value: isOn,
            onChanged: (val) {
              setState(() {
                isOn = val;
              });
            },
            title: const Text("Notification"),
          ),
          Constant().getDivider(),
          ListTile(
            onTap: (){
              Provider.of<AuthProvider>(context, listen: false).logout(context: context);

            },
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            trailing:
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.arrow_forward_ios,size: 20,),
            ),
          ),
          Constant().getDivider(),
          Spacer(),
          Text("Version 1.0.0"),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
