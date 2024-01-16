import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/transactionModel.dart';
import 'addExpense.dart';
import 'transactionListScreen.dart';

void doNothing(BuildContext context) {}
final user = FirebaseAuth.instance.currentUser!;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final transactionsBox = Hive.box<TransactionModel>('transactions');
  ValueNotifier<double> sumOfExpenseNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<double> sumOfIncomeNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<double> differenceNotifier = ValueNotifier<double>(0.0);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // sumOfExpenseNotifier = ValueNotifier<double>(calculateSumOfExpenses());
    updateSumOfExpenses();
    // sumOfIncomeNotifier = ValueNotifier<double>(calculateSumOfIncome());
    updateSumOfIncome();
    // differenceNotifier =
    //     ValueNotifier<double>(calculateDifferenceOfTransactions());
    updateDifference();
    _tabController = TabController(length: 4, vsync: this);
  }

  void updateSumOfExpenses() async {
    double result = await calculateSumOfExpenses();
    sumOfExpenseNotifier.value = result;
  }

  void updateSumOfIncome() async {
    double result = await calculateSumOfIncome();
    sumOfIncomeNotifier.value = result;
  }

  void updateDifference() async {
    double result = await calculateDifferenceOfTransactions();
    differenceNotifier.value = result;
  }

  @override
  void dispose() {
    sumOfExpenseNotifier.dispose();
    sumOfIncomeNotifier.dispose();
    differenceNotifier.dispose();
    // differenceNotifier =
    //     ValueNotifier<double>(calculateDifferenceOfTransactions());
    _tabController.dispose();
    super.dispose();
  }

  Future<Box<TransactionModel>> openBox() async {
    return await Hive.openBox<TransactionModel>('transactions');
  }

  Future<double> calculateSumOfExpenses() async {
    // final transactionBox = Hive.box<TransactionModel>('transactions');
    final transactionBox = await openBox();

    return transactionBox.values
        .where((transaction) => transaction.type == "0")
        .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
  }

  Future<double> calculateSumOfIncome() async {
    // final transactionBox = Hive.box<TransactionModel>('transactions');
    final transactionBox = await openBox();

    return transactionBox.values
        .where((transaction) => transaction.type == "1")
        .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
  }

  Future<double> calculateDifferenceOfTransactions() async {
    // final transactionBox = Hive.box<TransactionModel>('transactions');
    final transactionBox = await openBox();

    double sumOfType0 = transactionBox.values
        .where((transaction) => transaction.type == "0")
        .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);

    double sumOfType1 = transactionBox.values
        .where((transaction) => transaction.type == "1")
        .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);

    return sumOfType1 - sumOfType0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HexColor("#FFF6E5"),
              HexColor("#F8EDD8")
            ], // Adjust the colors as needed
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.photoURL!)),
                  Container(
                    child: Row(
                      children: [
                        // Icon(Icons.arrow_downward),
                        Text(
                          'January',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: HexColor('#212325')),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.notifications,
                      size: 30, color: HexColor("#7F3DFF"))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Account Balance",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: HexColor("#91919F")),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Center(
                child: ValueListenableBuilder<double>(
                    valueListenable: differenceNotifier,
                    builder: (context, difference, _) {
                      return Text(
                        '\u20B9 $difference',
                        style: TextStyle(
                            fontSize: 40,
                            color: HexColor("#161719"),
                            fontWeight: FontWeight.w800),
                      );
                    }),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 80,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          color: HexColor("#00A86B"),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/Group 222.png'),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Income",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              ValueListenableBuilder<double>(
                                  valueListenable: sumOfIncomeNotifier,
                                  builder: (context, sum, _) {
                                    return Text(
                                      '\u20B9 $sum',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 80,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          color: HexColor("#FD3C4A"),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/Group 223.png'),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Expenses",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              ValueListenableBuilder<double>(
                                  valueListenable: sumOfExpenseNotifier,
                                  builder: (context, sum, _) {
                                    return Text(
                                      '\u20B9 $sum',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      'Today',
                      style: TextStyle(
                          color: HexColor("#91919F"),
                          fontWeight: FontWeight
                              .w500 // Set your desired text color here
                          ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Week',
                      style: TextStyle(
                          color: HexColor("#91919F"),
                          fontWeight: FontWeight
                              .w500 // Set your desired text color here
                          ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Month',
                      style: TextStyle(
                          color: HexColor("#91919F"),
                          fontWeight: FontWeight
                              .w500 // Set your desired text color here
                          ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Year',
                      style: TextStyle(
                          color: HexColor("#91919F"),
                          fontWeight: FontWeight
                              .w500 // Set your desired text color here
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "Recent Transaction",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: 78,
                    height: 32,
                    decoration: BoxDecoration(
                        color: HexColor("#EEE5FF"),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: Center(
                      child: Text(
                        "See All",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: HexColor("#7F3DFF")),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TransactionListScreen(timePeriod: TimePeriod.today),
                    TransactionListScreen(timePeriod: TimePeriod.week),
                    TransactionListScreen(timePeriod: TimePeriod.month),
                    TransactionListScreen(timePeriod: TimePeriod.year),
                  ],
                ),
              ),
            ),
            // Container(
            //   child: ValueListenableBuilder(
            //     valueListenable: transactionsBox.listenable(),
            //     builder: (context, Box<TransactionModel> box, _) {
            //       return Expanded(
            //         child: ListView.builder(
            //           itemCount: box.length,
            //           itemBuilder: (context, index) {
            //             final transaction = box.getAt(index)!;

            //             return Slidable(
            //               startActionPane: ActionPane(
            //                 motion: ScrollMotion(),
            //                 children: [
            //                   SlidableAction(
            //                     onPressed: doNothing,
            //                     backgroundColor: Color(0xFFFE4A49),
            //                     foregroundColor: Colors.white,
            //                     icon: Icons.delete,
            //                     label: 'Delete',
            //                   ),
            //                 ],
            //               ),
            //               child: Card(
            //                 margin: EdgeInsets.symmetric(horizontal: 20),
            //                 child: Container(
            //                   height: 60,
            //                   padding: EdgeInsets.symmetric(vertical: 10),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Column(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             '${transaction.category}',
            //                             style: TextStyle(
            //                                 color: Colors.black,
            //                                 fontWeight: FontWeight.w500,
            //                                 fontSize: 16),
            //                           ),
            //                           Text(
            //                             '${transaction.description}',
            //                             style: TextStyle(
            //                                 color: HexColor("#91919F"),
            //                                 fontWeight: FontWeight.w500,
            //                                 fontSize: 13),
            //                           ),
            //                         ],
            //                       ),
            //                       Column(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             'Rs ${transaction.amount}',
            //                             style: TextStyle(
            //                                 color: HexColor("#FD3C4A"),
            //                                 fontWeight: FontWeight.w500,
            //                                 fontSize: 16),
            //                           ),
            //                           // Text(
            //                           //   '${transaction.description}',
            //                           //   style: TextStyle(
            //                           //       color: HexColor("#91919F"),
            //                           //       fontWeight: FontWeight.w500,
            //                           //       fontSize: 13),
            //                           // ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
