import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_assg/providers/auth.dart';
import '../widgets/staff_asset_list.dart';
import 'package:group_assg/widgets/staff_asset_list.dart';
import 'package:provider/provider.dart';
import '../providers/assets.dart';
import '../screens/homepage.dart';

class StaffScreen extends StatefulWidget {
  static const routeName = '/StaffScreen';

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  var _showOnlyDeprecated = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Assets>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Staff List",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          iconSize: 40,
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.routeName, arguments: '');
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Assets>(
              builder: (ctx, productsData, _) => Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Switch.adaptive(
                        activeColor: Color.fromARGB(255, 0, 0, 255),
                        value: _showOnlyDeprecated,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyDeprecated = value;
                          });
                        },
                      ),
                      StaffAssetList(_showOnlyDeprecated),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
