import 'package:flutter/material.dart';
import 'package:flutter_13_firebase/service/auth_service.dart';
import 'package:flutter_13_firebase/signup_page.dart';
import 'package:flutter_13_firebase/task_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Text(
                'Welcome Back',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                    final user =   await AuthService()
                          .login(emailController.text, passwordController.text);

                    if(user!.emailVerified){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskManager()));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please verify your email...!')));
                    }

                    },
                    child: Text('Login')),
              ),
              TextButton(onPressed: () async {
               await AuthService().resetPassword(emailController.text);
              }, child: Text('Forget password')),
              ElevatedButton.icon(
                  onPressed: () async {
                    final user = await AuthService().signInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskManager()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Something wrong...!')));
                    }
                  },
                  icon: Icon(Icons.login),
                  label: Text(
                    'Login with Gmail',
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text('Create Account')),
            ],
          ),
        ),
      ),
    );
  }
}
