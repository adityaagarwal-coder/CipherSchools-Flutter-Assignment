import 'dart:convert';
import 'package:hive/hive.dart';
part 'transactionModel.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late double amount;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late String type;

  @HiveField(4)
  DateTime? date;
}
