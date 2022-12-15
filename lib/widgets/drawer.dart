import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextonmaps/my_services/map_service.dart';
import 'package:nextonmaps/pages/signing_in.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.image});
  final Image image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(

        // * Background Image
        child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image.image,
          fit: BoxFit.cover,
        ),
      ),

      // * Drawer Widget
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // * User Details
            Text(
                "Hi ${FirebaseAuth.instance.currentUser?.displayName ?? "User"}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            Text(
              FirebaseAuth.instance.currentUser?.email ?? "",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            const Divider(),

            const Spacer(
              flex: 4,
            ),

            // * Social Links
            const Text(
              'Follow US',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Row(
              children: [
                IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () {
                      MapService.launchUrlFunc(
                          Uri.parse('https://www.instagram.com/nextonmap/'));
                    }),
                IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () {
                      MapService.launchUrlFunc(Uri.parse(
                          'https://www.facebook.com/nextonmap-100479358427034/?ref=pages_you_manage'));
                    }),
                IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.youtube,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () {
                      MapService.launchUrlFunc(Uri.parse(
                          'https://www.youtube.com/channel/UCF8Yg_x_OL3tvf2KnUzHhbA'));
                    }),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const Spacer(),
            // ignore: todo
            // TODO: Add a Rating bar

            // * Logout
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const SignInPage()));
                  },
                  child: const Text("Sign Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[200],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  )),
            ),

            const Spacer(),

            Center(
                child: TextButton(
              onPressed: () {
                MapService.launchUrlFunc(Uri.parse(
                    'https://sites.google.com/view/nextonmap-privacypolicy/home'));
              },
              child: const Text(
                "Privacy Policy",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )),
          ],
        ),
      ),
    ));
  }
}
