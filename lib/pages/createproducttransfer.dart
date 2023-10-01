import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/models/addprodrec.dart';
import 'package:ice_app_new/models/deliveryroute.dart';
//import 'package:ice_app_new/models/car.dart';
import 'package:ice_app_new/pages/ordercheckout.dart';
import 'package:ice_app_new/pages/productionrec.dart';
import 'package:ice_app_new/pages/productrec_checkout.dart';
import 'package:ice_app_new/pages/producttransfercheckout.dart';
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
import 'package:ice_app_new/providers/product.dart';

// import 'package:ice_app_new/models/customers.dart';
// import 'package:ice_app_new/widgets/sale/sale_product_item.dart';
// import 'package:ice_app_new/providers/customer.dart';
// import 'package:ice_app_new/providers/order.dart';

import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/products.dart';
//import 'package:ice_app_new/models/issueitems.dart';

class CreateProductTransferPage extends StatefulWidget {
  static const routeName = '/CreateProductTransferPage';
  @override
  _CreateProductTransferPageState createState() =>
      _CreateProductTransferPageState();
}

class _CreateProductTransferPageState extends State<CreateProductTransferPage> {
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  String selectedValueName;
  int isuserconfirm = 0;
  List<Addprodrec> orderItems = [];

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

  void _editBottomSheet(
    context,
    String name,
    String onhand,
    String product_id,
    String price,
    String product_name,
    String product_code,
    String price_group_id,
  ) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    final TextEditingController _saleqtyTextController =
        TextEditingController();
    // _saleqtyTextController.text = '0';
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              //  height: MediaQuery.of(context).size.height * 0.9,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // Icon(
                        //   Icons.check,
                        //   color: Colors.green,
                        // ),
                        Text("รายการละเอียดสินค้า"),
                        SizedBox(width: 10),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.cancel,
                                color: Colors.orange, size: 25),
                            onPressed: () => Navigator.of(context).pop())
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[400],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Row(children: <Widget>[
                            Text(
                              "${name}",
                              style: TextStyle(
                                  color: Colors.purple[900],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(2.0)),
                        Expanded(
                            child: TextField(
                          autofocus: true,
                          controller: _saleqtyTextController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(
                              fontSize: 40, color: Colors.deepPurple[400]),
                          onChanged: (String value) {},
                        )),
                      ],
                    ),
                    SizedBox(height: 10),
                    // SizedBox(height: 90),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                      child: SizedBox(
                        height: 55.0,
                        width: targetWidth,
                        child: new ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              elevation: 5,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                            ),
                            child: new Text('เพิ่มรายการ',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              print(
                                  'enter value is ${_typeAheadController.text}');
                              if (num.tryParse(_saleqtyTextController.text)
                                      .toDouble() >
                                  0) {
                                orderItems.forEach((element) {
                                  orderItems.removeWhere((item) =>
                                      item.product_id == product_id &&
                                      item.qty == _saleqtyTextController.text);
                                });

                                final Addprodrec order_item = new Addprodrec(
                                  product_id: product_id,
                                  product_code: product_code,
                                  product_name: product_name,
                                  qty: _saleqtyTextController.text,
                                );
                                setState(() {
                                  orderItems.add(order_item);
                                });
                                Fluttertoast.showToast(
                                    msg: "เพิ่มรายการแล้ว",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                Navigator.pop(context);
                              } else {}
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildproductList(List<Products> products) {
    Widget productCards;

    if (products != null) {
      if (products.length > 0) {
        // print("has product item list");
        productCards = new GridView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            //   physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 1),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Card(
                  child: Hero(
                    tag: "${products[index].id}",
                    child: Material(
                      color: Colors.lightGreen[300],
                      child: InkWell(
                        onTap: () {
                          // String _avl = Provider.of<IssueData>(context, listen: false)
                          //     .listissue
                          //     .firstWhere((value) => value.product_id == _id)
                          //     .avl_qty;
                          String _avl = products[index].onhand;

                          _editBottomSheet(
                            context,
                            products[index].name,
                            products[index].onhand,
                            products[index].id,
                            products[index].sale_price,
                            products[index].name,
                            products[index].code,
                            products[index].price_group_id,
                          );
                        },
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image.asset("assets/ice_cube.png"),
                                  // Icon(
                                  //   Icons.image_rounded,
                                  //   color: Colors.deepPurple,
                                  // ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "${products[index].name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
            'รับโอนสินค้า',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () => Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => ProductionRecPage())),
          //       icon: Icon(Icons.list_alt)),
          // ],
        ),
        body: Container(
          //body: SaleProductItem(),
          padding: EdgeInsets.only(left: 1, right: 1, top: 0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "รายการสินค้า",
                style: TextStyle(color: Colors.grey[600], fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Consumer<ProductData>(
                  builder: (context, products, _) =>
                      _buildproductList(products.listproductall),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
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
                                        'รายการ ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '${formatter.format(orderItems.length)}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
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
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: orderItems.length > 0
                              ? Colors.green[700]
                              : Colors.green[100],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  'ถัดไป',
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
                          if (orderItems.length <= 0) {
                            return false;
                          } else {
                            Navigator.of(context).pushNamed(
                                ProducttransfercheckoutPage.routeName,
                                arguments: {
                                  'orderitemlist': orderItems,
                                });
                          }
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
