import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bae.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../controller/auth_controller.dart';
import '../widgets/photo_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserModel user = AuthController.userModel!;

    emailController.text = user.email;
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    mobileController.text = user.mobile;



  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if(image != null){
      _selectedImage = image;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Update Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                photo_picker(
                  onTap: _pickImage,
                  selectedPhoto: _selectedImage,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(hintText: 'First name'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(hintText: 'Last name'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(hintText: 'Mobile'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your mobile';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (String? value) {
                    if ((value != null && value.isNotEmpty) && value.length < 6) {
                      return 'Enter a password more than 6 letters';
                    }
            
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                FilledButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        updateProfile();
                      }
                    },
                    child: Icon(Icons.arrow_circle_right_outlined)),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool isLoading = false;
  Future<void>updateProfile()async {
    isLoading = true;
    setState(() {
    });

    Map<String,dynamic>requestBody = {
      "email":emailController.text,
      "firstName":firstNameController.text,
      "lastName":lastNameController.text,
      "mobile":mobileController.text,

    };

    if(passwordController.text.isNotEmpty){
      requestBody['password'] = passwordController.text;
    }

    String ? encodedPhoto;

    if(_selectedImage != null){
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }

    final ApiResponse response =await ApiCaller.postRequest(url: Urls.updateProfileUrl, body: requestBody);

    isLoading = false;
    setState(() {

    });

    if(response.isSuccess){
        UserModel model =  UserModel(
          id: AuthController.userModel!.id,
          email:  emailController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          mobile: mobileController.text,
          photo: encodedPhoto ?? AuthController.userModel!.photo,
        );

        AuthController.updateUserData(model);
        showSnackBarMessage(context, 'Profile Updated');
    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }

  }
}
