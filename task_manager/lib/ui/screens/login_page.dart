import 'package:flutter/material.dart';

import '../widgets/screen_background.dart';
import 'forget_password_email_verify.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    void _onTabForgetPassword(){
      Navigator.push(context, MaterialPageRoute(builder:(context)=>ForgetPasswordEmailVerify()));
    }
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const SizedBox(height: 150,),
                Text('Get Started With',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 25,),
                  
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 20,),
                FilledButton(
                  
                    onPressed: () {},
                    child: Icon(Icons.arrow_circle_right_outlined)),
                const SizedBox(height: 35,),
                  
                Center(
                  child: Column(
                    children: [
                      TextButton(onPressed: _onTabForgetPassword, child: Text('Forget password')),
                      RichText(
                        text: TextSpan(
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                  text: 'Sign Up', style: TextStyle(color: Colors.green)),
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
      ),
    );

  }
}
