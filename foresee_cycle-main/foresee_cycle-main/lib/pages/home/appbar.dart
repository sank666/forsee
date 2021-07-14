import 'package:flutter/material.dart';
import 'package:foresee_cycles/utils/styles.dart';

Container customAppBar(BuildContext  context, String title) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          SizedBox(height: 35,),
          Text(
            title,
            style: TextStyle(
              color: CustomColors.primaryColor,
              fontSize: 26,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    ),
    width: MediaQuery.of(context).size.width,
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
      
    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 1)]
    ),
  );
}