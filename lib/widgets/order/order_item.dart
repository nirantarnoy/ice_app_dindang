import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/order.dart';
import 'package:provider/provider.dart';

import '../../models/orders.dart';
import '../../pages/orderdetail.dart';
import '../../pages/createorder.dart';

class OrderItem extends StatelessWidget {
  List<Orders> _orders = [];
  Widget _buildordersList(List<Orders> orders) {
    Widget orderCards;
    if (orders != null) {
      if (orders.length > 0) {
        // print("has list");
        orderCards = new ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
                orders[index].id,
                orders[index].order_no,
                orders[index].customer_name,
                orders[index].order_date,
                orders[index].note,
                orders[index].total_amount,
                orders[index].payment_method_id,
                orders[index].payment_method,
                orders[index].customer_id,
                orders[index].customer_code);
          },
        );
        return orderCards;
      } else {
        return Text(
          "ไม่พบข้อมูล",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        );
      }
    } else {
      return Text(
        "ไม่พบข้อมูล",
        style: TextStyle(fontSize: 20, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderData orders = Provider.of<OrderData>(context, listen: false);
    // orders.fetOrders();
    var formatter = NumberFormat('#,##,##0');
    return Column(
      children: [
        Column(children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "ยอดขาย",
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                    SizedBox(width: 10),
                    Chip(
                      label: Text(
                        "${formatter.format(orders.totalAmount)}",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Text("บาท",
                        style: TextStyle(fontSize: 20, color: Colors.black87)),
                    FloatingActionButton(
                        backgroundColor: Colors.green[500],
                        onPressed: () => Navigator.of(context)
                            .pushNamed(CreateorderPage.routeName),
                        child: Icon(Icons.add, color: Colors.white)
                        //   FlatButton(onPressed: () {}, child: Text("เพิ่มรายการขาย")),
                        )
                  ]),
            ),
          )
        ]),
        SizedBox(height: 5),
        Expanded(
            child: orders.listorder.isNotEmpty
                ? _buildordersList(orders.listorder)
                : Text('Not Data')),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class Items extends StatelessWidget {
  //orders _orders;
  final String _id;
  final String _order_no;
  final String _customer_name;
  final String _customer_id;
  final String _customer_code;
  final String _order_date;
  final String _note;
  final String _total_amount;
  final String _payment_method;
  final String _payment_method_id;

  Items(
      this._id,
      this._order_no,
      this._customer_name,
      this._order_date,
      this._note,
      this._total_amount,
      this._payment_method_id,
      this._payment_method,
      this._customer_id,
      this._customer_code);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_id),
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
      onDismissed: (direction) {
        Provider.of<OrderData>(context, listen: false).removeOrder(_id);
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(OrderDetailPage.routeName, arguments: _customer_id);
        }, // Navigator.of(context).pushNamed(OrderDetailPage.routeName),
        child: Column(
          children: <Widget>[
            ListTile(
              // leading: RaisedButton(
              //     color:
              //         _payment_method_id == "1" ? Colors.green : Colors.purple[300],
              //     onPressed: () {},
              //     child: Text(
              //       "$_payment_method",
              //       style: TextStyle(color: Colors.white),
              //     )),
              leading: Chip(
                label:
                    Text("${_order_no}", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green[500],
              ),
              title: Text(
                "$_customer_name $_note",
                style: TextStyle(fontSize: 16, color: Colors.cyan),
              ),
              subtitle: Text("$_order_date ($_order_no)"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$_total_amount",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
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
