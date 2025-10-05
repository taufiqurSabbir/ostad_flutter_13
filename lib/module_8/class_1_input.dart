import 'package:flutter/material.dart';

class FlutterInput extends StatelessWidget {
  const FlutterInput({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/0/0d/Facebook_logo_%28June_30%2C_2015%29.png'),
            Image.asset('asset/YT.png'),

            SizedBox(
              height: 20,
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  suffixIcon: Icon(Icons.check),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange)),
                  filled: true,
                  contentPadding: EdgeInsets.all(20),
                  // fillColor: Colors.grey.shade100,

                  hintText: 'Enter phone number',
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  helperText: '017xxx',
                  helperStyle: TextStyle(color: Colors.blue),
                  labelText: 'Phone number',
                  labelStyle: TextStyle(color: Colors.orange, fontSize: 20)),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.remove_red_eye),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange)),
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.orange, fontSize: 20)),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      print(phoneController.text);
                      print(passwordController.text);

                      if (passwordController.text.length < 6) {
                        print('must must be min 8');
                      }
                    },
                    child: Text('Submit')))
          ],
        ),
      ),
    );
  }
}
