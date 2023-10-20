import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/UserAuth/registration.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/pages/NavigatonBar.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    var email = user!.email ?? '';
    var name = user.displayName ?? '';
    const imageUrl =
        "https://cdn.vectorstock.com/i/1000x1000/30/97/flat-business-man-user-profile-avatar-icon-vector-4333097.webp";
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.square(55),
        child: MyAppBar(title: 'My Account'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 19, 18, 18),
                ),
                margin: EdgeInsets.zero,
                accountName: Text(
                  name,
                  style: const TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  email,
                  style: const TextStyle(color: Colors.white),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BottomNav(
                    currentIndex: 0,
                  );
                }));
              },
              child: const ListTile(
                leading: Icon(
                  CupertinoIcons.home,
                  color: Colors.black,
                ),
                title: Text(
                  "Home",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle click event
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BottomNav(
                    currentIndex: 2,
                  );
                }));
              },
              child: const ListTile(
                leading: Icon(
                  CupertinoIcons.square,
                  color: Colors.black,
                ),
                title: Text(
                  "OnGoing Tasks",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BottomNav(
                    currentIndex: 1,
                  );
                }));
              },
              child: const ListTile(
                leading: Icon(
                  CupertinoIcons.checkmark_square_fill,
                  color: Colors.black,
                ),
                title: Text(
                  "Completed Tasks",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                // Sign out from Firebase Auth
                await FirebaseAuth.instance.signOut();
                // Navigate to the sign-in page
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const RootPage();
                }), (route) => false);
              },
              leading: const Icon(
                CupertinoIcons.power,
                color: Colors.black,
              ),
              title: const Text(
                "Sign Out",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
