import 'package:flutter/material.dart';
import 'package:flutter_13_firebase/service/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          
            children: [
              SizedBox(height: 90,),
              Text('Create account',style: TextStyle(fontSize: 30),),
              SizedBox(height: 50,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 50,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white
                    ),
                    onPressed: () async {
                     await auth.signUp(emailController.text, passwordController.text);
          
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Account created'))
                     );
                     emailController.clear();
                     passwordController.clear();
          
                    }, child: Text('Sign up')),
              ),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Login')),
          
            ],
          ),
        ),
      ),
    );
  }
}
