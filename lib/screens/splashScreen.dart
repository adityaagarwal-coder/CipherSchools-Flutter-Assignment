import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#7F3DFF'),
      body: Center(
        child: Container(
            height: 300,
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                  'assets/Vector (1).png',
                )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "CIPHERX",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 36,
                      fontFamily: 'Bruno Ace SC'),
                ),
              ],
            )),
      ),
    );
  }
}
