import 'dart:ffi';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ice_app_new/models/balanceinlist.dart';
import 'package:ice_app_new/models/paymentdaily.dart';
import 'package:ice_app_new/models/paymentreceive.dart';
import 'package:ice_app_new/pages/checkinpage.dart';
import 'package:ice_app_new/pages/home_offline.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/providers/product.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/providers/dailysum.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:ice_app_new/providers/user.dart';
import 'package:ice_app_new/sqlite/providers/orderoffline.dart';

import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:barcode_widget/barcode_widget.dart' as qrCode;

class HomePosPage extends StatefulWidget {
  static const routeName = '/homepos';
  final int is_printslip;
  const HomePosPage({
    Key key,
    @required this.is_printslip,
  }) : super(key: key);
  @override
  _HomePosPageState createState() => _HomePosPageState();
}

class _HomePosPageState extends State<HomePosPage>
    with TickerProviderStateMixin {
  bool _showBackToTopButton = false;
  bool _networkisok = false;
  ScrollController _scrollController;

  BuildContext dcontext;
  bool isclosepos_daily = false;

  final ScreenshotController screenshotController = ScreenshotController();
  final ScreenshotController screenshotController2 = ScreenshotController();
  final ScreenshotController screenshotController3 = ScreenshotController();
  final ScreenshotController screenshotController4 = ScreenshotController();
  final ScreenshotController screenshotController5 = ScreenshotController();
  final ScreenshotController screenshotController6 = ScreenshotController();
  final ScreenshotController screenshotController7 = ScreenshotController();
  final ScreenshotController screenshotController8 = ScreenshotController();
  final ScreenshotController screenshotController9 = ScreenshotController();

  List<BalanceinList> _balanceinlist = [];
  List<BalanceinList> _prodreclist = [];
  List<BalanceinList> _transferlist = [];
  List<BalanceinList> _repacklist = [];
  List<BalanceinList> _reprocesslist = [];
  List<BalanceinList> _refilllist = [];
  List<BalanceinList> _cashqtylist = [];
  List<BalanceinList> _creditqtylist = [];
  List<BalanceinList> _scraplist = [];
  List<BalanceinList> _countlist = [];

  Future _balanceinFuture;
  Future _prodrecFuture;
  Future _scrapFuture;
  Future _countingFuture;
  Future _cashQtyFuture;
  Future _creditQtyFuture;
  Future _orderFuture;
  Future _paymentdailyFuture;
  Future _orderDiscount;

  //sunmi
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

// end

  Future _obtainOrderFuture() {
    Provider.of<OrderData>(context, listen: false).searchBycustomer = '';
    return Provider.of<OrderData>(context, listen: false).fetPosOrders();
  }

  Future _obtainBalanceInFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetBalancein();
  }

  Future _obtainProdrecFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetProdrec();
  }

  Future _obtainScrapFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetScrap();
  }

  Future _obtainCountingFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetCounting();
  }

  Future _obtainCalcloseShiftFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetCalcloseshift();
  }

  Future _obtainCashQtyFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetCashQty();
  }

  Future _obtainCreditQtyFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetCreditQty();
  }

  Future _obtainTransferQtyFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetTransferQty();
  }

  Future _obtainRepackQtyFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetRepackQty();
  }

  Future _obtainReProcesscarQtyFuture() {
    return Provider.of<DailysumData>(context, listen: false)
        .fetReprocesscarQty();
  }

  Future _obtainRefillQtyFuture() {
    return Provider.of<DailysumData>(context, listen: false).fetRefillQty();
  }

  Future _obtainPaymentdailyFuture() {
    return Provider.of<PaymentreceiveData>(context, listen: false)
        .fetPaymentdaily();
  }

  Future _obtainPaymentPosdailyFuture() {
    return Provider.of<PaymentreceiveData>(context, listen: false)
        .fetPaymentPosdaily();
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
    _balanceinFuture = _obtainBalanceInFuture();
    _prodrecFuture = _obtainProdrecFuture();
    _scrapFuture = _obtainScrapFuture();
    _countingFuture = _obtainCountingFuture();
    _cashQtyFuture = _obtainCashQtyFuture();
    _creditQtyFuture = _obtainCreditQtyFuture();
    //  _obtainCalcloseShiftFuture();
    _obtainTransferQtyFuture();
    _obtainRepackQtyFuture();
    _obtainReProcesscarQtyFuture();
    _obtainRefillQtyFuture();
    _obtainPaymentPosdailyFuture();
    _obtainCheckOrderOfflineFuture();

    // BalanceinList xlistitem = new BalanceinList(
    //     product_code: 'xx', product_name: 'xxxfdfdfdfd', qty: '20');
    // xlist.add(xlistitem);

    // List<BalanceinList> _prodreclist = [];
    // List<BalanceinList> _transferlist = [];
    // List<BalanceinList> _repacklist = [];
    // List<BalanceinList> _reprocesslist = [];
    // List<BalanceinList> _refilllist = [];
    // List<BalanceinList> _cashqtylist = [];
    // List<BalanceinList> _creditqtylist = [];
    // List<BalanceinList> _scraplist = [];
    // List<BalanceinList> _countlist = [];

    _balanceinlist =
        Provider.of<DailysumData>(context, listen: false).listbalancein;
    _prodreclist =
        Provider.of<DailysumData>(context, listen: false).listprodrec;
    _transferlist =
        Provider.of<DailysumData>(context, listen: false).listtransferqty;
    _repacklist =
        Provider.of<DailysumData>(context, listen: false).listrepackqty;
    _reprocesslist =
        Provider.of<DailysumData>(context, listen: false).listreprocesscarqty;
    _refilllist =
        Provider.of<DailysumData>(context, listen: false).listrefillqty;
    _cashqtylist =
        Provider.of<DailysumData>(context, listen: false).listcashqty;
    _creditqtylist =
        Provider.of<DailysumData>(context, listen: false).listcreditqty;

    _scraplist = Provider.of<DailysumData>(context, listen: false).listscrap;

    _countlist = Provider.of<DailysumData>(context, listen: false).listcounting;

    isclosepos_daily =
        Provider.of<OrderData>(context, listen: false).checkdailyclose;
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
              builder: (context) {
                dcontext = context;
                return Dialog(
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                                  bool res = await Provider.of<OrderData>(
                                          context,
                                          listen: false)
                                      .closeOrderPos("1"); // จบขายคืนสต๊อก
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

                                    bool successInformation;
                                    successInformation =
                                        await Provider.of<UserData>(context,
                                                listen: false)
                                            .logoutpos();
                                    print("close success");
                                    if (successInformation == true) {
                                      print('logout success');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckinPage()));
                                      Navigator.of(dcontext).pop();
                                      // Navigator.of(context).pop();
                                    }

                                    // Map<String, dynamic> successInformation;
                                    // successInformation =
                                    //     await Provider.of<UserData>(context,
                                    //             listen: false)
                                    //         .logoutpos();
                                    // print("close success");
                                    // if (successInformation['success']) {
                                    //   print('logout success');

                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               CheckinPage()));
                                    //   Navigator.of(dcontext).pop();
                                    //   // Navigator.of(context).pop();
                                    // }
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
                                  Navigator.of(context).pop(true);
                                  // Navigator.pushNamed(context, '/home');
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => MainTest()));
                                },
                                child: Text('ตกลง'),
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
                );
              });
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

  Widget _build_balance_daily_print(List<BalanceinList> _listitem) {
    Widget _widget;
    if (_listitem.isNotEmpty && isclosepos_daily == false) {
      _widget = new ListView.builder(
          itemCount: _listitem.length,
          itemBuilder: (BuildContext contex, index) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text('${_listitem[index].product_name}',
                          style: TextStyle(color: Colors.black, fontSize: 11)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('${_listitem[index].qty}',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 11))),
                    ),
                  ),
                ],
              ),
            );
          });
      return _widget;
    } else {
      return Center(
        child: Text('No Data'),
      );
    }
  }

  Widget _build_balance_daily_print2(List<BalanceinList> _listitem) {
    Widget _widget;
    if (_listitem.isNotEmpty && isclosepos_daily == false) {
      _widget = new ListView.builder(
          itemCount: _listitem.length,
          itemBuilder: (BuildContext contex, index) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text('${_listitem[index].product_name}',
                          style: TextStyle(color: Colors.black, fontSize: 11)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('${_listitem[index].qty}',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 11))),
                    ),
                  ),
                ],
              ),
            );
          });
      return _widget;
    } else {
      return Center(
        child: Text('No Data'),
      );
    }
  }

  Widget _build_prodrec_daily(List<BalanceinList> _listitem) {
    Widget _widget;
    if (_listitem.isNotEmpty && isclosepos_daily == false) {
      _widget = new ListView.builder(
          itemCount: _listitem.length,
          itemBuilder: (BuildContext contex, index) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_listitem[index].product_name}',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('${_listitem[index].qty}',
                              style: TextStyle(color: Colors.black))),
                    ),
                  ),
                ],
              ),
            );
          });
      return _widget;
    } else {
      return Center(
        child: Text('No Data'),
      );
    }
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
                      Colors.green,
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
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        bool res =
                                            await _obtainCalcloseShiftFuture();
                                        if (res == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MainTest(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: 30,
                                        child: Center(child: Text('คำนวณ')),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          //printTicketFromSunmiBalanceIn();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: 30,
                                          child: Center(child: Text('พิมพ์')),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      "สรุปรายการขาย POS",
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
                                              'รวมขายสด',
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
                                                        orders.checkdailyclose ==
                                                                false
                                                            ? Text(
                                                                '${formatter.format(orders.cashTotalQty)}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        30,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text('0',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        30,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
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
                                                        orders.checkdailyclose ==
                                                                false
                                                            ? Text(
                                                                '${formatter.format(orders.cashTotalAmount)}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        30,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text('0',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        30,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
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
                                            'รวมขายเชื่อ',
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
                                                      orders.checkdailyclose ==
                                                              false
                                                          ? Text(
                                                              '${formatter.format(orders.creditTotalQty)}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              '0',
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
                                              Expanded(
                                                child: Consumer<OrderData>(
                                                  builder:
                                                      (context, orders, _) =>
                                                          Column(
                                                    children: <Widget>[
                                                      Text('ยอดขาย'),
                                                      orders.checkdailyclose ==
                                                              false
                                                          ? Text(
                                                              '${formatter.format(orders.creditTotalAmount)}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              '0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
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
                                                      orders.checkdailyclose ==
                                                              false
                                                          ? Text(
                                                              '${formatter.format(orders.creditTotalAmount + orders.cashTotalAmount)}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              '0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
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
                                                      isclosepos_daily == false
                                                          ? Text(
                                                              '${formatter.format(_paymentdaily.orderStatus > 0 ? 0 : _paymentdaily.totalPayment)}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text('0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
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
                                                      _order_discount
                                                                  .checkdailyclose ==
                                                              false
                                                          ? Text(
                                                              '${formatter.format((_order_discount.sumcashdiscount + _order_discount.sumcreditdiscount))}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text('0',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
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
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'ยอดยกมา',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listbalancein.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listbalancein
                                                            .length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum
                                                            .listbalancein),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiBalanceIn();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'ผลิต',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listprodrec.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listprodrec.length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum.listprodrec),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiProdrec();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'โอนรถ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listtransferqty.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listtransferqty
                                                            .length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum
                                                            .listtransferqty),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiTransfer();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'แปรสภาพ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listrepackqty.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listrepackqty
                                                            .length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum
                                                            .listrepackqty),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiRepack();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'แปรสภาพรถ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listreprocesscarqty
                                                    .isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listreprocesscarqty
                                                            .length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum
                                                            .listreprocesscarqty),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiReprocess();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'เบิกเติม',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listrefillqty.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listrefillqty
                                                            .length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum
                                                            .listrefillqty),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiRefill();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'ขายสด',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listcashqty.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listcashqty.length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum.listcashqty),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiCashqty();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'ขายเชื่อ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listcreditqty.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listcreditqty
                                                            .length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum
                                                            .listcreditqty),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiCreditqty();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'ของเสีย',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listscrap.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listscrap.length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum.listscrap),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiScrap();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width - 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'นับจริง',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'รายการ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<DailysumData>(
                                        builder: (context, _dailysum, _) =>
                                            _dailysum.listcounting.isNotEmpty
                                                ? Container(
                                                    width: double.infinity,
                                                    height: _dailysum
                                                            .listcounting.length
                                                            .toDouble() *
                                                        35,
                                                    child: _build_prodrec_daily(
                                                        _dailysum.listcounting),
                                                  )
                                                : Text('')),
                                    ElevatedButton(
                                      onPressed: () {
                                        printTicketFromSunmiCount();
                                      },
                                      child: Text('พิมพ์'),
                                    ),
                                  ],
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
                                                    orders.checkdailyclose ==
                                                            false
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

  /////   print area ///////////////////

  void printTicketFromSunmiBalanceIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
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
            SizedBox(
              height: 15,
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'ยอดยกมา',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print(_balanceinlist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiProdrec() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'ผลิต',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_prodreclist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiTransfer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'โอนรถ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_transferlist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiRepack() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'แปรสภาพ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_repacklist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiReprocess() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'แปรสภาพรถ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_reprocesslist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiRefill() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'เบิกเติม',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_refilllist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiCashqty() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'ขายสด',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_cashqtylist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiCreditqty() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'ขายเชื่อ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_creditqtylist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiScrap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'ของเสีย',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_scraplist),
            ),
            SizedBox(
              height: 5,
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

  void printTicketFromSunmiCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    print("print after save pos");
    DateFormat dateformatter2 = DateFormat('dd-MM-yyyy HH:mm:ss');
    double paper_height = 380;
    // if (order_items.length == 1) {
    //   paper_height = 230;
    // }
    // if (order_items.length == 2) {
    //   paper_height = 245;
    // }
    // if (order_items.length == 3) {
    //   paper_height = 260;
    // }
    // if (order_items.length == 4) {
    //   paper_height = 275;
    // }
    screenshotController2
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: paper_height,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "สรุปรายการขาย POS",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'ข้อมูลวันที่ ${dateformatter2.format(DateTime.now())}',
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'นับจริง',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'จำนวน',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: _build_balance_daily_print2(_countlist),
            ),
            SizedBox(
              height: 5,
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
}
