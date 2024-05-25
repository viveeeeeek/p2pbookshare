// Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/services/theme/app_theme_service.dart';
import 'package:p2pbookshare/view/settings/widgets/color_picker.dart';
import 'package:p2pbookshare/view_model/setting_viewmodel.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late UserModel _userModel;
  final SettingViewModel _settingsHandler = SettingViewModel();

  @override
  void didChangeDependencies() {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    _userModel = UserModel(
        userUid: userDataProvider.userModel!.userUid,
        username: userDataProvider.userModel!.username,
        emailAddress: userDataProvider.userModel!.emailAddress,
        displayName: userDataProvider.userModel!.displayName,
        profilePictureUrl: userDataProvider.userModel!.profilePictureUrl);
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
          body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                      left: top ==
                              MediaQuery.of(context).padding.top +
                                  kToolbarHeight
                          ? 60
                          : 20,
                      bottom: 15),
                  title: Text(
                    'Settings',
                    style: TextStyle(fontSize: 22, color: context.onBackground),
                  ),
                );
              }),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                onTap: () => context.pushNamed(AppRouterConstants.addressView),
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
                height: 10,
              ),

              const Divider(),
              ListTile(
                onTap: () async {
                  await _settingsHandler.handleLogOut(context);
                },
                title: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  '${_userModel.emailAddress}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_outlined),
              ),

              //TODO: Implement confirmation alerdialog
            ],
          ),
        ),
      ));
    });
  }
}
