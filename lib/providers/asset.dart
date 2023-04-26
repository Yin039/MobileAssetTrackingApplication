import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Asset with ChangeNotifier {
  final String id;
  final String assetId;
  final String assetName;
  final DateTime assetRegisterDate;
  final String assetLocation;
  final String imageUrl;
  String assetStatus;
  bool isDeprecated;

  Asset({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.assetRegisterDate,
    required this.assetLocation,
    required this.imageUrl,
    this.assetStatus = 'Non Deprecated',
    this.isDeprecated = false,
  });

  String get assetCount {
    return assetId;
  }

  void _setDepreValue(bool newValue) {
    isDeprecated = newValue;
    notifyListeners();
  }

  Future<void> toggleDeprecatedStatus(String authToken, bool oldStatus) async {
    final url =
        'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/isDeprecatedAssets/$id.json?auth=$authToken';

    if (oldStatus == true) {
      try {
        final response = await http.put(Uri.parse(url),
            body: jsonEncode({
              'Status': 'Deprecated',
              'isDeprecated': true,
            }));

        if (response.statusCode >= 400) {
          _setDepreValue(oldStatus);
        }
      } catch (error) {
        _setDepreValue(oldStatus);
      }
    } else {
      try {
        final response = await http.put(Uri.parse(url),
            body: jsonEncode({
              'Status': 'Non Deprecated',
              'isDeprecated': false,
            }));

        if (response.statusCode >= 400) {
          _setDepreValue(oldStatus);
        }
      } catch (error) {
        _setDepreValue(oldStatus);
      }
    }
  }
}
