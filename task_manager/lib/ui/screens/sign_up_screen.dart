import 'package:flutter/material.dart';

import '../widgets/screen_background.dart';
import 'forget_password_verify_otp_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
              ),
              Text(
                'Join with us',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10,
              ),

              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(hintText: 'First name'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Last name'),
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(hintText: 'Mobile'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(
                height: 16,
              ),
              FilledButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordVerifyOtpScreen()));
                  },
                  child: Icon(Icons.arrow_circle_right_outlined)),
              const SizedBox(
                height: 35,
              ),
              Center(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                                text: 'Sign in',
                                style: TextStyle(color: Colors.green)),

                          ],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
