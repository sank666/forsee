import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foresee_cycles/pages/home/appbar.dart';
import 'package:foresee_cycles/pages/models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  TooltipBehavior _tooltipBehavior;
  List documents;
  List<ChartData> cycle = [
    ChartData(periodLength: 27),
    ChartData(periodLength: 28)
  ];
  int avgCycleLength = 27;
  int avgPeriodLength;
  int totalPeriodLength;
  bool isLoading;

  //fetch chart data from db
  fetchData() {
    setState(() {
      isLoading = true;
    });
    var databaseReference = FirebaseFirestore.instance;
    User user = FirebaseAuth.instance.currentUser;
    //get collection
    CollectionReference collectionReference = databaseReference
        .collection('user')
        .doc(user.uid)
        .collection('period_date');
    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        documents = snapshot.docs;
        chartData = [];
        totalPeriodLength = 0;
      });
      //create list of period data
      for (int i = 0; i < documents.length; i++) {
        setState(() {
          chartData.add(ChartData(periodLength: documents[i]['period_days']));
          totalPeriodLength = totalPeriodLength + documents[i]['period_days'];
        });
      }
      print(chartData);
      var temp = totalPeriodLength.toDouble() / documents.length;

      avgPeriodLength = temp.round();
    });
    CollectionReference collectionReference2 = databaseReference
        .collection('user')
        .doc(user.uid)
        .collection('average_period');
    collectionReference2.snapshots().listen((snapshot) {
      setState(() {
        avgCycleLength = snapshot.docs[0]['cycle_lenth'];
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    fetchData();

    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Text("Loading...")
          : SingleChildScrollView(
              child: Column(
                children: [
                  customAppBar(context, "Chart"),
                  SizedBox(
                    height: 20,
                  ),
                  SfCartesianChart(
                    title: ChartTitle(text: 'Period Length'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      BarSeries<ChartData, String>(
                          name: 'Average period length = $avgPeriodLength',
                          dataSource: chartData,
                          xValueMapper: (ChartData gdp, _) =>
                              gdp.periodLength.toString(),
                          yValueMapper: (ChartData gdp, _) => gdp.periodLength,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true)
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        title: AxisTitle(text: 'Period length')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SfCartesianChart(
                    title: ChartTitle(text: 'Cycle Length'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      BarSeries<ChartData, String>(
                          name: 'Average cycle length = $avgCycleLength',
                          dataSource: cycle,
                          xValueMapper: (ChartData gdp, _) =>
                              gdp.periodLength.toString(),
                          yValueMapper: (ChartData gdp, _) => gdp.periodLength,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true)
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        title: AxisTitle(text: 'Cycle length')),
                  ),
                ],
              ),
            ),
    );
  }
}
