import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/screens/auth/signup_screen.dart';
import 'package:vibe/views/widgets/text_input_field.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Get user details from googleUser
        // Perform authentication with your backend using the obtained credentials
      }
    } catch (error) {
      print('Google login error: $error');
    }
  }

  Future<void> _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        // Get user details from accessToken
        // Perform authentication with your backend using the obtained credentials
      }
    } catch (error) {
      print('Facebook login error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      if (MediaQuery.of(context).size.width > 768) // Only show sidebar on desktop
        Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 171, 41, 231),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(500.0),
              bottomRight: Radius.circular(500.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),

      Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 300,
              ),
              Text(
                'Vibe: Feel The Vibes™',
                style: TextStyle(
                  fontSize: 35,
                  color: buttonColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
               ElevatedButton.icon(
                    onPressed: _loginWithGoogle,
                    icon: Icon(Icons.login),
                    label: Text('Login with Google'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Use appropriate button color
                    ),
                  ),

                  // Login with Facebook button
                  ElevatedButton.icon(
                    onPressed: _loginWithFacebook,
                    icon: Icon(Icons.login),
                    label: Text('Login with Facebook'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Use appropriate button color
                    ),
                  ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  isObscure: true,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: InkWell(
                  onTap: () => authController.loginUser(
                    _emailController.text,
                    _passwordController.text,
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (MediaQuery.of(context).size.width < 768)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 20, color: buttonColor),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),

      // Sidebar on desktop screens
    ]));
  }
}
