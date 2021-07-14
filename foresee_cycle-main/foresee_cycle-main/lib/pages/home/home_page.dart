import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart' as prefix;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:foresee_cycles/pages/home/edit_profile.dart';
import 'package:foresee_cycles/pages/models.dart';
import 'package:foresee_cycles/utils/constant_data.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;
import 'package:intl/intl.dart';
import 'package:foresee_cycles/pages/auth/login.dart';
import 'package:foresee_cycles/pages/home/appbar.dart';
import 'package:foresee_cycles/pages/home/chat_widget.dart';
import 'package:foresee_cycles/pages/home/note_widget.dart';
import 'package:foresee_cycles/utils/styles.dart';
// import 'package:cloud_firestore/cloud_firestore.dart ';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool isCalender = false,
    isChat = false,
    isHome = true,
    isProfile = false,
    isNote = false;
int periodDays = userdata.periodDays;
DateTime _currentDate;
Timestamp _startTimeStamp;
List<DateTime> dates;
// DateTime _endDate;

FirebaseFirestore firestore = FirebaseFirestore.instance;
EventList<Event> _markedDates;
AsyncSnapshot<QuerySnapshot> streamSnapshot;
User user = FirebaseAuth.instance.currentUser;

class _HomeScreenState extends State<HomeScreen> {
  List documents;
  var mlResponse;
  //get user details
  getData() {
    DocumentReference collectionReference =
        FirebaseFirestore.instance.collection('user').doc(user.uid);

    collectionReference.snapshots().listen((event) {
      setState(() {
        userdata.name = event.data()['name'];
        userdata.mbNo = event.data()['phone'].toString();
        userdata.age = event.data()['age'];
        userdata.height = event.data()['height'];
        userdata.weight = event.data()['weight'];
        userdata.email = user.email;
      });
    });
  }

