import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class EarningsPage extends StatefulWidget {
  @override
  _EarningsPageState createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  String? selectedMonth;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<charts.Series<DailyEarnings, int>> seriesList = [];

  Future<void> fetchData(String month) async {
    final startDate = DateTime(DateTime.now().year, months.indexOf(month) + 1, 1);
    final endDate = DateTime(DateTime.now().year, months.indexOf(month) + 2, 1);

    final snapshot = await FirebaseFirestore.instance
        .collection('CompletedOrders')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThan: endDate)
        .get();

    List<DailyEarnings> data = List.generate(31, (index) => DailyEarnings(day: index + 1, earnings: 0.0));

    for (var doc in snapshot.docs) {
      final dataDoc = doc.data();
      final total = (dataDoc['total'] as num).toDouble(); // Ensure 'total' is a double
      final date = (dataDoc['date'] as Timestamp).toDate();
      final day = date.day - 1;

      data[day] = DailyEarnings(day: date.day, earnings: data[day].earnings + total);
    }

    setState(() {
      seriesList = [
        charts.Series<DailyEarnings, int>(
          id: 'Earnings',
          domainFn: (DailyEarnings earnings, _) => earnings.day,
          measureFn: (DailyEarnings earnings, _) => earnings.earnings,
          data: data,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedMonth,
              hint: Text('Select Month'),
              items: months.map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonth = newValue!;
                  fetchData(selectedMonth!); // Fetch data for the selected month
                });
              },
              underline: Container(), // Removes the underline
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedMonth != null ? 'Earnings for $selectedMonth' : 'Please select a month',
                style: TextStyle(fontSize: 24),
              ),
            ),
            if (selectedMonth != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: charts.LineChart(
                    seriesList,
                    animate: true,
                    domainAxis: charts.NumericAxisSpec(
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(fontSize: 14),
                        lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.black),
                      ),
                      tickProviderSpec: charts.BasicNumericTickProviderSpec(
                        desiredTickCount: 31,
                      ),
                      tickFormatterSpec: charts.BasicNumericTickFormatterSpec((value) {
                        return value.toString();
                      }),
                    ),
                    primaryMeasureAxis: charts.NumericAxisSpec(
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(fontSize: 14),
                        lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.black),
                      ),
                      tickProviderSpec: charts.BasicNumericTickProviderSpec(
                        desiredTickCount: 6,
                      ),
                      tickFormatterSpec: charts.BasicNumericTickFormatterSpec((value) {
                        return value.toString();
                      }),
                    ),
                    defaultRenderer: charts.LineRendererConfig(
                      includePoints: true,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DailyEarnings {
  final int day;
  final double earnings;

  DailyEarnings({required this.day, required this.earnings});
}
