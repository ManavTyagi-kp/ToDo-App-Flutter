import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageAuth extends StatefulWidget {
  const LoginPageAuth({super.key});

  @override
  _LoginPageAuthState createState() => _LoginPageAuthState();
}

class _LoginPageAuthState extends State<LoginPageAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        // User is authenticated, store session data
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userCredential.user!.uid);
        await prefs.setString('email', userCredential.user!.email ?? '');
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacementNamed(
            context, '/home'); // Replace with your home screen route
      }
    } catch (e) {
      // Handle login failure
      print('Login failed: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Error'),
          content: const Text('Failed to log in. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
