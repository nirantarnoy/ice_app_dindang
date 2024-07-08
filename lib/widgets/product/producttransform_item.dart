import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ice_app_new/models/orders_new.dart';
import 'package:ice_app_new/models/productionrec.dart';
import 'package:ice_app_new/models/transformlistall.dart';
import 'package:ice_app_new/pages/orderposdetail.dart';
import 'package:ice_app_new/pages/transformsuccess.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/product.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';
import '../../pages/orderdetail.dart';
//import '../../pages/createorder.dart';

class ProductTransformItem extends StatefulWidget {
  @override
  _ProductTransformItemState createState() => _ProductTransformItemState();
}

class _ProductTransformItemState extends State<ProductTransformItem> {
  List<Orders> _orders = [];
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void didChangeDependencies() {
    // if (_isInit) {
    //   Provider.of<CustomerData>(context, listen: false)
    //       .fetPosCustomers()
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;

    //       // print('issue id is ${selectedIssue}');
    //     });
    //   });
    // }
  }

  Widget _buildordersList(List<Transformlistall> transformall) {
    Widget orderCards;
    if (transformall.isNotEmpty) {
      if (transformall.length > 0) {
        // print("has list");
        orderCards = new ListView.builder(
            // primary: false,
            //  shrinkWrap: true,
            //  physics: NeverScrollableScrollPhysics(),
            itemCount: transformall.length,
            itemBuilder: (BuildContext context, int index) => Items(
                  transformall[index].id,
                  transformall[index].journal_no,
                  transformall[index].trans_date,
                  transformall[index].product_name,
                  transformall[index].qty,
                  transformall[index].created_name,
                  index,
                  transformall,
                ));
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

  @override
  Widget build(BuildContext context) {
    final ProductData _transformall = Provider.of<ProductData>(context);
    // orders.fetOrders();
    var formatter = NumberFormat('#,##,##0.#');
    return Column(
      children: <Widget>[
        Expanded(
          child: _transformall.listtransformall.isNotEmpty
              ? _buildordersList(_transformall.listtransformall)
              : Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
        ),
        SizedBox(
          height: 0,
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                child: Consumer<ProductData>(
                  builder: (context, _transformall, _) => GestureDetector(
                    child: Container(
                      color: Colors.blue[300],
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  '${formatter.format(_transformall.transformtotalQty)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5),
                                Text(
                                  'รวมยอดเบิกแปรสภาพ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Items extends StatefulWidget {
  final String _id;
  final String _journal_no;
  final String _trans_date;
  final String _product_name;
  final String _qty;
  final String _created_name;
  final int _index;
  final List<Transformlistall> _transformlistall;

  Items(
    this._id,
    this._journal_no,
    this._trans_date,
    this._product_name,
    this._qty,
    this._created_name,
    this._index,
    this._transformlistall,
  );

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var formatter = NumberFormat('#,##,##0.#');

  DateFormat dateformatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget._transformlistall[widget._index]),
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
            title: Text('ยืนยันการทำรายการ'),
            content: Text('ต้องการยกเลิกข้อมูลใช่หรือไม่'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() async {
                    bool isdeleled =
                        await Provider.of<ProductData>(context, listen: false)
                            .removeProductTransformLine(widget._id);
                    if (isdeleled == true) {
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransformsuccessPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: <Widget>[
                            Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "พบข้อผิดพลาด",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }
                  });
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
        print(widget._transformlistall[widget._index].id);
        widget._transformlistall.removeAt(widget._index);
        // return showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('ยืนยันการทำรายการ'),
        //     content: Text('ต้องการบันทึกการชำระเงินใช่หรือไม่'),
        //     actions: <Widget>[
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() async {
        //             bool isdeleled =
        //                 await Provider.of<ProductData>(context, listen: false)
        //                     .removeProdrecLine(widget._id);
        //             if (isdeleled == true) {
        //               widget._productionrec.removeAt(widget._index);
        //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //                 content: Row(
        //                   children: <Widget>[
        //                     Icon(
        //                       Icons.check_circle,
        //                       color: Colors.white,
        //                     ),
        //                     SizedBox(
        //                       width: 10,
        //                     ),
        //                     Text(
        //                       "ทำรายการสำเร็จ",
        //                       style: TextStyle(color: Colors.white),
        //                     ),
        //                   ],
        //                 ),
        //                 backgroundColor: Colors.green,
        //               ));
        //             } else {
        //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //                 content: Row(
        //                   children: <Widget>[
        //                     Icon(
        //                       Icons.error_outline,
        //                       color: Colors.white,
        //                     ),
        //                     SizedBox(
        //                       width: 10,
        //                     ),
        //                     Text(
        //                       "พบข้อผิดพลาด",
        //                       style: TextStyle(color: Colors.white),
        //                     ),
        //                   ],
        //                 ),
        //                 backgroundColor: Colors.red,
        //               ));
        //             }
        //           });
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
      },
      child: GestureDetector(
        onTap:
            () {}, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
        child: Column(
          children: <Widget>[
            ListTile(
              // leading: ElevatedButton(
              //     color:
              //         _payment_method_id == "1" ? Colors.green : Colors.purple[300],
              //     onPressed: () {},
              //     child: Text(
              //       "$_payment_method",
              //       style: TextStyle(color: Colors.white),
              //     )),
              // leading: Chip(
              //   label:
              //       Text("${_order_no}", style: TextStyle(color: Colors.white)),
              //   backgroundColor: Colors.green[500],
              // ),
              leading: Chip(
                backgroundColor: Colors.lightGreen,
                label: Text('${widget._product_name}'),
              ),
              title: Text(
                "${widget._journal_no}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${widget._trans_date}",
                style: TextStyle(color: Colors.cyan[700]),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${formatter.format(double.parse(widget._qty))}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 14),
                  )
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}