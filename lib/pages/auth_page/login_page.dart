import 'package:deep_sight_ai_labs/constants/constant.dart';
import 'package:deep_sight_ai_labs/main_page.dart';
import 'package:deep_sight_ai_labs/pages/auth_page/widget/auth_input_field.dart';
import 'package:deep_sight_ai_labs/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enum/connection_status.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool checkboxValue = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return

       Scaffold(
        resizeToAvoidBottomInset: false,
        body:   Consumer<AuthProvider>(builder: (context, authProvider, _) {
       return   Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login_bg.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.5), BlendMode.darken),
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * .07,
              ),
              Image.asset(
                "assets/logo_2.png",
                height: 50,
              ),
              SizedBox(
                height: height * .07,
              ),
              Text(
                "Lets Sign you In",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor.withOpacity(.9)),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Adding Superpowers to CCTV",
                style: TextStyle(
                    color: Colors.white.withOpacity(.9), fontSize: 14),
              ),
              Spacer(),
              AuthInputField(
                inputController: emailController,
                inputType: TextInputType.emailAddress,
                hintText: "Enter Your username",
                label: "Username",
              ),
              SizedBox(
                height: 20,
              ),
              AuthInputField(
                inputController: passwordController,
                inputType: TextInputType.emailAddress,
                hintText: "Enter your password",
                label: "Password",
              ),
              Spacer(
                flex: 5,
              ),
              Center(
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Copyright © " + " ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(.9),
                              fontSize: 13)),
                      WidgetSpan(
                          child: InkWell(
                            onTap: () {
                              Constant()
                                  .openLink(url: "https://www.deepsightlabs.com/");
                            },
                            child: Text(
                              "DeepsightAI Labs Pvt. Ltd 2023.",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )),
                    ])),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      authProvider.login(
                          username: emailController.text,
                          password: passwordController.text,
                      context: context);

                    },

                    child: authProvider.connectionStatus == ConnectionStatus.none
                        ?
                    Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    )
                        : CircularProgressIndicator(
                      color: Colors.white,
                    )
                  )),
              SizedBox(
                height: height * .08,
              )
            ],
          ),
        );}

  ));

  }
}
