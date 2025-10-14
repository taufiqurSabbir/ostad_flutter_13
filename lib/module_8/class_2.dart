import 'package:flutter/material.dart';
import 'package:flutter_13/module_8/home_2.dart';

import '../home.dart';
import 'dashboard.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Image.asset(
            'asset/YT.png',
            height: 250,
            width: 250,
          ),
          Text('Login with phone and password'),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('phone number'),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: 'Phone number', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      } else if (value.length != 11) {
                        return 'Please enter correct number';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length <= 6) {
                        return 'Password must be at least 6 characters';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 300,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));

                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Home()));
                            }
                          },
                          child: Text('Submit'))),

                  // Navigator name
                  ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, 'btns');
                  }, child: Text('BTNS')),

                  ElevatedButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, 'home');
                  }, child: Text('home')),


                  ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, 'Dashboard', arguments: {
                      'phone' : phoneController.text,
                      'name': 'Taufiq'
                    });
                  }, child: Text('Dashboard')),

                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeTwo()));
                      },
                      child: Text('Home-2')),

                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.pushReplacement(context,
                  //           MaterialPageRoute(builder: (context) => Dashboard(phone: phoneController.text,)));
                  //     },
                  //     child: Text('Dashboard'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
