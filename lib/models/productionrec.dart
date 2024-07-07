import 'package:flutter/material.dart';

class ProductionRecData {
  final String id;
  final String journal_no;
  final String trans_date;
  final String product_name;
  final String qty;
  final String created_name;

  ProductionRecData({
    this.id,
    this.journal_no,
    this.trans_date,
    this.product_name,
    this.qty,
    this.created_name,
  });
}
