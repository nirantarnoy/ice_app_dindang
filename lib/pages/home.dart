import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/models/paymentdaily.dart';
import 'package:ice_app_new/models/paymentreceive.dart';
import 'package:ice_app_new/pages/checkinpage.dart';
import 'package:ice_app_new/pages/home_offline.dart';
import 'package:ice_app_new/pages/main_test.dart';
// import 'package:ice_app_new/providers/product.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:ice_app_new/providers/user.dart';
import 'package:ice_app_new/sqlite/providers/orderoffline.dart';

import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _showBackToTopButton = false;
  bool _networkisok = false;
  ScrollController _scrollController;
  BuildContext dcontext;

  Future _orderFuture;
  Future _paymentdailyFuture;
  Future _orderDiscount;

  Future _obtainOrderFuture() {
    Provider.of<OrderData>(context, listen: false).searchBycustomer = '';
    return Provider.of<OrderData>(context, listen: false).fetOrders();
  }

  Future _obtainPaymentdailyFuture() {
    return Provider.of<PaymentreceiveData>(context, listen: false)
        .fetPaymentdaily();
  }

  Future _obtainOrderDiscountFuture() {
    return Provider.of<OrderData>(context, listen: false).fetOrderDiscount();
  }

  Future _obtainCheckOrderOfflineFuture() {
    return Provider.of<OrderOfflineData>(context, listen: false).showItemlist();
  }

  @override
  void initState() {
    showempid();
    _checkinternet();
    _orderFuture = _obtainOrderFuture();
    _paymentdailyFuture = _obtainPaymentdailyFuture();
    _orderDiscount = _obtainOrderDiscountFuture();
    _obtainCheckOrderOfflineFuture();
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 20) {
            //print('offset is ${_scrollController.offset}');
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
            //print('offset is ${_scrollController.offset}');
          }
        });
      });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  Future<void> showempid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   final String token = prefs.getString('token');
    final String xxx = prefs.getString('emp_id');
    print('current emp is ${xxx}');
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      Theme.of(context).accentColor;
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

  Widget _buildclosebutton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 5,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
        ),
        child: new Text('จบการขาย',
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: () {
          return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    Icon(
                      Icons.privacy_tip_outlined,
                      size: 32,
                      color: Colors.lightGreen,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'ยืนยันการทำรายการ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'ต้องการจบการขายวันนี้ใช่หรือไม่',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  dcontext = context;
                                  return Dialog(
                                    child: Container(
                                      height: 200,
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          new CircularProgressIndicator(),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          new Text("กำลังบันทึกข้อมูล"),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              bool res = await Provider.of<OrderData>(context,
                                      listen: false)
                                  .closeOrder("1"); // จบขายคืนสต๊อก
                              print(res);
                              if (res == true) {
                                Fluttertoast.showToast(
                                    msg: "ทำรายการสำเร็จ",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Map<String, dynamic> successInformation;
                                successInformation =
                                    await Provider.of<UserData>(context,
                                            listen: false)
                                        .logout();

                                if (successInformation['success']) {
                                  print('logout success');

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckinPage()));
                                  Navigator.of(dcontext).pop();
                                  // Navigator.of(context).pop();
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "ทำรายการไม่สำเร็จ",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              Navigator.of(dcontext).pop();
                              Navigator.of(context).pop(false);
                              // Navigator.pushNamed(context, '/home');
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => MainTest()));
                            },
                            child: Text('คืนสินค้า'),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Consumer<UserData>(
                            builder: (context, _user, child) => MaterialButton(
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Container(
                                        height: 200,
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            new CircularProgressIndicator(),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            new Text("กำลังบันทึกข้อมูล"),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                bool res = await Provider.of<OrderData>(context,
                                        listen: false)
                                    .closeOrder("0"); // จบขายไม่คืนสต๊อก
                                print(res);
                                if (res == true) {
                                  Fluttertoast.showToast(
                                      msg: "ทำรายการสำเร็จ",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  if (1 > 0) {
                                    _logout(_user);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "ทำรายการไม่สำเร็จ",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                //Navigator.of(context).pop(true);
                                // Navigator.pushNamed(context, '/home');

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => MainTest()));
                              },
                              child: Text('ไม่คืนสินค้า'),
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: MaterialButton(
                            color: Colors.grey[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('ไม่ใช่'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
          // return showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: Text('ยืนยัน'),
          //     content: Text('ต้องการส่งข้อมูลการขายประจำวันใช่หรือไม่'),
          //     actions: <Widget>[
          //       ElevatedButton(
          //         onPressed: () async {
          //           bool res =
          //               await Provider.of<OrderData>(context, listen: false)
          //                   .closeOrder();
          //           print(res);
          //           if (res == true) {
          //             Fluttertoast.showToast(
          //                 msg: "ทำรายการสำเร็จ",
          //                 toastLength: Toast.LENGTH_LONG,
          //                 gravity: ToastGravity.BOTTOM,
          //                 timeInSecForIosWeb: 1,
          //                 backgroundColor: Colors.green,
          //                 textColor: Colors.white,
          //                 fontSize: 16.0);
          //           } else {
          //             Fluttertoast.showToast(
          //                 msg: "ทำรายการไม่สำเร็จ",
          //                 toastLength: Toast.LENGTH_LONG,
          //                 gravity: ToastGravity.BOTTOM,
          //                 timeInSecForIosWeb: 1,
          //                 backgroundColor: Colors.red,
          //                 textColor: Colors.white,
          //                 fontSize: 16.0);
          //           }
          //           //Navigator.of(context).pop(true);
          //           // Navigator.pushNamed(context, '/home');
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => MainTest()));
          //         },
          //         child: Text('ยืนยัน'),
          //       ),
          //       ElevatedButton(
          //         onPressed: () {
          //           Navigator.of(context).pop(false);
          //         },
          //         child: Text('ไม่'),
          //       ),
          //     ],
          //   ),
          // );
        });
  }

  void _logoutaction(Function logout) async {
    Map<String, dynamic> successInformation;
    successInformation = await logout();
    if (successInformation['success']) {
      print('logout success');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CheckinPage()));
      // Navigator.of(context).pop();
    } else {
      print("logout fail");
    }
  }

  void _logout(UserData users) {
    _logoutaction(users.logout);
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => Dialog(
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           SizedBox(
    //             height: 12,
    //           ),
    //           Icon(
    //             Icons.privacy_tip_outlined,
    //             size: 32,
    //             color: Colors.lightGreen,
    //           ),
    //           SizedBox(
    //             height: 12,
    //           ),
    //           Text(
    //             'ยืนยันการทำรายการ',
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //           ),
    //           SizedBox(
    //             height: 12,
    //           ),
    //           Text(
    //             'ต้องการออกจากระบบใช่หรือไม่',
    //             style: TextStyle(fontWeight: FontWeight.normal),
    //           ),
    //           SizedBox(
    //             height: 12,
    //           ),
    //           Row(
    //             children: <Widget>[
    //               Expanded(
    //                 child: MaterialButton(
    //                   color: Colors.lightGreen,
    //                   shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(50)),
    //                   onPressed: () => _logoutaction(users.logout),
    //                   child: Text('ใช่'),
    //                 ),
    //               ),
    //               Spacer(),
    //               Expanded(
    //                 child: MaterialButton(
    //                   color: Colors.grey[400],
    //                   shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(50)),
    //                   onPressed: () {
    //                     Navigator.of(context).pop(false);
    //                   },
    //                   child: Text('ไม่ใช่'),
    //                 ),
    //               ),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0.#');
    DateFormat dateformatter = DateFormat('dd-MM-yyyy');
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: _networkisok == true
            ? Container(
                //  color: Theme.of(context).accentColor,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.grey[50],
                      Colors.blue,
                    ],
                  ),
                ),
                //  color: Colors.lightBlue,
                child: FutureBuilder(
                    future: _orderFuture,
                    builder: (context, dataSnapshort) {
                      if (dataSnapshort.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      } else {
                        if (dataSnapshort.error != null) {
                          return Center(
                            child: Text('Data is error'),
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      "สรุปรายการขาย",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      'ข้อมูลวันที่ ${dateformatter.format(DateTime.now())}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'ขายสด',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            //Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DottedLine(
                                                direction: Axis.horizontal,
                                                lineLength: double.infinity,
                                                lineThickness: 1.0,
                                                dashLength: 4.0,
                                                dashColor: Colors.grey,
                                                dashRadius: 0.0,
                                                dashGapLength: 4.0,
                                                dashGapColor:
                                                    Colors.transparent,
                                                dashGapRadius: 0.0,
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Consumer<OrderData>(
                                                    builder:
                                                        (context, orders, _) =>
                                                            Column(
                                                      children: <Widget>[
                                                        Text('จำนวน'),
                                                        Text(
                                                          '${formatter.format(orders.cashTotalQty)}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        VerticalDivider(
                                                          width: 2.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Consumer<OrderData>(
                                                    builder:
                                                        (context, orders, _) =>
                                                            Column(
                                                      children: <Widget>[
                                                        Text('ยอดขาย'),
                                                        Text(
                                                          '${formatter.format(orders.cashTotalAmount)}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //  SizedBox(height: 2),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black,
                                  //color: Colors.transparent,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'ขายเชื่อ',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DottedLine(
                                              direction: Axis.horizontal,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashLength: 4.0,
                                              dashColor: Colors.grey,
                                              dashRadius: 0.0,
                                              dashGapLength: 4.0,
                                              dashGapColor: Colors.transparent,
                                              dashGapRadius: 0.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Consumer<OrderData>(
                                                  builder:
                                                      (context, orders, _) =>
                                                          Column(
                                                    children: <Widget>[
                                                      Text('จำนวน'),
                                                      Text(
                                                        '${formatter.format(orders.creditTotalQty)}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Consumer<OrderData>(
                                                  builder:
                                                      (context, orders, _) =>
                                                          Column(
                                                    children: <Widget>[
                                                      Text('ยอดขาย'),
                                                      Text(
                                                        '${formatter.format(orders.creditTotalAmount)}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //  SizedBox(height: 2),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'รวมขายทั้งหมด',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DottedLine(
                                              direction: Axis.horizontal,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashLength: 4.0,
                                              dashColor: Colors.grey,
                                              dashRadius: 0.0,
                                              dashGapLength: 4.0,
                                              dashGapColor: Colors.transparent,
                                              dashGapRadius: 0.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Consumer<OrderData>(
                                                  builder:
                                                      (context, orders, _) =>
                                                          Column(
                                                    children: [
                                                      Text('ยอดขายรวม'),
                                                      Text(
                                                        '${formatter.format(orders.creditTotalAmount + orders.cashTotalAmount)}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black,
                                  color: Colors.lightGreen[300],
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'รับชำระหนี้',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DottedLine(
                                              direction: Axis.horizontal,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashLength: 4.0,
                                              dashColor: Colors.grey,
                                              dashRadius: 0.0,
                                              dashGapLength: 4.0,
                                              dashGapColor: Colors.transparent,
                                              dashGapRadius: 0.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Consumer<
                                                    PaymentreceiveData>(
                                                  builder: (context,
                                                          _paymentdaily, _) =>
                                                      Column(
                                                    children: [
                                                      Text('รวมเงิน'),
                                                      Text(
                                                        '${formatter.format(_paymentdaily.orderStatus > 0 ? 0 : _paymentdaily.totalPayment)}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black,
                                  color: Colors.lightBlue[200],
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'ส่วนลด',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DottedLine(
                                              direction: Axis.horizontal,
                                              lineLength: double.infinity,
                                              lineThickness: 1.0,
                                              dashLength: 4.0,
                                              dashColor: Colors.grey,
                                              dashRadius: 0.0,
                                              dashGapLength: 4.0,
                                              dashGapColor: Colors.transparent,
                                              dashGapRadius: 0.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Consumer<OrderData>(
                                                  builder: (context,
                                                          _order_discount, _) =>
                                                      Column(
                                                    children: [
                                                      Text('รวมเงิน'),
                                                      Text(
                                                        '${formatter.format((_order_discount.sumcashdiscount + _order_discount.sumcreditdiscount))}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Consumer<OrderOfflineData>(
                                builder: (context, _orderoffline, _) =>
                                    _orderoffline.listorderoffline.length > 0
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 35.0, 10.0, 0.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                                elevation: 5,
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .circular(
                                                                10.0)),
                                              ),
                                              child: Text(
                                                'ส่งมอบขาย OFFLINE',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeOfflinePage())),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 35.0, 10.0, 0.0),
                                            child: SizedBox(
                                              height: 50.0,
                                              //   width: targetWidth,
                                              child: Consumer<OrderData>(
                                                builder: (context, orders, _) =>
                                                    orders.listorder.length > 0
                                                        ? _buildclosebutton()
                                                        : Text(''),
                                              ),
                                            ),
                                          ),
                              ),

                              SizedBox(height: 25),
                            ],
                          );
                        }
                      }
                    }),
              )
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
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
    ));
  }
}
