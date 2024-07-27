import 'package:flutter/material.dart';
import 'package:torihd/models/appState/profile_manager.dart';
import 'package:torihd/screens/upload/uploadmovie.dart';
import 'package:provider/provider.dart';

import '../../styles/snack_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // String _email = '';
  // String _password = '';
  void _submit(BuildContext context) async {
    try {
      await context.read<ProfileManager>().signIn(
            _emailController.text,
            _passwordController.text,
          );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UploadMovie()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in')),
      );
      // Perform the login action here, e.g., send the email and password to your server
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text('Logging in...')));
    }
  }

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/food_cupcake.jpg"),
                ),
                const Text(
                  "Login to Tori",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  // onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await context.read<ProfileManager>().signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                      showsnackBar('Signed in Successfull');
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      showsnackBar('Failed to sign in $e');
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
