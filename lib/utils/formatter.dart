import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimeStamp(Timestamp timestamp) {
  DateTime data = timestamp.toDate();

  String year = data.year.toString();
  String month = data.month.toString();
  String day = data.day.toString();

  return '$day/$month/$year';
}
