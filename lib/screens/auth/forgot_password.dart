import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torihd/provider/profile_manager.dart';

import '../../styles/snack_bar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await context.read<ProfileManager>().resetPassword(
              _emailController.text,
            );
        showsnackBar('Password reset email sent');
        if (!context.mounted) return;
        Navigator.pop(context); // Go back to the login screen
      } catch (e) {
        showsnackBar('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/food_cupcake.jpg"),
              ),
              const Text(
                "Enter your email address to reset your password",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
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
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () => _submit(context),
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
