import 'package:flutter/material.dart';

class IssueitemHistory {
  final String line_issue_id;
  final String issue_id;
  final String product_id;
  final String product_name;
  final String issue_no;
  final String qty;
  final String price;
  final String product_image;
  final String avl_qty;
  final String issue_status;
  final String route_id;
  final String route_name;
  final String trans_date;

  IssueitemHistory({
    @required this.line_issue_id,
    @required this.issue_id,
    @required this.product_id,
    @required this.product_name,
    @required this.issue_no,
    @required this.qty,
    @required this.price,
    this.product_image,
    this.avl_qty,
    this.issue_status,
    this.route_id,
    this.route_name,
    this.trans_date,
  });
}
