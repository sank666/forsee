import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foresee_cycles/pages/home/appbar.dart';
import 'package:foresee_cycles/pages/models.dart';
import 'package:foresee_cycles/utils/styles.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int age = userdata.age;
  int height = userdata.height;
  int weight = userdata.weight;
  int temp;

  //edit user details
  editUser() async {
    final CollectionReference userData =
        FirebaseFirestore.instance.collection('user');
    User user = FirebaseAuth.instance.currentUser;
    var uid = user.uid;
    await userData.doc(uid).update({
      'age': age,
      'height': height,
      'weight': weight,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customAppBar(context, "Edit"),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    // vertical: screenSize.height * 0.005,
                    horizontal: screenSize.height * 0.03),
                child: Text(
                  'Age',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.01,
                    horizontal: screenSize.height * 0.025),
                child: Material(
                  elevation: 5.0,
                  shadowColor: CustomColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    initialValue: userdata.age.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (input) {
                      setState(() {
                        age = int.parse(input);
                      });
                      print('age: $input');
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Age',
                      prefixIcon: Icon(Icons.person_outline),
                      labelStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    // vertical: screenSize.height * 0.005,
                    horizontal: screenSize.height * 0.03),
                child: Text(
                  'Height',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.01,
                    horizontal: screenSize.height * 0.025),
                child: Material(
                  elevation: 5.0,
                  shadowColor: CustomColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    initialValue: userdata.height.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (input) {
                      setState(() {
                        height = int.parse(input);
                      });
                      print('height: $input');
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Height',
                      prefixIcon: Icon(Icons.height),
                      labelStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    // vertical: screenSize.height * 0.005,
                    horizontal: screenSize.height * 0.03),
                child: Text(
                  'Weight',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.01,
                    horizontal: screenSize.height * 0.025),
                child: Material(
                  elevation: 5.0,
                  shadowColor: CustomColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: TextFormField(
                    initialValue: userdata.weight.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (input) {
                      setState(() {
                        weight = int.parse(input);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Weight',
                      prefixIcon: Icon(Icons.line_weight_outlined),
                      labelStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: screenSize.width * 0.4,
            child: Center(
              child: Container(
                width: screenSize.width * 0.25,
                child: TextButton(
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(screenSize * 0.05),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        CustomColors.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red))),
                  ),
                  onPressed: editUser,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
