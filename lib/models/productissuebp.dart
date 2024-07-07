import 'package:flutter/material.dart';

class Productissuebp {
  final String id;
  final String code;
  final String name;
  final String sale_price;
  final String onhand;

  Productissuebp({
    @required this.id,
    @required this.code,
    @required this.name,
    @required this.sale_price,
    this.onhand,
  });
}
