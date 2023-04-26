import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_assg/screens/new_screen.dart';
import 'package:intl/intl.dart';
import '../providers/assets.dart';
import 'package:provider/provider.dart';

class AssetList extends StatefulWidget {
  const AssetList({Key? key}) : super(key: key);

  @override
  State<AssetList> createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final assetsData = Provider.of<Assets>(context);
    final assets = assetsData.nonDeprecatedAssets;
    final scaffold = Scaffold.of(context);

    print(assetsData.items.length);

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
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(NewScreen.routeName,
                                arguments: assets[i].id);
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await Provider.of<Assets>(context, listen: false)
                                  .deprecateAsset(assets[i].id);
                              setState(() {
                                assets[i].isDeprecated =
                                    !assets[i].isDeprecated;
                              });
                            } catch (error) {
                              scaffold.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Deleting failed..!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                          color: Theme.of(context).errorColor,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_expanded)
                  SizedBox(
                    height:
                        min(assets[i].assetLocation.length * 20.0 + 10, 100),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ' +
                                  DateFormat.yMd()
                                      .format(assets[i].assetRegisterDate),
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Location: ' + assets[i].assetLocation,
                              maxLines: 10,
                              style: TextStyle(fontSize: 18),
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
        child: Text('Empty Lists'),
      );
    }
  }
}
