import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';

import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';
import 'forget_password_email_verify.dart';
import 'main_nav_bar_holder_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _signInProgress = false;

  @override
  Widget build(BuildContext context) {

    void _onTabSignUp(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
    }

    void _onTabForgetPassword(){
      Navigator.push(context, MaterialPageRoute(builder:(context)=>ForgetPasswordEmailVerify()));
    }
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const SizedBox(height: 150,),
                  Text('Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25,),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),

                    validator: (String ? value){
                      if(value == null || value.isEmpty){
                        return 'please enter your email';
                      }

                      final emailRegExp = RegExp(  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if(!emailRegExp.hasMatch(value)){
                        return 'Please enter valid email';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),

                    obscureText: true,
                    validator: (String ? value){
                      if(value == null || value.isEmpty){
                        return 'please enter your password';
                      }

                      if(value.length <= 6){
                        return 'Enter password more than 6';
                      }

                      return null;
                    },

                  ),
                  const SizedBox(height: 20,),
                  FilledButton(

                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          _signIn();
                        }

                      },
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
                                    text: 'Sign Up', style: TextStyle(color: Colors.green),

                                recognizer: TapGestureRecognizer()..onTap =_onTabSignUp
                                ),
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
      ),
    );



  }

  _clearTextField(){
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _signIn()async{
    setState(() {
      _signInProgress = true;
    });

    Map<String,dynamic>requestBody = {
      "email":_emailController.text,
      "password":_passwordController.text,
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );

    setState(() {
      _signInProgress = false;
    });

    if(response.isSuccess){
      _clearTextField();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login success..!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),

      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainNavBarHolderScreen()));
    }else{

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),

      );
    }
  }




  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
