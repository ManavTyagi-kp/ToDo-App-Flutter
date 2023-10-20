// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:to_do_list/UserAuth/loginPage.dart';
import 'package:to_do_list/UserAuth/registration.dart';
import 'package:to_do_list/pages/NavigatonBar.dart';
import 'package:to_do_list/pages/account_page.dart';
import 'package:to_do_list/pages/radio.dart';
import 'package:to_do_list/utility/routes.dart';

import 'firebase_options.dart';
// import 'package:to_do_list/pages/list.dart';
// import 'package:to_do_list/pages/swapableList.dart';
// import 'package:to_do_list/pages/timerList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      // home: const MyHomePage(
      //   title: 'TODO List',
      // ),
      // home: const RootPage(),
      home: const RadioPage(),
      // initialRoute: "/signup",
      // initialRoute: "/",
      // routes: {
      //   "/": (context) => const BottomNav(currentIndex: 0),
      //   MyRoutes.homeRoute: (context) => const BottomNav(currentIndex: 0),
      //   MyRoutes.loginAuth: (context) => const LoginPageAuth(),
      //   MyRoutes.signup: (context) => const RootPage(),
      //   MyRoutes.navRoute: (context) => const BottomNav(currentIndex: 0),
      //   MyRoutes.completed: (context) => const BottomNav(currentIndex: 1),
      //   MyRoutes.onGoing: (context) => const BottomNav(currentIndex: 2),
      //   MyRoutes.account: (context) => const AccountPage(),
      // },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;
//     var email = user!.email ?? '';
//     // var name = user!.displayName ?? '';
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 19, 18, 18),
//         title: Text(
//           widget.title,
//           style: const TextStyle(
//               color: Color.fromARGB(255, 228, 221, 221),
//               fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               print('Account');
//               Navigator.pushNamed(context, "/accountPage");
//             },
//             child: Column(
//               children: [
//                 const CircleAvatar(
//                   radius: 12,
//                   backgroundImage: NetworkImage(
//                       "https://cdn.vectorstock.com/i/1000x1000/30/97/flat-business-man-user-profile-avatar-icon-vector-4333097.webp"),
//                 ),
//                 // Text(
//                 //   email,
//                 //   style: const TextStyle(color: Colors.white),
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       // body: ListViewer(),
//       // body: MyList(),
//       // body: ListViewerSwap(),
//       // body: ListViewerTimer(),
//       body: const BottomNav(
//         currentIndex: 0,
//       ),
//     );
//   }
// }

class MyAppBar extends StatelessWidget {
  final String title;
  const MyAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 18, 18),
        title: Text(
          title,
          style: const TextStyle(
              color: Color.fromARGB(255, 228, 221, 221),
              fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              debugPrint('Account');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AccountPage();
              }));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                        "https://cdn.vectorstock.com/i/1000x1000/30/97/flat-business-man-user-profile-avatar-icon-vector-4333097.webp"),
                  ),
                  // Text(
                  //   email,
                  //   style: const TextStyle(color: Colors.white),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
