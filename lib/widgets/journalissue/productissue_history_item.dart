import 'package:flutter/material.dart';
import 'package:ice_app_new/models/issueitemhistory.dart';
import 'package:ice_app_new/models/routeolestock.dart';

import 'package:ice_app_new/pages/carload_review.dart';
import 'package:ice_app_new/pages/createorder_new.dart';
import 'package:ice_app_new/pages/scrapsuccess.dart';
//import 'package:ice_app_new/pages/journalissue.dart';
import 'package:intl/intl.dart';
import 'package:ice_app_new/providers/issuedata.dart';
import 'package:provider/provider.dart';

import '../../models/issueitems.dart';

class ProductissueHistoryItem extends StatefulWidget {
  @override
  _ProductissueHistoryItemState createState() =>
      _ProductissueHistoryItemState();
}

class _ProductissueHistoryItemState extends State<ProductissueHistoryItem> {
  initState() {
    Provider.of<IssueData>(context, listen: false).fetoldstockrouteHistory();
    super.initState();
  }

  Widget _buildissueitemList(List<IssueitemHistory> issue_items) {
    Widget productCards;
    if (issue_items.isNotEmpty) {
      if (issue_items.length > 0) {
        //print("has list");
        productCards = new ListView.builder(
          itemCount: issue_items.length,
          itemBuilder: (BuildContext context, int index) {
            return Items(
              issue_items[index].line_issue_id.toString(),
              issue_items[index].issue_id,
              issue_items[index].product_id,
              issue_items[index].product_name.toString(),
              issue_items[index].qty,
              issue_items[index].route_id,
              issue_items[index].route_name,
              issue_items[index].trans_date,
              issue_items[index].issue_no,
              context,
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

  Widget _buildoldstocklist(List<RouteOldStock> oldstock_items) {
    Widget productCards2;
    if (oldstock_items.isNotEmpty) {
      if (oldstock_items.length > 0) {
        // print("has list");
        productCards2 = new ListView.builder(
          itemCount: oldstock_items.length,
          itemBuilder: (BuildContext context, int index) {
            //  print(oldstock_items[index].product_code.toString());
            return Items2(
              oldstock_items[index].product_code.toString(),
              oldstock_items[index].product_id.toString(),
              oldstock_items[index].product_name.toString(),
              oldstock_items[index].qty,
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

      return productCards2;
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
    // final IssueData item_issues =
    //     Provider.of<IssueData>(context, listen: false);
    //Provider.of<IssueData>(context, listen: false).fetoldstockroute();
    var formatter = NumberFormat('#,##,##0.#');
    return Expanded(
      child: Consumer<IssueData>(
        builder: (context, issues, _) => issues.listissuehistory.isNotEmpty
            ? _buildissueitemList(issues.listissuehistory)
            : Center(
                child: Text(
                  "ไม่พบข้อมูล",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  var formatter = NumberFormat('#,##,##0.#');
  //orders _orders;
  final String _line_issue_id;
  final String _issue_id;
  final String _product_id;
  final String _product_name;
  final String _qty;
  final String _route_id;
  final String _routename;
  final String _trans_date;
  final String _journal_no;
  BuildContext _context;

  Items(
    this._line_issue_id,
    this._issue_id,
    this._product_id,
    this._product_name,
    this._qty,
    this._route_id,
    this._routename,
    this._trans_date,
    this._journal_no,
    this._context,
  );
  void _submitForm(String issue_id, String route_id) async {
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
    // double check_old_qty =
    //     Provider.of<IssueData>(context, listen: false).getOldqty(_product_id);
    return new GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('ต้องการยกเลิกข้อมูลใช่หรือไม่'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _submitForm(_issue_id, _route_id);
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
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text(''),
            ),
            title: Text(
              "$_product_name",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: Text("${_routename} /n ${_journal_no}"),
            trailing: Text("${formatter.format(double.parse(_qty))}",
                //  trailing: Text("0",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class Items2 extends StatelessWidget {
  var formatter = NumberFormat('#,##,##0.#');
  //orders _orders;
  final String _product_code;
  final String _product_id;
  final String _product_name;
  final String _qty;

  Items2(
    this._product_code,
    this._product_id,
    this._product_name,
    this._qty,
  );
  @override
  Widget build(BuildContext context) {
    // double check_old_qty =
    //     Provider.of<IssueData>(context, listen: false).getOldqty(_product_id);
    return new GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text(''),
            ),
            title: Text(
              "$_product_name",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // subtitle: Text("ราคาขาย $_price บาท"),
            trailing: Text("${formatter.format(double.parse(_qty))}",
                //  trailing: Text("0",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ),
          Divider(),
        ],
      ),
    );
  }
}
