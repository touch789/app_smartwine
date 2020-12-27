
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';





class myBottle {
  String num;
  String title;
  String description;
  String designation;
  String country;
  String province;
  String region;
  String variety;
  String winery;
  String tempService;
  String tempCons;

  myBottle({this.num, this.title, this.variety,this.description,this.designation,this.winery,this.country,this.region,this.province,this.tempService,this.tempCons});

  factory myBottle.fromJson(Map<String, dynamic> json) {
    return myBottle(
      num: json['num'] as String,
      title: json['title'] as String,
      variety: json['variety'] as String,
      description: json['description'] as String,
      designation: json['designation'] as String,
      winery: json['winery'] as String,
      country: json['country'] as String,
      region: json['region'] as String,
      province: json['province'] as String,
      tempService: json['TempService'] as String,
      tempCons: json['TempCons'] as String,


    );
  }
}