import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/services/others/permission_service.dart';
import 'package:provider/provider.dart';

class NotifPermissionAlertCard extends StatelessWidget {
  const NotifPermissionAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PermissionService, bool>(
      selector: (context, permissionService) =>
          permissionService.isNotificationPermissionAvailable,
      builder: (context, isNotificationPermissionAvailable, child) {
        logger.d(
            'Notification permission available: ${isNotificationPermissionAvailable}');
        return !isNotificationPermissionAvailable
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.errorContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            MdiIcons.bellAlertOutline,
                            size: 135, // adjust the size as needed
                            color: context.onErrorContainer.withOpacity(
                                0.1), // change color and opacity as needed
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'P2P Book Share needs notifications permission to notify you when a new book is available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: context.onBackground,
                                ),
                              ),
                              const SizedBox(height: 10),
                              FilledButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: context.onErrorContainer),
                                onPressed: () {
                                  // Request notification permission
                                  AppSettings.openAppSettings(
                                      type: AppSettingsType.notification);
                                },
                                child: Text(
                                  'Grant Permission',
                                  style: TextStyle(
                                      color: context.errorContainer,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              )
            : const SizedBox();
      },
    );
  }
}
