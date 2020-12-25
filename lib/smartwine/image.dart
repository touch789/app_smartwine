import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:image_picker_saver/image_picker_saver.dart';


enum SearchType { Google, Flickr }

class Datahelper {
  static final String _API_KEY = "c9ca501d27bd752dcdbe0bd8313b41d4";

  static Future<List<String>> loadImagesFromGoogleTask(String query) async {
    var url = Uri.encodeFull(
        "https://www.vivino.com/search/wines?q="+query);

    //https://www.google.com/search?safe=off&site=&tbm=isch&source=hp&q={q}&oq={q}&gs_l=img

    final response = await http.get(url, headers: {
      "user-agent":
      "test"
    });
    List<String> links = new List<String>();
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var elements = document.getElementsByClassName("wine-card__image");

      for (var element in elements) {
        if (element.attributes.values.elementAt(1).contains("images") ) {
          links.add((element.attributes.values.elementAt(1).replaceAll("background-image: url(//", "https://").replaceAll("pl_375x500.png)", "pb_x600.png")));
        }
      }

      return links;
    } else
      throw Exception('Failed');
  }

  static Future<bool> downloadImageFromURL(String url) async {
    try {
      // Saved with this method.
      var response = await http.get(url, headers: {
        'user-agent':
        'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.134 Safari/537.36'
      });
      print(response.statusCode.toString());
      var filePath = await ImagePickerSaver.saveFile(
          fileData: response.bodyBytes);
      print(filePath);


      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }

      // Below is a method of obtaining saved image information.

    } on PlatformException catch (error) {
      print(error);
    }
    return true;
  }


}