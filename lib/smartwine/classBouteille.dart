
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';





class Employee {
  String id;
  String firstName;
  String lastName;

  Employee({this.id, this.firstName, this.lastName});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['num'] as String,
      firstName: json['title'] as String,
      lastName: json['variety'] as String,
    );
  }
}