import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ice_app_new/models/issueitemhistory.dart';
import 'package:ice_app_new/page_offline/createorder_new_offline.dart';
//import 'package:ice_app_new/pages/createorder.dart';
import 'package:ice_app_new/pages/createorder_new.dart';
import 'package:ice_app_new/pages/createorder_new_pos.dart';
import 'package:ice_app_new/pages/main_test.dart';
import 'package:ice_app_new/pages/scrapsuccess.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:ice_app_new/providers/product.dart';
import 'package:ice_app_new/widgets/journalissue/productissue_history_item.dart';
//import 'package:ice_app_new/widgets/order/order_item.dart';
import 'package:ice_app_new/widgets/order/order_item_new.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ice_app_new/widgets/order/order_item_new_pos.dart';
import 'package:intl/intl.dart';

//import 'package:ice_app_new/helpers/activity_connection.dart';
import 'package:provider/provider.dart';

import 'package:ice_app_new/providers/order.dart';
//import 'package:ice_app_new/widgets/error/err_api.dart';

class ProductissueHistoryPage extends StatefulWidget {
  static const routeName = '/productissuehistory';
  @override
  _ProductissueHistoryPageState createState() =>
      _ProductissueHistoryPageState();
}

class _ProductissueHistoryPageState extends State<ProductissueHistoryPage>
    with TickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;

  bool _networkisok = false;

  bool _showBackToTopButton = false;
  ScrollController _scrollController;

  Future _orderFuture;

  Future _obtainOrderFuture() {
    //Provider.of<OrderData>(context, listen: false).searchBycustomer = '';
    return Provider.of<IssueData>(context, listen: false)
        .fetoldstockrouteHistory();
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

  // Widget _buildOrdersList() {
  //   return Consumer(builder: (context, OrderData orders, Widget child) {
  //     // orders.fetOrders();
  //     Widget content = Center(
  //         child: Text(
  //       'ไม่พบข้อมูล!',
  //       style: TextStyle(
  //           fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey),
  //     ));
  //     // print("data length = " + products.listproduct.toString());
  //     if (orders.is_apicon) {
  //       content = FutureBuilder(
  //           future: ,
  //           builder: (context, dataSnapshort) => {
  //                 if (dataSnapshort.connectionState == ConnectionState.waiting)
  //                   {
  //                     Center(child: CircularProgressIndicator()),
  //                   }else{

  //                   }
  //               });

  //       // if (_isLoading == true) {
  //       //   print("Page is loading");
  //       //   content = Center(child: CircularProgressIndicator());
  //       // } else {
  //       //   // content = Center(child: CircularProgressIndicator());
  //       //   content = Container(child: OrderItem());
  //       // }
  //     } else {
  //       content = ErrorApi();
  //     }
  //     //return content;
  //     return RefreshIndicator(
  //       onRefresh: orders.fetOrders,
  //       child: content,
  //     );
  //   });
  // }

  Widget _buidorderlist() {
    IssueData issues = Provider.of<IssueData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _orderFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(child: ProductissueHistoryItem());
          }
        }
      },
    );

    return RefreshIndicator(
      child: content,
      onRefresh: issues.fetoldstockrouteHistory,
    );
  }

  Widget _buildissueitemList(List<IssueitemHistory> issue_items) {
    var formatter = NumberFormat('#,##,##0.#');
    Widget productCards;
    if (issue_items.isNotEmpty) {
      if (issue_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: issue_items.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('แจ้งเตือน'),
                    content: Text('ต้องการยกเลิกข้อมูลใช่หรือไม่'),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _submitForm(issue_items[index].issue_id,
                              issue_items[index].route_id, context);
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
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(''),
                ),
                title: Text(
                  "${issue_items[index].product_name}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                    "${issue_items[index].trans_date} : ${issue_items[index].issue_no}"),
                trailing: Text(
                    "${formatter.format(double.parse(issue_items[index].qty))}",
                    //  trailing: Text("0",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ),
            );
          },
        );
      } else {
        return Center(
          child: Text(
            "ไม่พบข้อมูล",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        );
      }

      return productCards;
    } else {
      return Center(
        child: Text(
          "ไม่พบข้อมูล",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
    }
  }

  void _submitForm(
      String issue_id, String route_id, BuildContext _context) async {
    showDialog(
      context: _context,
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
    bool issave = await Provider.of<IssueData>(_context, listen: false)
        .cancelissuecar(issue_id, route_id);
    if (issave == true) {
      Navigator.push(
        _context,
        MaterialPageRoute(
          builder: (_) => ScrapsuccessPage(),
        ),
      );
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
            'ประวัติการเบิกของสายส่ง',
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
          // actions: <Widget>[
          //   Padding(
          //     padding: EdgeInsets.only(right: 20.0),
          //     child: GestureDetector(
          //       onTap: () {
          //         //  Navigator.of(context).pushNamed(CreateorderNewOfflinePage.routeName);
          //         Navigator.of(context)
          //             .pushNamed(CreateorderNewPosPage.routeName);
          //       },
          //       child: Icon(
          //         Icons.add_circle_outline,
          //         size: 30.0,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: _networkisok == true
            ? Column(
                children: [
                  Expanded(
                    child: Consumer<IssueData>(
                        builder: (context, issues, _) =>
                            issues.listissuehistory.isNotEmpty
                                ? _buildissueitemList(issues.listissuehistory)
                                : Center(
                                    child: Text("ไม่พบข้อมูล"),
                                  )),
                  ),
                ],
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