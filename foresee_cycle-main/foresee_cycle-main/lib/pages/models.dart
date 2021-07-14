import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String name;
  String mbNo;
  String email;
  int periodDays;
  int age;
  int height;
  int weight;
  UserData(
      {this.name,
      this.mbNo,
      this.email,
      this.periodDays,
      this.age,
      this.height,
      this.weight});
}

UserData userdata = new UserData(
    name: 'Julianne Hough',
    mbNo: '+91 9061 157 246',
    email: 'juliannehough29@gmail.com',
    periodDays: 4);

class DatabaseService {
  //collection reference
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');
  Future updateUserData(
      String name, int age, int height, int weight, String phone) async {
    return await user.doc(uid).set({
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'phone': phone,
    });
  }
}

class ChartData {
  int periodLength;
  ChartData({this.periodLength});
  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        periodLength: json["period_days"],
      );
}

List<ChartData> chartData = [];
