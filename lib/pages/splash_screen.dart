import 'package:deep_sight_ai_labs/main_page.dart';
import 'package:flutter/material.dart';

import '../healper/sp_helper.dart';
import '../healper/sp_key_helper.dart';
import 'auth_page/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
  goToNextPage();
    super.initState();
  }

  goToNextPage() async {
    // await Future.delayed(Duration(seconds: 1));
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) {
    //   return MainPage();
    // }));

    await Future.delayed(Duration(seconds: 1));
   bool? isLogdin = await SpHelper().loadBool(SpKeyHelper.isLogdin) ?? false;

   if(isLogdin){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) {
       return MainPage();
     }));
   }else{
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) {
       return LoginScreen();
     }));
   }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo_2.png"),
          ],
        ),
      ),
    );
  }
}