  //GET USER period dates
  fetchData() async {
    var databaseReference = FirebaseFirestore.instance;

    CollectionReference collectionReference = databaseReference
        .collection('user')
        .doc(user.uid)
        .collection('period_date');

    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        documents = snapshot.docs;
      });
    });
    print(documents);
    _markedDates = EventList<Event>(events: {});
    for (int i = 0; i < documents.length; i++) {
      dates = [];
      _startTimeStamp = documents[i]['start_date'];
      var periodDayss = documents[i]['period_days'];
      DateTime _startDate = DateTime.parse(_startTimeStamp.toDate().toString());
      print(periodDayss);
      dates.add(_startDate);
      //making list of period dates
      for (int j = 1; j < periodDayss; j++) {
        _startDate = _startDate.add(Duration(days: 1));
        dates.add(_startDate);
        print(_startDate);
      }
      //add events to calender
      for (int j = 0; j < dates.length; j++) {
        _markedDates.add(
            dates[j],
            new Event(
                date: dates[j],
                title: "Period",
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColors.primaryColor,
                  ),
                  child: Center(
                    child: Text(dates[j].day.toString()),
                  ),
                )));
      }
    }
  }

  //prediction
  predict() async {
    getData();
    var bmi = userdata.weight / ((userdata.height * userdata.height) / 10000);
    var data = {
      "age": userdata.age,
      "weight": userdata.weight,
      "height": userdata.height,
      "bmi": bmi
    };
    print(data);
    print(userdata.age);
    var url = Uri.parse('https://predict-ml.herokuapp.com/predict');
    await http
        .post(url,
            headers: {
              "Content-Type": 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data))
        .then((response) {
      print(response.statusCode);
      print(response.body);
      //store response from ml
      mlResponse = response.body;
    });
  }

  getAlldata() async {
    await getData();
    predict();
    fetchData();
  }

  //function is called when page loads
  @override
  void initState() {
    getAlldata();
    getData();
    fetchData();
    // predict();
    // FirebaseAuth.instance.signOut();
    _markedDates = EventList<Event>(events: {});
    dates = [];

    super.initState();
  }

  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: firestore
              .collection('user')
              .doc(user.uid)
              .collection('period_date')
              .snapshots(),
          builder: (BuildContext context, streamSnapshot) {
            if (count == 1) {
              getAlldata();
              count++;
            }

            return streamSnapshot.hasData
                ? MyHomeBody(
                    DateTime.parse(documents[documents.length - 1]['start_date']
                        .toDate()
                        .toString()),
                    mlResponse,
                    documents)
                : Text('Loading...');
          }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        height: 70,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4],
              colors: [
                Color(0xFFf48988),
                Color(0xFFef6786),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 20, color: Colors.grey[400], spreadRadius: 1)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isCalender = true;
                    isChat = false;
                    isHome = false;
                    isProfile = false;
                    isNote = false;
                  });
                },
                child:
                    buildContainerBottomNav(Icons.calendar_today, isCalender),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isCalender = false;
                    isChat = true;
                    isHome = false;
                    isProfile = false;
                    isNote = false;
                  });
                },
                child: buildContainerBottomNav(Icons.bar_chart, isChat),
              ),
              InkWell(
                onTap: () {
                  getAlldata();
                  setState(() {
                    isCalender = false;
                    isChat = false;
                    isHome = true;
                    isProfile = false;
                    isNote = false;
                  });
                },
                child: buildContainerBottomNav(Icons.home, isHome),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isCalender = false;
                    isChat = false;
                    isHome = false;
                    isProfile = false;
                    isNote = true;
                  });
                },
                child: buildContainerBottomNav(Icons.note_add, isNote),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isCalender = false;
                    isChat = false;
                    isHome = false;
                    isProfile = true;
                    isNote = false;
                  });
                },
                child: buildContainerBottomNav(Icons.person, isProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomeBody extends StatefulWidget {
  final DateTime lastPeriod;
  final String mlResponse;
  List documents;
  MyHomeBody(this.lastPeriod, this.mlResponse, this.documents);

  @override
  _MyHomeBodyState createState() => _MyHomeBodyState();
}

class _MyHomeBodyState extends State<MyHomeBody> {
  Container homeWidget(BuildContext context) {
    return Container(
      child: Column(
        children: [
          customAppBar(context, "Home"),
          homeBodyWidget(context, widget.mlResponse, widget.documents),
        ],
      ),
    );
  }

  String formattedDate;
  String nextDate;
  final today = DateTime.now();
  int difference;

  Expanded homeBodyWidget(
      BuildContext context, String mlResponse, List documents) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: InkWell(
                splashColor: Colors.white,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.3),
                onTap: () {
                  setState(() {
                    isCalender = true;
                    isChat = false;
                    isHome = false;
                    isProfile = false;
                    isNote = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 0.7],
                      colors: [
                        Color(0xFFfbceac),
                        Color(0xFFf48988),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Last Period",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "$difference days ago",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Next Period",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          nextDate,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          mlResponse == '1' && documents.length > 1
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'You might have Polycystic ovary syndrome (PCOS), consider consulting a doctor',
                    style: TextStyle(
                      fontSize: 22,
                      color: CustomColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Container calenderWidget(BuildContext context) {
    return Container(
      child: Column(
        children: [
          customAppBar(context, "Calendar"),
          calenderBodyWidget(context)
        ],
      ),
    );
  }

  calenderBodyWidget(BuildContext context) {
    return
        // StreamBuilder(
        CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List events) {
        this.setState(() => _currentDate = date);
        // firestore
        //     .collection('period_date')
        //     .doc('date')
        //     .update({'start_date': _currentDate});
      },
      weekendTextStyle: TextStyle(
        color: CustomColors.primaryColor,
      ),
      markedDatesMap: _markedDates,
      markedDateShowIcon: true,
      markedDateIconBuilder: ((event) => event.icon),
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null,
      thisMonthDayBorderColor: Colors.white,
      weekFormat: false,
      height: MediaQuery.of(context).size.height * 0.6,
      selectedDateTime: _currentDate,
      selectedDayButtonColor: Colors.white,
      selectedDayTextStyle: TextStyle(color: Colors.black),
      daysHaveCircularBorder: true,
      isScrollable: false,
      todayButtonColor: Colors.blueAccent,
    );
  }

  var avgCycleLength = 28;
  Container profileWidget(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: CustomColors.secondaryColor,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Profile',
                      style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile())),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                            color: CustomColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 110,
          left: 14,
          right: 14,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Card(
                elevation: 3,
                semanticContainer: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * 0.085,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(ConstantsData.userImage))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userdata.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userdata.mbNo,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userdata.email,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 14,
              right: 14),
          child: Card(
            elevation: 3,
            semanticContainer: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: ListView(
              padding: EdgeInsets.only(top: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          size: 22,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Account Settings',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                              fontSize: 15),
                        ),
                        Expanded(child: SizedBox()),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).disabledColor,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Divider(
                  indent: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.language,
                          size: 22,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Select your Language',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                              fontSize: 15),
                        ),
                        Expanded(child: SizedBox()),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).disabledColor,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Divider(
                  indent: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: InkWell(
                    onTap: () async {
                      print("logout");
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                          size: 26,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Logout',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                              fontSize: 15),
                        ),
                        Expanded(child: SizedBox()),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).disabledColor,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Divider(
                  indent: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  //set dates of last period and next period for display
  setDate() {
    formattedDate = DateFormat('MMM dd').format(widget.lastPeriod);
    difference = today.difference(widget.lastPeriod).inDays;
    nextDate = DateFormat('MMM dd')
        .format(widget.lastPeriod.add(Duration(days: avgCycleLength)));
  }

  @override
  void initState() {
    setDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setDate();
    return isCalender
        ?
        // SizedBox()
        calenderWidget(context)
        : isChat
            ? Chart()
            : isHome
                ? homeWidget(context)
                : isNote
                    ? Notes(mlResponse: widget.mlResponse)
                    : profileWidget(context);
  }
}

Container buildContainerBottomNav(IconData icon, bool isSelected) {
  return Container(
    decoration: BoxDecoration(
      color: isSelected ? Colors.white : null,
      shape: BoxShape.circle,
      boxShadow: isSelected
          ? [BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 1)]
          : [],
    ),
    height: 50,
    width: 50,
    child: Icon(icon,
        color: isSelected ? CustomColors.primaryColor : Colors.white),
  );
}
