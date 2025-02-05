import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../database/login_helper.dart';
import '../../routes/routes.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePS = true;
  bool _obscureCF = true;

  final TextEditingController _textFirstName = TextEditingController();
  final TextEditingController _textLastName = TextEditingController();
  final TextEditingController _textUsername = TextEditingController();
  final TextEditingController _textPassword = TextEditingController();
  final TextEditingController _textCPS = TextEditingController();

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
    _textFirstName.dispose();
    _textLastName.dispose();
    _textUsername.dispose();
    _textPassword.dispose();
    _textCPS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: screenHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                          "assets/profile/image copy.png",
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -5,
                                      bottom: -5,
                                      child: IconButton.filled(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          minimumSize: const Size(20, 20),
                                        ),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildTextField(
                                controller: _textFirstName,
                                hintText: "First Name",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    triggerShake();
                                    return "Please enter your first name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _textLastName,
                                hintText: "Last Name",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    triggerShake();
                                    return "Please enter your last name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
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
                              const SizedBox(height: 20),
                              _buildTextField(
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
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _textCPS,
                                hintText: "Confirm Password",
                                obscureText: _obscureCF,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    triggerShake();
                                    return "Please confirm your password";
                                  }
                                  return null;
                                },
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureCF = !_obscureCF;
                                    });
                                  },
                                  child: Icon(
                                    _obscureCF
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width,
                                    60,
                                  ),
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: _registerUser,
                                child: const Text("REGISTER"),
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
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
              "Already have an account?",
              style: TextStyle(
                fontSize: 16,
                // color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              },
              child: const Text(
                "Login",
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

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_textPassword.text.length < 8) {
        IconSnackBar.show(
          context,
          snackBarType: SnackBarType.fail,
          label: 'Password must be at least 8 characters long!',
        );
        return;
      }

      if (_textPassword.text.length > 128) {
        IconSnackBar.show(
          context,
          snackBarType: SnackBarType.fail,
          label: 'Password is too long! Maximum 128 characters.',
        );
        return;
      }
      if (_textPassword.text != _textCPS.text) {
        IconSnackBar.show(
          context,
          snackBarType: SnackBarType.fail,
          label: 'Passwords do not match!',
        );
        return;
      }
      final user = {
        'firstName': _textFirstName.text,
        'lastName': _textLastName.text,
        'username': _textUsername.text,
        'password': _textPassword.text,
      };

      try {
        await LoginDatabaseHelper.instance.insertUser(user);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        _textFirstName.clear();
        _textLastName.clear();
        _textUsername.clear();
        _textPassword.clear();
        _textCPS.clear();
        FocusScope.of(context).unfocus();
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.login,
          (route) => false,
        );
      } on DatabaseException catch (e) {
        if (e.isUniqueConstraintError()) {
          IconSnackBar.show(
            context,
            snackBarType: SnackBarType.fail,
            label: 'Username already exists!',
          );
        } else {
          IconSnackBar.show(
            context,
            snackBarType: SnackBarType.fail,
            label: 'Database error: ${e}',
          );
        }
      } catch (e) {
        IconSnackBar.show(
          context,
          snackBarType: SnackBarType.fail,
          label: 'An unexpected error occurred!',
        );
      }
    }
  }
}
