import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/controllers/auth_controller.dart';
import 'package:vibe/views/screens/auth/login_screen.dart';
import 'package:vibe/views/widgets/text_input_field.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final AuthController authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 768)
            // Left section of the screen
            Container(
              width: 300,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 41, 130, 231),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(500.0),
                  bottomRight: Radius.circular(500.0),
                ),
              ),
               ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vibe',
                      style: TextStyle(
                        fontSize: 35,
                        color: buttonColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Stack(
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color.fromARGB(255, 175, 175, 175),
                                Color.fromARGB(255, 255, 255, 255),
                              ],
                              stops: [0.0, 1.0],
                              center: Alignment.center,
                              radius: 1.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png',
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () => authController.pickImage(),
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _usernameController,
                        labelText: 'Username',
                        icon: Icons.person,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _emailController,
                        labelText: 'Email',
                        icon: Icons.email,
                      ),
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => authController.registerUser(
                          _usernameController.text,
                          _emailController.text,
                          _passwordController.text,
                          authController.profilePhoto,
                        ),
                        child: const Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                 Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => authController.registerUserWithGoogle(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      authController.profilePhoto,
                    ),
                    icon: Icon(Icons.login),
                    label: Text('Sign up with Google'),
                    style: ElevatedButton.styleFrom(
                      // Button styles
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => authController.registerUserWithFacebook(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      authController.profilePhoto,
                    ),
                    icon: Icon(Icons.login),
                    label: Text('Sign up with Facebook'),
                    style: ElevatedButton.styleFrom(
                      // Button styles
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
          
                    const SizedBox(height: 15),
                    if (MediaQuery.of(context).size.width < 768)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 20, color: buttonColor),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
