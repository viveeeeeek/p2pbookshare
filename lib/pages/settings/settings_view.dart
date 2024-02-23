import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extras/handler.user.dart';
import 'package:p2pbookshare/pages/settings/settings_handler.dart';

import './widgets/widgets.dart';
import 'package:p2pbookshare/services/model/user.dart';
import 'package:provider/provider.dart';

import '../../services/providers/theme/app_theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                'Appearance',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  ListTile(
                    leading: Icon(MdiIcons.weatherNight),
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
              InkWell(
                onTap: () async {
                  await _settingsHandler.handleLogOut(context);
                },
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: SettingsCard(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      leading: Icon(MdiIcons.logoutVariant),
                      title: Text('Log out ${_userModel.userEmailAddress}'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
