import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/models/addissuedata.dart';
import 'package:ice_app_new/models/deliveryroute.dart';
import 'package:ice_app_new/models/productissuebp.dart';
import 'package:ice_app_new/models/transfromlist.dart';
//import 'package:ice_app_new/models/car.dart';
import 'package:ice_app_new/pages/ordercheckout.dart';
import 'package:ice_app_new/pages/productissuecheckout.dart';
import 'package:ice_app_new/pages/transformsuccess.dart';
import 'package:ice_app_new/providers/deliveryroute.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:ice_app_new/providers/product.dart';
import 'package:ice_app_new/sqlite/providers/db_provider.dart';
//import 'package:ice_app_new/widgets/order/order_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/providers/deliveryroute.dart';

// import 'package:ice_app_new/models/customers.dart';
// import 'package:ice_app_new/widgets/sale/sale_product_item.dart';
// import 'package:ice_app_new/providers/customer.dart';
// import 'package:ice_app_new/providers/order.dart';

import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/products.dart';
//import 'package:ice_app_new/models/issueitems.dart';

class CreateTransformPage extends StatefulWidget {
  static const routeName = '/createtransform';
  @override
  _CreateTransformPageState createState() => _CreateTransformPageState();
}

class _CreateTransformPageState extends State<CreateTransformPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _onhand_qty = TextEditingController();
  TextEditingController _issue_qty = TextEditingController();
  List<TextEditingController> _controllers = [];

  final Map<String, dynamic> _formData = {
    'onhand_qty': null,
    'issue_qty': null,
  };

  String selectedValue;
  String selectedValueName;
  int isuserconfirm = 0;
  List<Transformlist> _transformlist = [];

  var _isInit = true;
  var _isLoading = false;
  @override
  initState() {
    _checkinternet();
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    Provider.of<ProductData>(context, listen: false).fetProductAll();
    _onhand_qty.text = "0";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (_isInit) {
    //   Provider.of<CustomerData>(context, listen: false)
    //       .fetCustomers()
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;

    //       // print('issue id is ${selectedIssue}');
    //     });
    //   });

    //   // setState(() {
    //   //   _isLoading = true;

    //   // });

    //   // Provider.of<ProductData>(context, listen: false)
    //   //     .fetProducts("")
    //   //     .then((_) {
    //   //   setState(() {
    //   //     _isLoading = false;
    //   //   });
    //   // });
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i <= _controllers.length - 1; i++) {
      _controllers[i].dispose();
    }
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog(
          'No intenet', 'กรุณาตรวจสอบการเชื่อมต่อ หรือ ใช้งานโหมดออฟไลน์');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
    }
  }

  _showdialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  Widget _buildOnhandTextField() {
    return TextField(
      enabled: false,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      obscureText: false,
      controller: _onhand_qty,
    );
  }

  Widget _buildIssueQtyTextField() {
    return TextField(
      textAlign: TextAlign.center,
      controller: _issue_qty,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      obscureText: false,
      onChanged: (value) {
        if (double.parse(value) > double.parse(_onhand_qty.text)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('แจ้งเตือน'),
              content: Text(
                'จำนวนเบิกมากกว่ายอดคงเหลือ',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _issue_qty.text = '0';
                    Navigator.of(context).pop(false);
                  },
                  child: Text('ตกลง'),
                ),
              ],
            ),
          );
        } else {
          setState(() {
            _issue_qty.text = value.toString();
            _issue_qty.selection = TextSelection.fromPosition(
                TextPosition(offset: _issue_qty.text.length));
          });
        }
      },
    );
  }

  Widget _buildproductList(List<Transformlist> products) {
    Widget productCards;

    if (products != null) {
      if (products.length > 0) {
        // print("has product item list");
        productCards = new ListView.builder(
            // primary: false,
            //  shrinkWrap: true,
            //  physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              _controllers.add(new TextEditingController());
              // _controllers[index].text = "0";
              return Card(
                shadowColor: Colors.white,
                color: Color.fromARGB(255, 168, 213, 221),
                child: Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${products[index].to_product_name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            _controllers[index].text = value;
                            _controllers[index].selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _controllers[index].text.length));
                            if (_transformlist.isNotEmpty) {
                              _transformlist.forEach((element) {
                                if (element.to_product_id ==
                                    products[index].to_product_id) {
                                  element.to_qty = value;
                                }
                              });
                              _transformlist.removeWhere((element) =>
                                  element.to_qty == '' || element.to_qty == 0);
                            } else {
                              Transformlist _xlist = Transformlist(
                                to_product_id: products[index].to_product_id,
                                to_product_name:
                                    products[index].to_product_name,
                                to_qty: value,
                              );
                              _transformlist.add(_xlist);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ]),
              );
            });

        return productCards;
      } else {
        return Container(
          child: Center(
            child: Text(
              'ไม่พบข้อมูล',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        );
      }
    } else {
      return Container(
        child: Center(
          child: Text('ไม่พบข้อมูล'),
        ),
      );
    }
  }

  void _submitform() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('แจ้งเตือน'),
        content: Text('ต้องการบันทึกข้อมูลใช่หรือไม่'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              bool res = await Provider.of<ProductData>(context, listen: false)
                  .addTransform(selectedValue, _issue_qty.text, _transformlist);

              if (res == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransformsuccessPage()));
              }
              //print('data transform is ${_transformlist}');
            },
            child: Text('ยืนยัน'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('ไม่'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //customers.fetCustomers();
    //  IssueData issuedata = Provider.of<IssueData>(context, listen: false);
    // issuedata.fetIssueitems();
    // print('creatd order new');
    var formatter = NumberFormat('#,##,##0');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'แปรสภาพสินค้า',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          //body: SaleProductItem(),
          padding: EdgeInsets.only(left: 1, right: 1, top: 0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Card(
                shadowColor: Colors.transparent,
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Text(
                        //   "ยอดขาย",
                        //   style: TextStyle(fontSize: 20, color: Colors.black87),
                        // ),
                        // SizedBox(width: 5),
                        // Chip(
                        //   label: Text(
                        //     "${formatter.format(orders.totalAmount)}",
                        //     style: TextStyle(color: Colors.white, fontSize: 20),
                        //   ),
                        //   backgroundColor: Theme.of(context).primaryColor,
                        // ),
                        // Text("บาท",
                        //     style: TextStyle(fontSize: 20, color: Colors.black87)),
                        Expanded(
                          child: Consumer<ProductData>(
                            builder: (context, _productdata, _) =>
                                TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _typeAheadController,
                                autofocus: false,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontStyle: FontStyle.normal),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'ค้นหาสินค้า'),
                              ),
                              // suggestionsCallback: (pattern) async {
                              //   return await BackendService.getSuggestions(pattern);
                              // },
                              suggestionsCallback: (pattern) async {
                                return await _productdata
                                    .findProductAll(pattern); // online
                                // return await DbHelper.instance
                                //     .findCustomer(pattern); // offline
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  // leading: Icon(Icons.shopping_cart),
                                  title: Text(suggestion.name),
                                  // subtitle: Text('\$${suggestion['price']}'),
                                );
                              },

                              onSuggestionSelected: (items) {
                                setState(() {
                                  selectedValue = items.id.toString();
                                  selectedValueName = items.name;

                                  IssueData issuedata = Provider.of<IssueData>(
                                      context,
                                      listen: false);

                                  Provider.of<ProductData>(context,
                                          listen: false)
                                      .fetProductToTransformList(selectedValue);
                                  _onhand_qty.text = Provider.of<ProductData>(
                                          context,
                                          listen: false)
                                      .getProductOnhand(selectedValue)
                                      .toString();
                                  this._typeAheadController.text = items.name;
                                });
                              },
                              noItemsFoundBuilder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'ไม่พบข้อมูล',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            elevation: 0.2,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedValue = '';
                              selectedValue = '';
                              selectedValueName = '';

                              Provider.of<ProductData>(context, listen: false)
                                  .fetProductToTransformList(selectedValue);

                              _issue_qty.text = '0';
                              _onhand_qty.text = '0';

                              this._typeAheadController.text = '';
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.refresh_rounded,
                              size: 45,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(children: [
                      Text('คงเหลือ'),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                '${_onhand_qty.text}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      Text('ยอดเบิก'),
                      _buildIssueQtyTextField(),
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "แปรเป็นสินค้า",
                style: TextStyle(color: Colors.grey[600], fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Consumer<ProductData>(
                builder: (context, products, _) =>
                    _buildproductList(products.listtransformlist),
              )),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _transformlist.clear();
                            _controllers.clear();
                            Provider.of<ProductData>(context, listen: false)
                                .fetProductToTransformList(selectedValue);
                          });
                        },
                        child: Container(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Consumer<PaymentreceiveData>(
                                    builder: (context, totals, _) => Row(
                                      children: <Widget>[
                                        Text(
                                          'เคลียร์ข้อมูล ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: _transformlist.length > 0
                              ? Colors.green[700]
                              : Colors.green[100],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  'บันทึกรายการ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          _submitform();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
