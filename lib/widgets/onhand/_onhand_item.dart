import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ice_app_new/models/orders_new.dart';
import 'package:ice_app_new/models/productionrec.dart';
import 'package:ice_app_new/models/products.dart';
import 'package:ice_app_new/pages/orderposdetail.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:ice_app_new/providers/product.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';
import '../../pages/orderdetail.dart';
//import '../../pages/createorder.dart';

class OnhandItem extends StatefulWidget {
  @override
  _OnhandItemState createState() => _OnhandItemState();
}

class _OnhandItemState extends State<OnhandItem> {
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

  Widget _buildordersList(List<Products> products) {
    Widget orderCards;
    if (products.isNotEmpty) {
      if (products.length > 0) {
        // print("has list");
        orderCards = new ListView.builder(
            // primary: false,
            //  shrinkWrap: true,
            //  physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) => Items(
                  products[index].id,
                  products[index].name,
                  products[index].onhand,
                  index,
                  products,
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
    final ProductData productall =
        Provider.of<ProductData>(context, listen: false);
    // orders.fetOrders();
    var formatter = NumberFormat('#,##,##0.#');
    return Column(
      children: <Widget>[
        Expanded(
          child: productall.listproductall.isNotEmpty
              ? _buildordersList(productall.listproductall)
              : Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }
}

class Items extends StatefulWidget {
  final String _id;
  final String _name;
  final String _onhand;
  final int _index;
  final List<Products> _products;

  Items(
    this._id,
    this._name,
    this._onhand,
    this._index,
    this._products,
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
      key: ValueKey(widget._products[widget._index]),
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
      confirmDismiss: (direction) {},
      onDismissed: (direction) {},
      child: GestureDetector(
        onTap:
            () {}, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                "${widget._name}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${formatter.format(double.parse(widget._onhand))}",
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
