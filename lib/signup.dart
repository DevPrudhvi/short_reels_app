import 'package:btsreels/terms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'variables.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();

  registerUser() {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((signedUser){
      userCollection.doc(signedUser.user.uid).set({
        'username': userController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'uid': signedUser.user.uid,
        'profilepic': 'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'
      });
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lets goooo',
              style: mystyle(
                25,
                Colors.black,
                FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "SignUp",
              style: mystyle(
                25,
                Colors.black,
                FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  labelStyle: mystyle(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  labelStyle: mystyle(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  labelStyle: mystyle(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => registerUser(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: mystyle(
                      20,
                      Colors.white,
                      FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I agree to',
                  style: mystyle(20),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Terms(),
                      ),
                    );
                  },
                  child: Text(
                    'Terms of policy',
                    style: mystyle(20, Colors.purple),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
