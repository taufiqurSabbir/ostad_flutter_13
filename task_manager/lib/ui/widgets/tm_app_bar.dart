import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

import '../screens/update_profile_screen.dart';
class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userModel = authProvider.userModel;

    final profilePhoto = userModel?.photo ?? '';
    return AppBar(
      backgroundColor: Colors.green,
      title: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfileScreen()));
        },
        child: Row(
          children: [

            CircleAvatar(
              child: profilePhoto.isNotEmpty ? Image.memory(jsonDecode(profilePhoto)) : Icon(Icons.person),
            ),
            SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userModel!.firstName} ${userModel.lastName}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white
                  ),
                ),

                Text(userModel.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: (){
          authProvider.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/Login', (predicate)=>false);
        }, icon: Icon(Icons.logout))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>Size.fromHeight(kToolbarHeight);
}
