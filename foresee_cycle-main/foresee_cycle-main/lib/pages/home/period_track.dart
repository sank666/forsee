import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foresee_cycles/pages/home/appbar.dart';
import 'package:foresee_cycles/utils/styles.dart';
import 'package:intl/intl.dart';

class PeriodTracker extends StatefulWidget {
  @override
  _PeriodTrackerState createState() => _PeriodTrackerState();
}

class _PeriodTrackerState extends State<PeriodTracker> {
  DateTime selectedDate;
  int periodLength = 0;
  List documents;
  int avgPeriodLength = 4;
  int avgCycleLength = 27;
  AsyncSnapshot<QuerySnapshot> streamSnapshot;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String formattedDate;

  //date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('MMM dd').format(selectedDate);
      });
  }

  //adding date document to database
  addData(DateTime date, int range) {
    Map<String, dynamic> data = {'period_days': range, 'start_date': date};
    var databaseReference = FirebaseFirestore.instance;
    User user = FirebaseAuth.instance.currentUser;
    databaseReference
        .collection('user')
        .doc(user.uid)
        .collection('period_date')
        .add(data);
    // CollectionReference collectionReference =
    //     FirebaseFirestore.instance.collection('period_date');
    // collectionReference.add(data);
  }

  // fetch date document from db
  fetchData() {
    var databaseReference = FirebaseFirestore.instance;
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = databaseReference
        .collection('user')
        .doc(user.uid)
        .collection('period_date');
    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        documents = snapshot.docs;
      });
    });
    CollectionReference collectionReference2 = databaseReference
        .collection('user')
        .doc(user.uid)
        .collection('average_period');
    collectionReference2.snapshots().listen((snapshot) {
      setState(() {
        avgCycleLength = snapshot.docs[0]['cycle_lenth'];
        avgPeriodLength = snapshot.docs[0]['period_length'];
      });
    });
  }

  //show toast notification
  void showSnackbar(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 1.0],
          colors: [
            Color(0xFFffebbb),
            Color(0xFFfbceac),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: size * 0.125,
          child: customAppBar(context, 'Periods'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: size.width,
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: size.width * 0.075,
                        ),
                        Text(
                          'Add period',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: size.width * 0.4,
                            child: Center(
                              child: Text(
                                'Select Date',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.4,
                            child: Center(
                              child: Container(
                                width: size.width * 0.25,
                                child: TextButton(
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            size * 0.05),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            CustomColors.primaryColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side:
                                                BorderSide(color: Colors.red))),
                                  ),
                                  onPressed: () {
                                    return _selectDate(context);
                                  },
                                  child: Text(
                                    selectedDate == null
                                        ? 'Select date'
                                        : formattedDate,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: size.width * 0.4,
                            child: Center(
                              child: Text(
                                'Period Length',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    if (periodLength != 0) periodLength--;
                                  }),
                                  child: Container(
                                    width: size.width * 0.05,
                                    child: Icon(
                                      Icons.remove,
                                      size: size.width * 0.05,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$periodLength',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    periodLength++;
                                    print(periodLength);
                                  }),
                                  child: Container(
                                    width: size.width * 0.05,
                                    child: Icon(
                                      Icons.add,
                                      size: size.width * 0.05,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                      Container(
                        width: size.width * 0.2,
                        child: TextButton(
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all<Size>(size * 0.05),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                CustomColors.primaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red))),
                          ),
                          onPressed: () {
                            if (selectedDate != null && periodLength != 0) {
                              addData(selectedDate, periodLength);
                              fetchData();
                              showSnackbar('Period added successfully');
                            } else {
                              showSnackbar('Please select date and length');
                            }
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.05,
                ),
                Container(
                  width: size.width,
                  height: size.width * 0.25,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Average Value',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.4,
                            child: Text(
                              '• Period Length:',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            '$avgPeriodLength days',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.4,
                            child: Text(
                              '• Cycle Length:',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            '$avgCycleLength days',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.05,
                ),
                Container(
                  width: size.width,
                  height: size.width * 0.14,
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Last periods',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                    width: size.width,
                    height: size.width * 0.2 * documents.length,
                    child: ListView.separated(
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: size.width,
                          height: size.width * 0.15,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.4,
                                    child: Text(
                                      'Period date:',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                documents[index]['start_date']
                                                    .microsecondsSinceEpoch))
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.4,
                                    child: Text(
                                      'Period Length:',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${documents[index]['period_days']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.white,
                          height: size.width * 0.05,
                        );
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
