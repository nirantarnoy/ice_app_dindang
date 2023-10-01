import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/models/countitemlist.dart';
import 'package:ice_app_new/models/products.dart';
import 'package:ice_app_new/page_offline/createorder_new_offline.dart';
//import 'package:ice_app_new/pages/createorder.dart';
import 'package:ice_app_new/pages/createorder_new.dart';
import 'package:ice_app_new/pages/createorder_new_pos.dart';
import 'package:ice_app_new/pages/createtransform.dart';
import 'package:ice_app_new/pages/dailycountsuccess.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/providers/product.dart';
//import 'package:ice_app_new/widgets/order/order_item.dart';
import 'package:ice_app_new/widgets/order/order_item_new.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ice_app_new/widgets/order/order_item_new_pos.dart';
import 'package:ice_app_new/widgets/product/producttransform_item.dart';
import 'package:ice_app_new/widgets/productionrec/_production_rec_item.dart';

//import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/order.dart';

import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:barcode_widget/barcode_widget.dart' as qrCode;
//import 'package:ice_app_new/widgets/error/err_api.dart';

class DailycountPage extends StatefulWidget {
  static const routeName = '/dailycount';
  @override
  _DailycountPageState createState() => _DailycountPageState();
}

class _DailycountPageState extends State<DailycountPage>
    with TickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;

  final ScreenshotController screenshotController = ScreenshotController();
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
  final DateFormat datetimeformatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  var formatter = NumberFormat('#,##,##0');
  DateTime _date = DateTime.now();
  int _discount_amt = 0;

  bool _networkisok = false;

  bool _showBackToTopButton = false;
  ScrollController _scrollController;

  List<TextEditingController> _controllers = [];
  List<CountitemList> _countitemlist = [];

  //sunmi
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

  Future _orderFuture;

  Future _obtainOrderFuture() {
    //Provider.of<OrderData>(context, listen: false).searchBycustomer = '';
    return Provider.of<ProductData>(context, listen: false).fetProductAll();
  }

  @override
  initState() {
    _checkinternet();

    _orderFuture = _obtainOrderFuture();
    // _scrollController = ScrollController()
    //   ..addListener(() {
    //     setState(() {
    //       if (_scrollController.offset >= 400) {
    //         print('offset is ${_scrollController.offset}');
    //         _showBackToTopButton = true;
    //       } else {
    //         _showBackToTopButton = false;
    //         print('offset is ${_scrollController.offset}');
    //       }
    //     });
    //   });
    // setState(() {
    //   _isLoading = true;
    // });
    // Future.delayed(Duration.zero).then((_) async {
    //   await Provider.of<OrderData>(context, listen: false)
    //       .fetOrders()
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // });
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }
    // Provider.of<OrderData>(context).fetOrders();
    super.initState();
    _bindingPrinter().then((bool isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind;
      });
    });
  }

  /// must binding ur printer at first init in app
  Future<bool> _bindingPrinter() async {
    final bool result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  void didChangeDependencies() {
    print('order didCangeDependencies');
    // if (_isInit) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  void refreshData() {
    setState(() {
      _orderFuture = _obtainOrderFuture();
    });
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      setState(() {
        _networkisok = false;
      });
      _showdialog('พบปัญหา', 'กรุณาตรวจสอบการเชื่อมต่อ หรือ ใช้งานโหมดออฟไลน์');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
      setState(() {
        _networkisok = true;
      });
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
      setState(() {
        _networkisok = true;
      });
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
                  child: Text('ตกลง'))
            ],
          );
        });
  }

  Widget _buidorderlist() {
    List<Products> products =
        Provider.of<ProductData>(context, listen: false).listproductall;
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
                        '${products[index].name}',
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
                        key: Key(products[index].id),
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
                          _controllers[index].text = value;
                          _controllers[index].selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _controllers[index].text.length));
                          _addtolist(_controllers[index].text,
                              products[index].id, products[index].name);
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

  void _addtolist(String val, String product_id, String product_name) {
    if (_countitemlist.isNotEmpty) {
      print('list is not empty na ja');
      _countitemlist.forEach((element) {
        if (element.product_id == product_id) {
          print("element = ${element.product_id}");
          print("product object = ${product_id}");
          setState(() {
            //element.qty = val;
            _countitemlist
                .removeWhere((element) => element.product_id == product_id);
            CountitemList _xlist = CountitemList(
              product_id: product_id,
              product_name: product_name,
              qty: val,
            );
            _countitemlist.add(_xlist);
          });

          // _countitemlist.removeWhere((element) =>
          //     element.product_id == products[index].id);
          // CountitemList _xlist = CountitemList(
          //   product_id: products[index].id,
          //   product_name: products[index].name,
          //   qty: value,
          // );
          // _countitemlist.add(_xlist);
        } else {
          print("not equal");
          CountitemList _xlist = new CountitemList(
            product_id: product_id,
            product_name: product_name,
            qty: val,
          );
          setState(() {
            _countitemlist.add(_xlist);
          });
        }
      });
      // _countitemlist
      //     .removeWhere((element) => element.qty == '' || element.qty == 0);
    } else {
      print('list is empty na ja');
      CountitemList _xlist = new CountitemList(
        product_id: product_id,
        product_name: product_name,
        qty: val,
      );
      setState(() {
        _countitemlist.add(_xlist);
        print("list lenght is ${_countitemlist.length}");
      });
    }
    print("list lenght is ${_countitemlist.length}");
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
                  .addDailycount(_countitemlist);

              if (res == true) {
                String order_no_pos =
                    Provider.of<ProductData>(context, listen: false)
                        .count_no_after_save;
                print("save pos ok na");
                if (printBinded == true && order_no_pos != '') {
                  //if (printBinded == true) {
                  print("save pos success");
                  printTicketFromSunmi(order_no_pos, _countitemlist);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DailycountsuccessPage()));
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

  void printTicketFromSunmi(
      String order_no, List<CountitemList> order_items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    double paper_height = 0;
    if (order_items.length == 1) {
      paper_height = 230;
    }
    if (order_items.length == 2) {
      paper_height = 245;
    }
    if (order_items.length == 3) {
      paper_height = 260;
    }
    if (order_items.length == 4) {
      paper_height = 275;
    }
    screenshotController
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: qrCode.BarcodeWidget(
                      barcode: qrCode.Barcode.qrCode(
                        errorCorrectLevel: qrCode.BarcodeQRCorrectionLevel.high,
                      ),
                      data: '${order_no}',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'นับสต๊อก',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'วันที่ ${datetimeformatter.format(DateTime.now().toLocal())}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //         child: Text(
            //       'เลขที่ ${order_no}',
            //       style: TextStyle(
            //         fontSize: 10,
            //         color: Colors.black,
            //       ),
            //     )),
            //   ],
            // ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'รายการ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'จำนวน',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Container(
                height: 50,
                child: _buildorderline(order_items),
              ),
            ),

            _buildtotal(order_items),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'แคชเชียร์.....${emp_name}.....',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
      delay: Duration(milliseconds: 30),
    )
        .then((capturedImage) async {
      print('byte uint8list is ${capturedImage}');
      await SunmiPrinter.initPrinter();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.printImage(capturedImage);
      await SunmiPrinter.lineWrap(5);
      await SunmiPrinter.exitTransactionPrint(true);
    });
  }

  Widget _buildtotal(List<CountitemList> order_items) {
    double total_qty = 0;

    if (order_items.isNotEmpty) {
      order_items.forEach((element) {
        total_qty = total_qty + double.parse(element.qty);
      });
      return Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              'รวมจำนวน',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${formatter.format(total_qty)}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ))
        ],
      );
    } else {
      return Text('');
    }
  }

  Widget _buildorderline(List<CountitemList> order_items) {
    // double total_qty = 0;
    // double total_amt = 0;
    Widget _items;
    if (order_items.isNotEmpty) {
      print("has order line pos");
      _items = new ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: order_items.length,
          itemBuilder: (BuildContext context, int index) {
            // total_qty = total_qty + double.parse(order_items[index].qty);
            // total_amt = total_amt +
            //     (double.parse(order_items[index].qty) *
            //         double.parse(order_items[index].sale_price));
            // return Text(
            //   "niran",
            //   style: TextStyle(
            //     color: Colors.black,
            //   ),
            // );
            return Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text(
                    '${order_items[index].product_name}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${order_items[index].qty}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    )),
              ],
            );
          });
      return _items;
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('build context created');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'นับจริง',
            style: TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(MainTest());
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _networkisok == true
                  ? _buidorderlist()
                  : Column(
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                        ),
                        Icon(
                          Icons.wifi_off_outlined,
                          size: 100,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(child: Text('ไม่พบสัญญาณอินเตอร์เน็ต'))
                      ],
                    ),
            ),
            Container(
              child: GestureDetector(
                child: Container(
                  color: _countitemlist.length > 0
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
        floatingActionButton: _showBackToTopButton == false
            ? null
            : FloatingActionButton(
                onPressed: _scrollToTop,
                child: Icon(Icons.arrow_upward),
              ),
      ),
    );
  }
}
