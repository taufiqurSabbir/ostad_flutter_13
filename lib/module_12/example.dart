import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool isPasswordShow = true;
  bool isFav = false;

  toggleFav() {
    setState(() {
      isFav = !isFav;
      print(isFav);
    });
  }

  showPassword() {
    setState(() {
      isPasswordShow = !isPasswordShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                obscureText: isPasswordShow,
                decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordShow
                          ? Icons.remove_red_eye
                          : Icons.visibility_off),
                      onPressed: showPassword,
                    )),
              ),
              IconButton(
                  onPressed: (){
                    print('Clicked');
                    toggleFav();
                  },
                  color: isFav ? Colors.red : Colors.grey,
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 25,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
