import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'asset.dart';

class Assets with ChangeNotifier {
  List<Asset> _items = [];
  late final String? authToken;
  late final String? userId;

  Assets(this.authToken, this.userId, this._items);

  List<Asset> get items {
    return [..._items];
  }

  List<Asset> get deprecatedAssets {
    return _items.where((prodItem) => prodItem.isDeprecated).toList();
  }

  List<Asset> get nonDeprecatedAssets {
    return _items.where((prodItem) => !prodItem.isDeprecated).toList();
  }

  Asset findById(String id) {
    return _items.firstWhere((asset) => asset.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        url =
            'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/isDeprecatedAssets.json?auth=$authToken';
        final deprecatedResponse = await http.get(Uri.parse(url));
        final deprecatedData =
            json.decode(deprecatedResponse.body) as Map<String, dynamic>;

        final List<Asset> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Asset(
            id: prodId,
            assetId: prodData['Id'],
            assetName: prodData['Name'],
            assetRegisterDate: DateTime.parse(prodData['RegisterDate']),
            assetLocation: prodData['Location'],
            imageUrl: prodData['imageUrl'],
            assetStatus: deprecatedData[prodId] == null
                ? "Non Deprecated"
                : deprecatedData[prodId]['Status'],
            isDeprecated: deprecatedData[prodId] == null
                ? false
                : deprecatedData[prodId]['isDeprecated'],
          ));
        });
        _items = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Asset asset) async {
    var url =
        'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'Id': asset.assetId,
          'Name': asset.assetName,
          'RegisterDate': asset.assetRegisterDate.toString(),
          'Location': asset.assetLocation,
          'imageUrl': asset.imageUrl,
          'creatorId': userId,
        }),
      );
      final newAsset = Asset(
        assetId: asset.assetId,
        assetName: asset.assetName,
        assetRegisterDate: asset.assetRegisterDate,
        assetLocation: asset.assetLocation,
        imageUrl: asset.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newAsset);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Asset newAsset) async {
    final AssetIndex = _items.indexWhere((prod) => prod.id == id);
    if (AssetIndex >= 0) {
      final url =
          'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            'Id': newAsset.assetId,
            'Name': newAsset.assetName,
            'RegisterDate': newAsset.assetRegisterDate.toString(),
            'Location': newAsset.assetLocation,
            'imageUrl': newAsset.imageUrl,
          }));
      _items[AssetIndex] = newAsset;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deprecateAsset(String id) async {
    final url =
        'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/isDeprecatedAssets/$id.json?auth=$authToken';

    await http.put(Uri.parse(url),
        body: jsonEncode({
          'Status': 'Deprecated',
          'isDeprecated': true,
        }));
  }

  Future<void> deleteAsset(String id) async {
    var url =
        'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';

    final existingAssetIndex = _items.indexWhere((prod) => prod.id == id);
    var existingAsset = _items[existingAssetIndex];
    _items.removeAt(existingAssetIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingAssetIndex, existingAsset);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }

    url =
        'https://projectassignment-23890-default-rtdb.asia-southeast1.firebasedatabase.app/isDeprecatedAssets/$id.json?auth=$authToken';
    final responseDepre = await http.delete(Uri.parse(url));

    existingAsset = <Asset>[] as Asset;
  }
}
