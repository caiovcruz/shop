import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/auth.dart';
import '../utils/text_field_validator.dart';

enum AuthMode {
  signIn,
  signUp,
}

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AuthMode _authMode = AuthMode.signIn;
  bool get isSignIn => _authMode == AuthMode.signIn;
  bool get isSignUp => _authMode == AuthMode.signUp;

  void _switchAuthMode() {
    setState(() {
      _authMode = isSignIn ? AuthMode.signUp : AuthMode.signIn;
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error has ocurred'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final auth = Provider.of<Auth>(context, listen: false);
      final messenger = ScaffoldMessenger.of(context);

      try {
        if (isSignIn) {
          await auth.signIn(
            _authData['email']!,
            _authData['password']!,
          );

          messenger.showSnackBar(const SnackBar(
            content: Text('Successfully signed in!'),
            duration: Duration(seconds: 2),
          ));
        } else {
          await auth.signUp(
            _authData['email']!,
            _authData['password']!,
          );

          messenger.showSnackBar(const SnackBar(
            content: Text('Successfully signed up!'),
            duration: Duration(seconds: 2),
          ));

          _switchAuthMode();
        }
      } on AuthException catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog('An unexpected error has ocurred');
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: isSignIn ? 310 : 400,
        width: size.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: emailValidator,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                    icon: Icon(_showPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                obscureText: _showPassword ? false : true,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: passwordValidator,
                textInputAction:
                    isSignUp ? TextInputAction.next : TextInputAction.done,
                onFieldSubmitted: (_) => isSignIn ? _submit() : null,
              ),
              if (isSignUp)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                          () => _showConfirmPassword = !_showConfirmPassword),
                      icon: Icon(_showConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                  obscureText: _showConfirmPassword ? false : true,
                  validator: isSignUp ? confirmPasswordValidator : null,
                  textInputAction:
                      isSignUp ? TextInputAction.done : TextInputAction.none,
                  onFieldSubmitted: (_) => isSignUp ? _submit() : null,
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      ),
                      child: Text(isSignIn ? 'Sign In' : 'Sign Up'),
                    ),
              const Spacer(),
              TextButton(
                onPressed: () => _switchAuthMode(),
                child: Text(
                    isSignIn ? 'Want to register?' : 'Already have account?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? emailValidator(email) {
    final trimmedEmail = (email ?? '').trim();

    final validations = [
      TextFieldValidator.required('Email', trimmedEmail),
      TextFieldValidator.email('Email', trimmedEmail),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? passwordValidator(password) {
    final trimmedPassword = (password ?? '').trim();

    final validations = [
      TextFieldValidator.required('Password', trimmedPassword),
      if (isSignUp)
        TextFieldValidator.minLength('Password', trimmedPassword, 8),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }

  String? confirmPasswordValidator(password) {
    final trimmedPassword = (password ?? '').trim();

    final validations = [
      TextFieldValidator.required('Confirm Password', trimmedPassword),
      TextFieldValidator.match(
          'Confirm Password', trimmedPassword, _passwordController.text.trim()),
    ];

    for (var validation in validations) {
      if (validation != null) {
        return validation;
      }
    }

    return null;
  }
}
