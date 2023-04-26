import 'package:flutter/material.dart';
import 'package:group_assg/widgets/manager_asset_list.dart';
import '../widgets/asset_list.dart';
import '../screens/homepage.dart';
import '../providers/assets.dart';
import 'package:provider/provider.dart';

class ManagerScreen extends StatelessWidget {
  static const routeName = '/ManagerScreen';

  Future<void> _refreshProducts(BuildContext context) async {
    return await Provider.of<Assets>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Deprecated List",
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Assets>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ManagerAssetList(),
                      ),
                    ),
                  ),
      ),
    );
  }
}
