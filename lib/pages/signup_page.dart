import 'package:flutter/material.dart';
import 'package:money_tracker_app/pages/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signUp({
    required final email,
    required final password,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await client.auth.signUp(
          email: email,
          password: password);
      if (mounted) {
        Navigator.popAndPushNamed(context, '/');
        context.showSnackBar('Confirm your account');
      }
    } on AuthException catch (error) {
      context.showSnackBar(error.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return 'Please fill up with correct email';
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return 'Please fill up with correct password';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const SizedBox(
                  child: CircularProgressIndicator(),
                )
                    : OutlinedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState?.validate();
                      if (isValid != true) {
                        return;
                      }
                      final res = _signUp(
                          email: _emailController.text,
                          password: _passwordController.text
                      );
                      res.then((value) {
                        _emailController.clear();
                        _passwordController.clear();
                      });
                    },
                    child: const Text('Sign Up')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
