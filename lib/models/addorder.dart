import 'package:flutter/material.dart';

class Addorder {
  final String customer_id;
  final String customer_name;
  final String product_id;
  final String product_code;
  final String product_name;
  final String car_id;
  final String qty;
  final String sale_price;
  final String price_group_id;
  final String haft_cal;
  final String original_sale_price;

  Addorder({
    this.customer_id,
    this.customer_name,
    this.product_id,
    this.product_code,
    this.product_name,
    this.car_id,
    this.qty,
    this.sale_price,
    this.price_group_id,
    this.haft_cal,
    this.original_sale_price,
  });
}
