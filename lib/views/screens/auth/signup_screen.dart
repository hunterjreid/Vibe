import 'package:flutter/material.dart';
import 'package:vibe/constants.dart';
import 'package:vibe/views/widgets/text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "assets/images/logo.png",
          width: 50,
        ),
        const Text(
          'Create Account',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 25,
        ),
        Stack(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(
                  'https://www.asiamediajournal.com/wp-content/uploads/2022/11/Default-PFP-1200x1200.jpg'),
              backgroundColor: Colors.grey,
            ),
            Positioned(
                bottom: -10,
                left: 30,
                child: IconButton(
                    onPressed: () => authController.pickImage(),
                    icon: const Icon(
                      Icons.add_a_photo,
                    )))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: TextInputField(
              controller: _usernameController, labelText: 'Username', icon: Icons.person),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child:
              TextInputField(controller: _emailController, labelText: 'Email', icon: Icons.email),
        ),
        const SizedBox(
          height: 15,
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
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 40,
          height: 50,
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
            onTap: () => authController.registeredUser(_usernameController.text,
                _emailController.text, _passwordController.text, authController.profilePhoto),
            child: const Center(
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account?',
              style: TextStyle(fontSize: 17),
            ),
            InkWell(
              onTap: () {
                print('going to create account');
              },
              child: Text(
                ' Login',
                style: TextStyle(fontSize: 17, color: buttonColor),
              ),
            ),
          ],
        )
      ]),
    ));
  }
}
