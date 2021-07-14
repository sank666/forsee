import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foresee_cycles/pages/home/appbar.dart';
import 'package:foresee_cycles/pages/home/period_track.dart';
import 'package:foresee_cycles/pages/models.dart';
import 'package:foresee_cycles/utils/styles.dart';

class Notes extends StatefulWidget {
  final String mlResponse;
  Notes({this.mlResponse});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  var mlResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          customAppBar(context, "Notes"),
          GestureDetector(
            onTap: (() => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PeriodTracker()))),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: size.width,
              height: size.width * 0.2,
              // color: Colors.green,
              child: Row(
                children: [
                  Text(
                    'Period days',
                    style: TextStyle(
                      fontSize: 22,
                      color: CustomColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
