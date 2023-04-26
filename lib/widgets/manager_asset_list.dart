import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/assets.dart';
import 'package:provider/provider.dart';

class ManagerAssetList extends StatefulWidget {
  const ManagerAssetList({Key? key}) : super(key: key);

  @override
  State<ManagerAssetList> createState() => _ManagerAssetListState();
}

class _ManagerAssetListState extends State<ManagerAssetList> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final assetsData = Provider.of<Assets>(context);
    final assets = assetsData.deprecatedAssets;

    if (assets.isNotEmpty) {
      return SingleChildScrollView(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: assets.length,
          itemBuilder: (_, i) => Card(
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
                    icon: Icon(Icons.delete),
                    onPressed: () => Provider.of<Assets>(context, listen: false)
                        .deleteAsset(assets[i].id),
                    color: Theme.of(context).errorColor,
                  ),
                ),
                if (_expanded)
                  SizedBox(
                    height:
                        min(assets[i].assetLocation.length * 20.0 + 10, 100),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
      );
    } else {
      return const Center(
        child: Text('No Deprecated Assets'),
      );
    }
  }
}
