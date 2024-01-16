import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../data/models/transactionModel.dart';
import 'home.dart';

enum TimePeriod { today, week, month, year }

class TransactionListScreen extends StatefulWidget {
  // const TransactionListScreen({super.key});
  TimePeriod timePeriod;
  TransactionListScreen({required this.timePeriod});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionsBox = Hive.box<TransactionModel>('transactions');
    List<TransactionModel> filteredTransactions = [];

    bool isToday(DateTime date) {
      final now = DateTime.now();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }

    switch (widget.timePeriod) {
      case TimePeriod.today:
        filteredTransactions = transactionsBox.values
            .where((transaction) =>
                transaction.date != null &&
                isToday(transaction.date!)) // Implement isToday function
            .toList();
        break;
      case TimePeriod.week:
        // Implement filtering for the current week
        DateTime now = DateTime.now();
        DateTime startOfWeek =
            DateTime(now.year, now.month, now.day - now.weekday);
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

        filteredTransactions = transactionsBox.values
            .where((transaction) =>
                transaction.date != null &&
                transaction.date!.isAfter(startOfWeek) &&
                transaction.date!.isBefore(endOfWeek))
            .toList();
        break;
      case TimePeriod.month:
        // Implement filtering for the current month
        DateTime now = DateTime.now();
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        DateTime endOfMonth =
            DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

        filteredTransactions = transactionsBox.values
            .where((transaction) =>
                transaction.date != null &&
                transaction.date!.isAfter(startOfMonth) &&
                transaction.date!.isBefore(endOfMonth))
            .toList();
        break;
      case TimePeriod.year:
        // Implement filtering for the current year
        DateTime now = DateTime.now();
        DateTime startOfYear = DateTime(now.year, 1, 1);
        DateTime endOfYear = DateTime(now.year, 12, 31);

        filteredTransactions = transactionsBox.values
            .where((transaction) =>
                transaction.date != null &&
                transaction.date!.isAfter(startOfYear) &&
                transaction.date!.isBefore(endOfYear))
            .toList();
        break;
      case null:
      // TODO: Handle this case.
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];

        return Slidable(
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  transactionsBox.deleteAt(index);
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transaction.category}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        '${transaction.description}',
                        style: TextStyle(
                            color: HexColor("#91919F"),
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      transaction.type == '0'
                          ? Text(
                              '- \u20B9${transaction.amount}',
                              style: TextStyle(
                                  color: HexColor("#FD3C4A"),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            )
                          : Text(
                              '+ \u20B9${transaction.amount}',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                      Text(
                        '${transaction.date}',
                        style: TextStyle(
                            color: HexColor("#91919F"),
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
