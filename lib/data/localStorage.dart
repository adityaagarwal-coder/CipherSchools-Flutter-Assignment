import 'package:hive/hive.dart';

import 'models/transactionModel.dart';

class LocalStorage {
  late final box;
  LocalStorage({String boxName = "localStorage"}) {
    box = Hive.box(boxName);
  }
  String totalIncome = 'totalIncome';
  String totalExpense = 'totalExpense';
  String amount = 'amount';
  String category = 'category';
  String description = 'description';
  String type = '0';
  String transactionId = 'id';

  String getTransactionId() {
    return box.get(transactionId) ?? "";
  }

  String setTransactionId(String value) {
    return box.put(transactionId, value);
  }

  String getTotalIncome() {
    return box.get(totalIncome) ?? "";
  }

  String setTotalIncome(String value) {
    return box.put(totalIncome, value);
  }

  String getTotalExpense() {
    return box.get(totalExpense) ?? "";
  }

  String setTotalExpense(String value) {
    return box.put(totalExpense, value);
  }

  // TransactionModel getTransactionInfo() {
  //   return TransactionModel(
  //     id: box.get(transactionId) ?? "",
  //     amount: box.get(amount) ?? "",
  //     category: box.get(category) ?? "",
  //     description: box.get(description) ?? "",
  //     type: box.get(type) ?? "",
  //   );
  // }
}
