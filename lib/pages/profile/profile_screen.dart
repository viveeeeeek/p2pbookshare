import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/profile/profile_handler.dart';
import 'package:p2pbookshare/pages/settings/settings_view.dart';
import 'package:p2pbookshare/pages/profile/widgets/profile_card.dart';
import 'package:p2pbookshare/pages/profile/widgets/your_books_listview.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInternetConnected = false;

  @override
  Widget build(BuildContext context) {
    //FIXME: instead creating new provider instance in profile screen. pass the instance createdin landingpage only
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: UserProfileCard(
                userModel: userDataProvider.userModel!,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Your books",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            yourBooksListView(
                //FIXME do not create new instance.
                context,
                ProfileHandler().getUserBooksStream(context)),
          ],
        ));
  }
}
