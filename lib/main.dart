import 'package:expense_tracker/data/models/transactionModel.dart';
import 'package:expense_tracker/screens/addExpense.dart';
import 'package:expense_tracker/screens/addIncome.dart';
import 'package:expense_tracker/screens/home.dart';
import 'package:expense_tracker/screens/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'screens/gettingStartedScreen.dart';
import 'screens/profileScreen.dart';
import 'screens/splashScreen.dart';
import 'utils/googleSignIn.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transactions');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        home: SplashScreenWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Future.delayed(Duration(seconds: 5)), // Display splash for 2 seconds
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthenticationWrapper();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    return FutureBuilder<bool>(
      future: googleSignInProvider.isSignedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isSignedIn = snapshot.data ?? false;

          if (isSignedIn) {
            // User is signed in, navigate to home or any other screen
            return Main(); // Replace with your home screen
          } else {
            // User is not signed in, display the getting started screen
            return GettingStartedWrapper();
          }
        } else {
          // Loading state, you can display a loading indicator if needed
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class GettingStartedWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          GettingStartedScreen(), // Replace with your actual getting started screen
      debugShowCheckedModeBanner: false,
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Scaffold(body: Text("")),
    Profile(),
    Scaffold(body: Text("")),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF7F3DFF),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        unselectedLabelStyle: TextStyle(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#7F3DFF"),
        onPressed: () {
          _showTransactionTypeSelection(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showTransactionTypeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Expense'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddExpense()),
                  ); // Close the bottom sheet
                  // Add your logic for handling expense selection
                },
              ),
              ListTile(
                title: Text('Income'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddIncome()),
                  ); // Close the bottom sheet
                  // Add your logic for handling income selection
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
