import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/auth.dart';
import '../providers/assets.dart';
import 'package:provider/provider.dart';

class StaffAssetList extends StatefulWidget {
  bool showIsDepre;

  StaffAssetList(this.showIsDepre);

  @override
  State<StaffAssetList> createState() => _StaffAssetListState();
}

class _StaffAssetListState extends State<StaffAssetList> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final assetsData = Provider.of<Assets>(context);
    final assets =
        widget.showIsDepre ? assetsData.deprecatedAssets : assetsData.items;
    final authData = Provider.of<Auth>(context, listen: false);

    if (assets.isNotEmpty) {
      return Expanded(
        child: SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: assets.length,
            itemBuilder: (_, i) => ChangeNotifierProvider.value(
              value: assets[i],
              child: Card(
                elevation: 2,
                shadowColor: Color.fromARGB(255, 0, 0, 255),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Id: ' '${assets[i].assetId}'),
                      subtitle: Text('Name: ' + assets[i].assetName),
                      onTap: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(assets[i].imageUrl)),
                      trailing: IconButton(
                        icon: Icon(
                          assets[i].isDeprecated
                              ? Icons.delete
                              : Icons.delete_outline,
                        ),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          setState(() {
                            assets[i].isDeprecated = !assets[i].isDeprecated;
                            print(assets[i].isDeprecated);

                            assets[i].toggleDeprecatedStatus(
                                authData.token.toString(),
                                assets[i].isDeprecated);
                          });
                        },
                      ),
                    ),
                    if (_expanded)
                      SizedBox(
                        height: min(
                            assets[i].assetLocation.length * 20.0 + 10, 100),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ' +
                                            DateFormat.yMd().format(
                                                assets[i].assetRegisterDate),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        'Location: ' + assets[i].assetLocation,
                                        maxLines: 10,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text('No Deprecated Assets'),
      );
    }
  }
}
