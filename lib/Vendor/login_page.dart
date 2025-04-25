import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart'; // Ensure this file has a valid HomePage widget.

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<VendorLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final enabled = false.obs;
  String? _emailError;
  String? _passwordError;
  final name = "Mohamed Saeed";
  String? welcomeMessage = "";
  bool _obscurePassword = true;
  final userType = Get.arguments;

  void _updateEnabled() {
    enabled.value =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  }

  // // Handle logout to clear userType and navigate to UserSelectionScreen
  // void _logout() async {
  //   final box = GetStorage();
  //   await box.remove('userType'); // Remove userType from GetStorage
  //   Get.offAll(() => UserSelectionScreen()); // Navigate to UserSelectionScreen
  // }

  void _handleLogin() {
    setState(() {
      _emailError =
          _emailController.text.trim().isEmpty
              ? "Please enter your E-Mail"
              : null;

      _passwordError =
          _passwordController.text.trim().isEmpty
              ? "Please enter your Password"
              : null;
    });

    if (_emailError == null && _passwordError == null) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      // bool isPhoneNumber = RegExp(r'^[0-9]+$').hasMatch(email);
      // String welcomeMessage = isPhoneNumber ? "Welcome" : "Welcome Mr. $email";

      // Example: Custom logic based on email
      if (email == 'mohamed.saeed201699@gmail.com' && password == 'Memo1998') {
        welcomeMessage = "Welcome Mr.$name";
        // Navigate to the HomePage and prevent going back to LoginScreen
        Get.offAll(
          () => HomePage(),
          // arguments: welcomeMessage,
          // arguments: userType,
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 500),
        );
        Get.snackbar(
          "Success",
          'You logged in Successfully Mr.$name',
          backgroundColor: Colors.white,
          borderColor: Colors.black,
          borderWidth: 1.5,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'Success',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          messageText: Text(
            "You logged in Successfully Mr.$name",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          "The E-mail Or Password is not correct",
          backgroundColor: Colors.white,
          borderColor: Colors.black,
          borderWidth: 1.5,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            'Error',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          messageText: Text(
            "The E-mail Or Password is not correct",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Toxido",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed:
        //         _logout, // Logout function to navigate to UserSelectionScreen
        //   ),
        // ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (a) => _updateEnabled(),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.orange,
                  autofillHints: [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: "E-Mail",
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.5),
                    ),
                    border: OutlineInputBorder(),
                    errorText: _emailError,
                    prefixIcon: Icon(Icons.email, color: Colors.orange),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (a) {
                    enabled.value = _passwordController.text.isNotEmpty;
                  },
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
                  cursorColor: Colors.orange,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.5),
                    ),
                    border: OutlineInputBorder(),
                    errorText: _passwordError,
                    prefixIcon: Icon(Icons.lock, color: Colors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Obx(() {
                  return ElevatedButton.icon(
                    onPressed: enabled.value ? _handleLogin : null,
                    label: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    icon: Icon(Icons.login, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
