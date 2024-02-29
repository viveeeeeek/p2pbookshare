import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:p2pbookshare/pages/location_picker/location_handler.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';

import 'widgets/widgets.dart';

class GetLocationScreen extends StatefulWidget {
  const GetLocationScreen({super.key});

  @override
  State<GetLocationScreen> createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  final logger = SimpleLogger();
  GetLocationHandler locationHandler = GetLocationHandler();

  @override
  void initState() {
    super.initState();
    locationHandler.handleLocationInitialization(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingMenu(),
      resizeToAvoidBottomInset: false,
      body: Consumer<LocationService>(
        builder: (context, locationService, _) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    const CustomGoogleMap(),
                    const Positioned(
                      top: kToolbarHeight - 15,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          LocationSearchBar(),
                          SizedBox(
                            height: 15,
                          ),
                          SearchResult()
                        ],
                      ),
                    ),
                    locationService.isLoading == true
                        ? const SizedBox()
                        : const Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: BottomCard(),
                          )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
