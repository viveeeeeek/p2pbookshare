import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/extras/handler.user.dart';
import 'package:p2pbookshare/pages/settings/settings_handler.dart';
import 'package:p2pbookshare/pages/settings/widgets/color_picker.dart';
import 'package:p2pbookshare/services/model/user.dart';
import 'package:p2pbookshare/services/providers/theme/app_theme_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late UserModel _userModel;
  final UserHandler _userHandler = UserHandler();
  final SettingsHandler _settingsHandler = SettingsHandler();

  @override
  void didChangeDependencies() {
    _userModel = _userHandler.getUser(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _settingsHandler.initProviders(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final appThemeProvider = Provider.of<AppThemeService>(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Account',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(MdiIcons.mapMarkerOutline),
                title: const Text('Your addresses'),
                subtitle: const Text('Edit address for book exchange'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Appearance',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  ListTile(
                    leading: appThemeProvider.isDarkThemeEnabled
                        ? Icon(MdiIcons.weatherNight)
                        : const Icon(Icons.wb_sunny_outlined),
                    title: const Text('Dark theme'),
                    subtitle: appThemeProvider.isDarkThemeEnabled
                        ? const Text('On')
                        : const Text('Off'),
                    trailing: Switch(
                      value: appThemeProvider.isDarkThemeEnabled,
                      onChanged: (value) {
                        _settingsHandler.themeToggleEvent(context, value);
                      },
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(MdiIcons.paletteOutline),
                        title: const Text('Dynamic color'),
                        subtitle: const Text(
                            'Apply colors from wallpapers to the app theme (Android 12+)'),
                        trailing: Switch(
                          value: _settingsHandler.isDynamicColorEnabled,
                          onChanged: (value) {
                            _settingsHandler.isDynamicColorEnabled = !value;
                            setState(() {
                              _settingsHandler.setIsDynamicColorEnabled(
                                  context, value);
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            _settingsHandler.isDynamicColorEnabled == false,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              colorPicker(context, const Color(0xff1972e6)),
                              colorPicker(context, const Color(0xff098758)),
                              colorPicker(context, const Color(0xff746ac0)),
                              colorPicker(
                                context,
                                const Color(0xffa76800),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              //TODO: implement confirmation alerdialog

              SizedBox(
                width: double.infinity,
                height: 70,
                child: FilledButton.tonal(
                  onPressed: () async {
                    await _settingsHandler.handleLogOut(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.logout_rounded),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Log out',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_userModel.userEmailAddress}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

//FIXME: Logging out from app redirects to loginscreen but going back from loginscreen redirects back to the settings screen