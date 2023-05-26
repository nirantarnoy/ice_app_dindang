import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_app_new/models/addorder.dart';
import 'package:ice_app_new/models/enum_paytype.dart';
//import 'package:ice_app_new/models/paymentselected.dart';
//import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/ordersuccess.dart';
//import 'package:ice_app_new/pages/payment.dart';
//import 'package:ice_app_new/pages/paymentsuccess.dart';
import 'package:ice_app_new/providers/order.dart';
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

class OrdercheckoutPage extends StatefulWidget {
  static const routeName = '/ordercheckout';
  @override
  _OrdercheckoutPageState createState() => _OrdercheckoutPageState();
}

class _OrdercheckoutPageState extends State<OrdercheckoutPage> {
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

  Widget _buildList(List<Addorder> itemlist) {
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
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "ราคาขาย ${itemlist[index].sale_price}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.cyan[700]),
                                  ),
                                ],
                              )
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "x${itemlist[index].qty}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "${formatter.format(double.parse(itemlist[index].qty) * double.parse(itemlist[index].sale_price))}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[700],
                                      fontSize: 16)),
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

  void _submitForm2(String _customer_id, List<Addorder> listitems,
      String pay_type, String discount) async {
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
    bool issave = await Provider.of<OrderData>(context, listen: false)
        .addOrderNewPos(_customer_id, listitems, pay_type, discount);
    if (issave == true) {
      if (printBinded == true) {
        printTicketFromSunmi(listitems);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrdersuccessPage(),
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

  @override
  Widget build(BuildContext context) {
    double total_amount = 0;
    double total_qty = 0;
    final payment_data = ModalRoute.of(context).settings.arguments as Map; //
    List<Addorder> order_items = payment_data['orderitemlist'];
    //print('list length = ${paymentselected.length.toString()}');
    //paymentselected[0].order_amount
    order_items.forEach((elm) {
      total_qty = (total_qty + double.parse(elm.qty));
      total_amount = (total_amount +
          (double.parse(elm.qty) * double.parse(elm.sale_price)));
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'ยืนยันรายการขาย',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.purple,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "${order_items[0].customer_name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
              Consumer(
                builder: (context, UserData users, _) {
                  if (users.routeType == "2") {
                    // is market route
                    return GestureDetector(
                      onTap: () => _editBottomSheet(context),
                      child: Container(
                        color: Colors.white,
                        height: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text('ส่วนลด',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Text(
                                          '${formatter.format(_discount_amt)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('จำนวนสินค้า',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text('${total_qty}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child:
                              Text('จำนวนเงิน', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                    '${formatter.format(total_amount - _discount_amt)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                'ขายสด',
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
                                        order_items[0].customer_id,
                                        order_items,
                                        "1",
                                        _discount_amt.toString());
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
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.orange[400],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'ขายเชื่อ',
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
                                        order_items[0].customer_id,
                                        order_items,
                                        "2",
                                        _discount_amt.toString());
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
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.blue[400],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'ฟรี',
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
                                        order_items[0].customer_id,
                                        order_items,
                                        "3",
                                        _discount_amt.toString());
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

  void printTicketFromSunmi(List<Addorder> order_items) async {
    double total_qty = 0;
    double total_amt = 0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String emp_name = prefs.getString('emp_name');
    screenshotController
        .captureFromWidget(
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: 250,
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
                      data: 'SO23000001',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'น้ำแข็ง',
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
                  'เลขที่ SO210001',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                )),
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
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'ลูกค้า ${order_items[0].customer_name}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
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
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'ราคา',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'รวม',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: order_items.length == 0
                  ? Text('')
                  : ListView.builder(
                      itemCount: order_items.length,
                      itemBuilder: (BuildContext context, int index) {
                        total_qty =
                            total_qty + double.parse(order_items[index].qty);
                        total_amt = total_amt +
                            (double.parse(order_items[index].qty) *
                                double.parse(order_items[index].sale_price));
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
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
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${order_items[index].sale_price}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${formatter.format(double.parse(order_items[index].qty) * double.parse(order_items[index].sale_price))}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }),
            ),
            Padding(
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
                          '${total_qty}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${formatter.format(total_amt)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
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
      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.exitTransactionPrint(true);
    });
  }
}
