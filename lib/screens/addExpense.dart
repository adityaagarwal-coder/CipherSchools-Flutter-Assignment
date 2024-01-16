import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../data/models/transactionModel.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController amountController =
      TextEditingController(text: '0');
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedValue = 'Category';
  String selectedValue1 = 'Description';
  String selectedValue2 = 'Wallet';
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box<TransactionModel>('transactions');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#0077FF"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Expense",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      backgroundColor: HexColor("#0077FF"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "How much?",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: HexColor("#FCFCFC")),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '\u20B9 ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      // labelText: 'Rs 0',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 64.0,
                          fontWeight: FontWeight.w600),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Category',
                    'Shopping',
                    'Subscription',
                    'Travel',
                    'Food'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Spacer(),
                DropdownButton<String>(
                  value: selectedValue1,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue1 = newValue!;
                    });
                  },
                  items: <String>[
                    'Description',
                    'Buy some grocery',
                    'Disney+ Annually',
                    'Chandigarh to Delhi',
                    'Buy yummy food'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Spacer(),
                // Text(
                //   'Selected Date: ${selectedDate.toLocal()}',
                //   style: TextStyle(fontSize: 16),
                // ),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () => _selectDate(context),
                //   child: Text('Select Date'),
                // ),
                DropdownButton<String>(
                  value: selectedValue2,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue2 = newValue!;
                    });
                  },
                  items: <String>[
                    'Wallet',
                    'Option 2',
                    'Option 3',
                    'Option 4',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    final newTransaction = TransactionModel()
                      ..amount = double.parse(amountController.text)
                      ..category = selectedValue
                      ..description = selectedValue1
                      ..type = "0"
                      ..date = DateTime.now();

                    transactionBox.add(newTransaction);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Main()),
                    );
                  },
                  child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                          color: HexColor("#7F3DFF"),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
