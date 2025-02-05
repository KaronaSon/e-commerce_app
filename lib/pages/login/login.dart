import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/login_helper.dart';
import '../../routes/routes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePS = true;

  final TextEditingController _textUsername = TextEditingController();
  final TextEditingController _textPassword = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    );

    _shakeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  void triggerShake() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textUsername.dispose();
    _textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenHeight - 90,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/profile/image copy 2.png",
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.3,
                              ),
                              SizedBox(height: 30),
                              AnimatedBuilder(
                                animation: _shakeAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_shakeAnimation.value, 0),
                                    child: child,
                                  );
                                },
                                child: _buildTextField(
                                  controller: _textUsername,
                                  hintText: "Username",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      triggerShake();
                                      return "Please enter your username";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              AnimatedBuilder(
                                animation: _shakeAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_shakeAnimation.value, 0),
                                    child: child,
                                  );
                                },
                                child: _buildTextField(
                                  controller: _textPassword,
                                  hintText: "Password",
                                  obscureText: _obscurePS,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      triggerShake();
                                      return "Please enter your password";
                                    }
                                    return null;
                                  },
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscurePS = !_obscurePS;
                                      });
                                    },
                                    child: Icon(
                                      _obscurePS
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width,
                                    50,
                                  ),
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: _loginUser,
                                child: const Text(
                                  "LOGIN",
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildBottom(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildBottom() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 16,
                // color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 10),
            Bounceable(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.register,
                  (route) => false,
                );
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  // color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final db = LoginDatabaseHelper.instance;
        final dbConnection = await db.database;

        final result = await dbConnection.query(
          'users',
          where: 'username = ? AND password = ?',
          whereArgs: [_textUsername.text, _textPassword.text],
        );

        if (result.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('username', _textUsername.text);
          await prefs.setBool('showWelcomeDialog', true);

          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.mainScreen,
            (route) => false,
          );
        } else {
          triggerShake();
          IconSnackBar.show(
            context,
            snackBarType: SnackBarType.fail,
            label: 'Invalid username or password',
          );
        }
      } catch (e) {
        IconSnackBar.show(
          context,
          snackBarType: SnackBarType.alert,
          label: 'Error occurred while logging in',
        );
      }
    }
  }
}
