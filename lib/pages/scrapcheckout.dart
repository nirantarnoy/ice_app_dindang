import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/addscrapitem.dart';
import 'package:ice_app_new/models/enum_paytype.dart';
//import 'package:ice_app_new/models/paymentselected.dart';
//import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/ordersuccess.dart';
import 'package:ice_app_new/pages/prodrecsuccess.dart';
import 'package:ice_app_new/pages/scrapsuccess.dart';
//import 'package:ice_app_new/pages/payment.dart';
//import 'package:ice_app_new/pages/paymentsuccess.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:ice_app_new/providers/product.dart';
import 'package:ice_app_new/providers/user.dart';
import 'package:ice_app_new/widgets/order/order_item.dart';
//import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:barcode_widget/barcode_widget.dart' as qrCode;

class ScrapCheckoutPage extends StatefulWidget {
  static const routeName = '/scrapcheckoutpage';
  @override
  _ScrapCheckoutPageState createState() => _ScrapCheckoutPageState();
}

class _ScrapCheckoutPageState extends State<ScrapCheckoutPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  final DateFormat dateformatter = DateFormat('dd-MM-yyyy');
  final DateFormat datetimeformatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  var formatter = NumberFormat('#,##,##0');
  Paytype _paytype = Paytype.Cash;
  DateTime _date = DateTime.now();
  int _discount_amt = 0;

  //sunmi
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

