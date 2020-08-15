import 'package:expenses_app/components/chart_bar.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get _groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var transaction in recentTransactions) {
        bool sameDay = transaction.date.day == weekDay.day;
        bool sameMonth = transaction.date.month == weekDay.month;
        bool sameYear = transaction.date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += transaction.value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalSum {
    return _groupedTransactions.fold(0.0, (sum, tr) => sum + tr['value']);
  }

  @override
  Widget build(BuildContext context) {
    _groupedTransactions;
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _groupedTransactions.map((t) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                value: t["value"],
                label: t["day"],
                percentage: _weekTotalSum == 0
                    ? 0
                    : (t['value'] as double) / _weekTotalSum,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
