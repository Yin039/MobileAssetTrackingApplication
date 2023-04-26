import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/asset.dart';
import '../providers/assets.dart';
import '../screens/homepage.dart';

class NewScreen extends StatefulWidget {
  static const routeName = '/NewPage';

  const NewScreen({Key? key}) : super(key: key);

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  String? value;
  final _assetIdFocusNode = FocusNode();
  final _assetNameFocusNode = FocusNode();
  final _assetRegisterDateFocusNode = FocusNode();
  late DateTime _selectedDate = DateTime.now();
  final _assetLocationFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedAsset = Asset(
    id: '',
    assetId: 'A-1',
    assetName: '',
    assetRegisterDate: DateTime.now(),
    assetLocation: '',
    imageUrl: '',
  );

  var _initValues = {
    'id': '',
    'name': '',
    'registerdate': '',
    'location': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final assetId = ModalRoute.of(context)!.settings.arguments as String;
      if (assetId != '') {
        _editedAsset =
            Provider.of<Assets>(context, listen: false).findById(assetId);
        _initValues = {
          'id': _editedAsset.assetId.toString(),
          'name': _editedAsset.assetName,
          'registerdate': _selectedDate.toString(),
          'location': _editedAsset.assetLocation,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedAsset.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _assetIdFocusNode.dispose();
    _assetNameFocusNode.dispose();
    _assetRegisterDateFocusNode.dispose();
    _assetLocationFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });

    print('passing..!');
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedAsset.id != '') {
      await Provider.of<Assets>(context, listen: false)
          .updateProduct(_editedAsset.id, _editedAsset);
    } else {
      try {
        await Provider.of<Assets>(context, listen: false)
            .addProduct(_editedAsset);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final assetsData = Provider.of<Assets>(context, listen: false);
    var count = assetsData.items.length + 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _editedAsset.id != ''
            ? const Text(
                'Edit Asset',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                ),
              )
            : const Text(
                'New Asset',
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
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        color: Color.fromARGB(255, 0, 0, 255),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100))),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: _initValues['name'],
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            hintText: "Name of new assets",
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 255))),
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: _assetNameFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_assetRegisterDateFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the name of asset.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedAsset = Asset(
                              id: _editedAsset.id,
                              assetId: "A-$count",
                              assetName: value!,
                              assetRegisterDate: _selectedDate,
                              assetLocation: _editedAsset.assetLocation,
                              imageUrl: _editedAsset.imageUrl,
                              assetStatus: _editedAsset.assetStatus,
                              isDeprecated: _editedAsset.isDeprecated,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: _initValues['location'],
                          decoration: InputDecoration(
                            labelText: 'Location',
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            hintText: "Location of new asset",
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 255))),
                          ),
                          maxLines: 2,
                          focusNode: _assetLocationFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_assetLocationFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a location.';
                            }
                            if (value.length < 15) {
                              return 'Please enter the full address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedAsset = Asset(
                              id: _editedAsset.id,
                              assetId: "A-$count",
                              assetName: _editedAsset.assetName,
                              assetRegisterDate: _selectedDate,
                              assetLocation: value!,
                              imageUrl: _editedAsset.imageUrl,
                              assetStatus: _editedAsset.assetStatus,
                              isDeprecated: _editedAsset.isDeprecated,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                top: 8,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: const Color.fromARGB(255, 0, 0, 255),
                                ),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Center(
                                      child: Text('URL',
                                          style: TextStyle(fontSize: 18)))
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an image URL.';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid image URL.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedAsset = Asset(
                                    id: _editedAsset.id,
                                    assetId: "A-$count",
                                    assetName: _editedAsset.assetName,
                                    assetRegisterDate: _selectedDate,
                                    assetLocation: _editedAsset.assetLocation,
                                    imageUrl: value!,
                                    assetStatus: _editedAsset.assetStatus,
                                    isDeprecated: _editedAsset.isDeprecated,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Picked Date: ${DateFormat("yyyy-MM-dd").format(_selectedDate)}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            FlatButton(
                              onPressed: _presentDatePicker,
                              child: Text('Choose Date',
                                  style: TextStyle(fontSize: 18)),
                              color: const Color.fromARGB(255, 0, 0, 255),
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: RaisedButton(
                              color: const Color.fromARGB(255, 0, 0, 255),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              textColor: Colors.white,
                              child: const Text("Add",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24)),
                              onPressed: () => {
                                    _saveForm(),
                                  }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
