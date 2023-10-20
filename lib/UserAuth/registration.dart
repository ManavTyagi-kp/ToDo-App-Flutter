import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list/UserAuth/loginPage.dart';
import 'package:to_do_list/pages/NavigatonBar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Registration successful, you can navigate to another page here
        print('Registration successful! UserID: ${userCredential.user!.uid}');
      } catch (e) {
        // Registration failed, display an error message
        print('Registration failed. Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  // You can add additional email validation logic here
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  // You can add additional password validation logic here
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPageAuth()));
                },
                child: const Text(
                  'Already a user?, Login here',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            // User is already authenticated, navigate to home page
            // Navigator.pushNamed(context, '/home');
            // Navigator.pop(context);
            print('inititalizing');
            return const BottomNav(
              currentIndex: 0,
            );
          } else {
            // User is not authenticated, show registration page
            return const RegistrationPage();
          }
        }
      },
    );
  }
}
