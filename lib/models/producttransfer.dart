import 'package:flutter/material.dart';

class ProducttransferList {
  final String id;
  final String journal_no;
  final String trans_date;
  final String product_id;
  final String product_name;
  final String qty;
  final String created_name;
  final String warehouse_name;

  ProducttransferList({
    this.id,
    this.journal_no,
    this.trans_date,
    this.product_id,
    this.product_name,
    this.qty,
    this.created_name,
    this.warehouse_name,
  });
}