// end

  @override
  void initState() {
    // TODO: implement initState
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

  Widget _buildList(List<AddscrapItem> itemlist) {
    Widget orderCards;
    if (itemlist != null) {
      if (itemlist?.isNotEmpty) {
        if (itemlist?.length > 0) {
          print("has list");
          orderCards = new ListView.builder(
              // itemCount: itemlist.length.compareTo(0),
              itemCount: itemlist?.length ?? [],
              itemBuilder: (BuildContext context, int index) {
                // total_amount =
                //     total_amount + int.parse(paymentlist[index].order_amount);

                return Dismissible(
                  key: ValueKey(itemlist[index]),
                  background: Container(
                    color: Theme.of(context).errorColor,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('แจ้งเตือน'),
                        content: Text('ต้องการลบข้อมูลใช่หรือไม่'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
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
                  },
                  onDismissed: (direction) {
                    setState(() {
                      // Provider.of<OrderData>(context, listen: false)
                      //     .removeOrderDetail(orders[index].line_id);
                      itemlist.forEach((element) {
                        if (element.product_id == itemlist[index].product_id) {
                          itemlist.removeWhere((item) =>
                              item.product_id == itemlist[index].product_id);
                        }
                      });
                      itemlist.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "ทำรายการสำเร็จ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ));
                  },
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Chip(
                            label: Text('${itemlist[index].product_code}'),
                          ),
                          title: Text(
                            "${itemlist[index].product_name}",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          // subtitle: Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: <Widget>[
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: <Widget>[
                          //         Text(
                          //           "ราคาขาย ${itemlist[index].sale_price}",
                          //           style: TextStyle(
                          //               fontSize: 12, color: Colors.cyan[700]),
                          //         ),
                          //       ],
                          //     )
                          //   ],
                          // ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "x${itemlist[index].qty}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
                // return ListTile(
                //   title: Text('${paymentlist[index].order_no}'),
                //   subtitle: Text('${paymentlist[index].order_date}'),
                //   trailing: Text('${paymentlist[index].order_amount}'),
                // );
              });
          return orderCards;
        } else {
          return Center(
            child: Text(
              "ไม่พบข้อมูล",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          );
        }
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }
    }
  }

  void _editBottomSheet(context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    TextEditingController _discountAmtTextController = TextEditingController();
    // _discountAmtTextController.text = '0';
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
                        Text(
                          "ระบุส่วนลด",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.cancel,
                                color: Colors.orange, size: 25),
                            onPressed: () => Navigator.of(context).pop())
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(2.0)),
                        Expanded(
                            child: TextField(
                          autofocus: true,
                          controller: _discountAmtTextController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: TextStyle(
                              fontSize: 40, color: Colors.deepPurple[400]),
                          onChanged: (String value) {
                            // _discountAmtTextController.text = value;
                          },
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
                              backgroundColor: Colors.blue[500],
                              elevation: 5,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                            ),
                            child: new Text('ตกลง',
                                style: new TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                _discount_amt =
                                    int.parse(_discountAmtTextController.text);
                              });
                              Navigator.of(context).pop();
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

  void _submitForm2(List<AddscrapItem> listitems) async {
    // Provider.of<OrderData>(context, listen: false)
    //     .addOrderNew(_customer_id, listitems, pay_type)
    //     .then(
    //   (_) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => OrdersuccessPage(),
    //       ),
    //     );
    //   },
    // );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
    bool issave = await Provider.of<ProductData>(context, listen: false)
        .addScrap(listitems);
    if (issave == true) {
      String prod_rec_no =
          Provider.of<ProductData>(context, listen: false).after_scrap_no;
      if (printBinded == true && prod_rec_no != '') {
        print("save prodrec success");
        printTicketFromSunmi(prod_rec_no, listitems);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScrapsuccessPage(),
        ),
      );
    }
  }

  // void _submitForm(List<PaymentreceiveData> transferdata, String car_id) {
  //   print('transferdata is ${transferdata[0].qty}');
  //   if (transferdata.isNotEmpty) {
  //     Future<bool> res = Provider.of<TransferoutData>(context, listen: false)
  //         .addTransfer(car_id, transferdata);
  //     Navigator.of(context).pop();
  //     if (res == true) {
  //       Scaffold.of(context).showSnackBar(
  //         SnackBar(
  //           content: Row(
  //             children: <Widget>[
  //               Icon(
  //                 Icons.check_circle,
  //                 color: Colors.white,
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Text(
  //                 "ทำรายการสำเร็จ",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ],
  //           ),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   }
  // }

  void printTicketFromSunmi(
      String order_no, List<AddscrapItem> order_items) async {
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
                    'ของเสีย',
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
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'เลขที่ ${order_no}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 5,
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
                  'พนักงาน.....${emp_name}.....',
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

  Widget _buildtotal(List<AddscrapItem> order_items) {
    double total_qty = 0;

    if (order_items.isNotEmpty) {
      order_items.forEach((element) {
        total_qty = total_qty + double.parse(element.qty);
      });
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
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
        ),
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    double total_amount = 0;
    double total_qty = 0;
    final payment_data = ModalRoute.of(context).settings.arguments as Map; //
    List<AddscrapItem> order_items = payment_data['orderitemlist'];
    //print('list length = ${paymentselected.length.toString()}');
    //paymentselected[0].order_amount
    // order_items.forEach((elm) {
    //   total_qty = (total_qty + double.parse(elm.qty));
    //   total_amount = (total_amount +
    //       (double.parse(elm.qty) * double.parse(elm.sale_price)));
    // });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'ยืนยันบันทึกของเสีย',
            style: TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Expanded(
              //       child: Container(
              //         color: Colors.purple,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Center(
              //             child: Text(
              //               "${order_items[0].customer_name}",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 15,
              //                   color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "รายการสินค้า",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: order_items.isNotEmpty
                      ? _buildList(order_items)
                      : Center(
                          child: Text('no'),
                        )),

              SizedBox(
                height: 5,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.green[400],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'ตกลง',
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
                        if (order_items.length <= 0) {
                          return false;
                        } else {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('ยืนยันการทำรายการ'),
                              content:
                                  Text('ต้องการบันทึกการชำระเงินใช่หรือไม่'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    //Navigator.of(context).pop(true);
                                    _submitForm2(
                                      order_items,
                                    );
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
                          // Fluttertoast.showToast(
                          //     msg: "ok",
                          //     toastLength: Toast.LENGTH_LONG,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.green,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);

                          // Navigator.of(context).pushNamed(
                          //     PaymentcheckoutPage.routeName,
                          //     arguments: {
                          //       'paymentlist': paymentselected,
                          //     });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  // void printTicketFromSunmi(
  //     String order_no, List<Addprodrec> order_items) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String emp_name = prefs.getString('emp_name');
  //   print("print after save pos");
  //   screenshotController
  //       .captureFromWidget(
  //     Container(
  //       // width: 250,
  //       // height: 280,
  //       color: Colors.white,
  //       width: 193,
  //       height: 270,
  //       child: Column(
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Expanded(
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: qrCode.BarcodeWidget(
  //                     barcode: qrCode.Barcode.qrCode(
  //                       errorCorrectLevel: qrCode.BarcodeQRCorrectionLevel.high,
  //                     ),
  //                     data: '${order_no}',
  //                     width: 50,
  //                     height: 50,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Text(
  //                   'น้ำแข็ง',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Row(
  //             children: <Widget>[
  //               Expanded(
  //                   child: Text(
  //                 'เลขที่ ${order_no}',
  //                 style: TextStyle(
  //                   fontSize: 10,
  //                   color: Colors.black,
  //                 ),
  //               )),
  //               Expanded(
  //                   child: Text(
  //                 'วันที่ ${datetimeformatter.format(DateTime.now().toLocal())}',
  //                 style: TextStyle(
  //                   fontSize: 10,
  //                   color: Colors.black,
  //                 ),
  //               ))
  //             ],
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Row(
  //             children: <Widget>[
  //               Expanded(
  //                   child: Text(
  //                 'ลูกค้า ${order_items[0].customer_name}',
  //                 style: TextStyle(
  //                   fontSize: 10,
  //                   color: Colors.black,
  //                 ),
  //               ))
  //             ],
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(2.0),
  //             child: Row(
  //               children: <Widget>[
  //                 Expanded(
  //                   flex: 3,
  //                   child: Text(
  //                     'รายการ',
  //                     style: TextStyle(
  //                       fontSize: 10,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                     flex: 1,
  //                     child: Text(
  //                       'จำนวน',
  //                       style: TextStyle(
  //                         fontSize: 10,
  //                         color: Colors.black,
  //                       ),
  //                     )),
  //                 Expanded(
  //                     flex: 1,
  //                     child: Align(
  //                       alignment: Alignment.centerRight,
  //                       child: Text(
  //                         'ราคา',
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Colors.black,
  //                         ),
  //                       ),
  //                     )),
  //                 Expanded(
  //                     flex: 1,
  //                     child: Align(
  //                       alignment: Alignment.centerRight,
  //                       child: Text(
  //                         'รวม',
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Colors.black,
  //                         ),
  //                       ),
  //                     ))
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 8,
  //           ),
  //           Expanded(
  //             child: Container(
  //               height: 50,
  //               child: _buildorderline(order_items),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(1.0),
  //             child: Row(
  //               children: <Widget>[
  //                 Expanded(
  //                   flex: 3,
  //                   child: Text(
  //                     'รวมจำนวน',
  //                     style: TextStyle(
  //                       fontSize: 10,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                     flex: 1,
  //                     child: Align(
  //                       alignment: Alignment.centerRight,
  //                       child: Text(
  //                         '0',
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black,
  //                         ),
  //                       ),
  //                     )),
  //                 Expanded(
  //                     flex: 1,
  //                     child: Align(
  //                       alignment: Alignment.centerRight,
  //                       child: Text(
  //                         '',
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           color: Colors.black,
  //                         ),
  //                       ),
  //                     )),
  //                 Expanded(
  //                     flex: 1,
  //                     child: Align(
  //                       alignment: Alignment.centerRight,
  //                       child: Text(
  //                         '${formatter.format(0)}',
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black,
  //                         ),
  //                       ),
  //                     ))
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 8,
  //           ),
  //           Row(
  //             children: <Widget>[
  //               Expanded(
  //                   child: Text(
  //                 'แคชเชียร์.....${emp_name}.....',
  //                 style: TextStyle(
  //                   fontSize: 10,
  //                   color: Colors.black,
  //                 ),
  //               ))
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //     delay: Duration(milliseconds: 30),
  //   )
  //       .then((capturedImage) async {
  //     print('byte uint8list is ${capturedImage}');
  //     await SunmiPrinter.initPrinter();
  //     await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  //     await SunmiPrinter.startTransactionPrint(true);
  //     await SunmiPrinter.printImage(capturedImage);
  //     await SunmiPrinter.lineWrap(5);
  //     await SunmiPrinter.exitTransactionPrint(true);
  //   });
  // }

  Widget _buildorderline(List<AddscrapItem> order_items) {
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
                    '${order_items[index].product_code} ${order_items[index].product_name}',
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
}
