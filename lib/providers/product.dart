import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ice_app_new/models/addprodrec.dart';
import 'package:ice_app_new/models/addscrapitem.dart';
import 'package:ice_app_new/models/countitemlist.dart';
import 'package:ice_app_new/models/productionrec.dart';
import 'package:ice_app_new/models/productissuebp.dart';

import 'package:ice_app_new/models/products.dart';
import 'package:ice_app_new/models/producttransfer.dart';
import 'package:ice_app_new/models/scraplist.dart';
import 'package:ice_app_new/models/transformlistall.dart';
import 'package:ice_app_new/models/transfromlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductData with ChangeNotifier {
  final String url_to_product_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/product/list";
  final String url_to_product_issue_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/product/issuelist2";
  // "http://103.253.73.108/icesystemdindang/frontend/web/api/product/list";
  final String url_to_product_detail =
      //   "http://203.203.1.224/icesystembp/frontend/web/api/product/detail";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/product/detail";
  final String url_to_product_all =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/product/listproductall";

  final String url_to_prodrec_add =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/addprodrecmobile";

  final String url_to_product_by_route =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/getproductroute";

  final String url_to_production_list =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/listmobileall";

  final String url_to_delete_prodrec_line =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/deleprodrecline";

  final String url_to_add_transform =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/addproducttransform";
  final String url_to_transform_listall =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/gettransformall";

  final String url_to_add_dailycount =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/product/adddailycount";
  final String url_to_add_dailytransfer =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/product/addtftransfer";
  final String url_to_add_scrap =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/addscrapmobile";

  final String url_to_scrap_list =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/scraplist";

  final String url_to_cancel_scrap =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/scrapcancel";

  final String url_to_product_transfer_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/producttransferlist";

  final String url_to_add_product_transfer =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/addproducttransfermobile";

  final String url_to_delete_product_transfer_line =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/deleproducttransferline";

  final String url_to_delete_product_transform_line =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/production/deleteproducttransform";

  List<Products> _product;
  List<Products> get listproduct => _product;

  List<Products> _productall;
  List<Products> get listproductall => _productall;

  List<Productissuebp> _productissuebp;
  List<Productissuebp> get listproductissuebp => _productissuebp;

  List<ProductionRecData> _production_rec;
  List<ProductionRecData> get listproductionrec => _production_rec;

  List<Scraplist> _scrap_list;
  List<Scraplist> get listscrap => _scrap_list;

  List<Transformlist> _transformlist;
  List<Transformlist> get listtransformlist => _transformlist;

  List<Transformlistall> _transformlistall;
  List<Transformlistall> get listtransformall => _transformlistall;

  List<ProducttransferList> _product_transfer;
  List<ProducttransferList> get listproducttransfer => _product_transfer;

  String _prodrec_after_add = '';
  String get prodrec_after_add => _prodrec_after_add;

  String _product_transfer_after_add = '';
  String get product_transfer_after_add => _product_transfer_after_add;

  String _count_no_after_save = '';
  String get count_no_after_save => _count_no_after_save;

  String _after_scrap_no = '';
  String get after_scrap_no => _after_scrap_no;

  bool _isLoading = false;

  int _id = 0;
  int get idProduct => _id;

  set idProduct(int val) {
    _id = val;
    notifyListeners();
  }

  set listproduct(List<Products> val) {
    _product = val;
    notifyListeners();
  }

  set listproductall(List<Products> val) {
    _productall = val;
    notifyListeners();
  }

  set listtransformall(List<Transformlistall> val) {
    _transformlistall = val;
    notifyListeners();
  }

  set listtransformlist(List<Transformlist> val) {
    _transformlist = val;
    notifyListeners();
  }

  set listproductissuebp(List<Productissuebp> val) {
    _productissuebp = val;
    notifyListeners();
  }

  set listscrap(List<Scraplist> val) {
    _scrap_list = val;
    notifyListeners();
  }

  set prodrec_after_add(String order_no) {
    _prodrec_after_add = order_no;
  }

  set product_transfer_after_add(String order_no) {
    _product_transfer_after_add = order_no;
  }

  set after_scrap_no(String order_no) {
    _after_scrap_no = order_no;
  }

  set count_no_after_save(String order_no) {
    _count_no_after_save = order_no;
  }

  set listproductionrec(List<ProductionRecData> val) {
    _production_rec = val;
  }

  set listproducttransfer(List<ProducttransferList> val) {
    _product_transfer = val;
  }

  bool get is_loading {
    return _isLoading;
  }

  double get productionrectotalQty {
    double total = 0.0;
    if (listproductionrec.isNotEmpty) {
      listproductionrec.forEach((orderItem) {
        total += double.parse(orderItem.qty);
      });
    }
    return total;
  }

  double get producttransfertotalQty {
    double total = 0.0;
    if (listproducttransfer.isNotEmpty) {
      listproducttransfer.forEach((orderItem) {
        total += double.parse(orderItem.qty);
      });
    }
    return total;
  }

  double get transformtotalQty {
    double total = 0.0;
    if (listtransformall.isNotEmpty) {
      listtransformall.forEach((orderItem) {
        total += double.parse(orderItem.qty);
      });
    }
    return total;
  }

  double get scraptotalQty {
    double total = 0.0;
    if (listscrap.isNotEmpty) {
      listscrap.forEach((orderItem) {
        total += double.parse(orderItem.qty);
      });
    }
    return total;
  }

  List<Products> listproducttf() {
    List<Products> _list = [];
    if (listproductall.isNotEmpty) {
      listproductall.forEach((element) {
        if (element.id == '1') {
          Products _xitem = Products(
            id: element.id,
            code: element.code,
            name: element.name,
            sale_price: '0',
          );
          _list.add(_xitem);
        }
      });
    }
    return _list;
  }

  Future<dynamic> fetProductissue(String customer_id) async {
    _isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {
      'customer_id': customer_id,
      'route_id': _routeid,
      'issue_date': _issue_date
    };

    print(filterData);
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_product_issue_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Products> data = [];
        // print('data length is ${res["data"].length}');
        print('product data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Products.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Products productresult = Products(
            id: res['data'][i]['id'].toString(),
            code: res['data'][i]['code'].toString(),
            name: res['data'][i]['name'].toString(),
            sale_price: res['data'][i]['sale_price'].toString(),
            image: res['data'][i]['image'].toString(),
            issue_id: res['data'][i]['issue_id'].toString(),
            onhand: res['data'][i]['onhand'].toString(),
            price_group_id: res['data'][i]['price_group_id'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listproduct = data;
        _isLoading = false;
        notifyListeners();
        return listproduct;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetProducts(String customer_id) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> filterData = {'customer_id': customer_id};
    print(filterData);
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_product_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Products> data = [];
        // print('data length is ${res["data"].length}');
        print('product data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Products.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Products productresult = Products(
              id: res['data'][i]['id'].toString(),
              code: res['data'][i]['code'].toString(),
              name: res['data'][i]['name'].toString(),
              sale_price: res['data'][i]['sale_price'].toString(),
              image: res['data'][i]['image'].toString(),
              haft_price: res['data'][i]['haft_cal'].toString());

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listproduct = data;
        _isLoading = false;
        notifyListeners();
        return listproduct;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetProductAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.get(
        Uri.parse(url_to_product_all),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Products> data = [];
        // print('data length is ${res["data"].length}');
        print('product data all is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Products.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Products productresult = Products(
              id: res['data'][i]['id'].toString(),
              code: res['data'][i]['code'].toString(),
              name: res['data'][i]['name'].toString(),
              sale_price: res['data'][i]['sale_price'].toString(),
              image: res['data'][i]['image'].toString(),
              onhand: res['data'][i]['onhand_qty'].toString());

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listproductall = data;
        _isLoading = false;
        notifyListeners();
        return listproductall;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  // Future<void> addOrder(String product_id, int qty, int customer_id) async {
  //   final Map<String, dynamic> orderData = {
  //     'product_id': product_id,
  //     'qty': qty,
  //     'customer_id': customer_id
  //   };
  //   try {
  //     http.Response response;
  //     response = await http.post(Uri.parse(url_to_product),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode(orderData));

  //     if (response.statusCode == 200) {}
  //   } catch (_) {}
  // }

  // Future<Orders> getDetails() async {
  //   try {
  //     http.Response response;
  //     response = await http.get(Uri.parse(url_to_product),
  //         headers: {'Content-Type': 'application/json'});

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> res = json.decode(response.body);
  //       List<Orders> data = [];
  //       print('data length is ${res["data"].length}');
  //       if (res == null) {
  //         _isLoading = false;
  //         notifyListeners();
  //         return null;
  //       }
  //       for (var i = 0; i < res['data'].length - 1; i++) {
  //         final Orders orderresult = Orders(
  //           id: res['data'][i]['id'],
  //           order_no: res['data'][i]['order_no'],
  //           order_date: res['data'][i]['order_date'],
  //           customer_name: res['data'][i]['customer_name'],
  //           note: res['data'][i]['note'],
  //         );

  //         data.add(orderresult);
  //       }

  //       listproduct = data;
  //       _isLoading = false;
  //       notifyListeners();
  //       return listproduct;
  //     }
  //   } catch (_) {}
  // }

  Future<bool> addProdrec(List<Addprodrec> listdata) async {
    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.product_id,
              'qty': e.qty,
            })
        .toList();

    final Map<String, dynamic> prodrecData = {
      'trans_date': _order_date,
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
    };
    print('data will save prodrec is ${prodrecData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_prodrec_add),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(prodrecData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added prodrec is  ${res["data"]}');
        if (res != null) {
          prodrec_after_add = res["data"][0]["journal_no"];
          print('${res["data"][0]["journal_no"]}');
        }
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  double getProductOnhand(String product_id) {
    double onhand_qty = 0.0;
    listproductall.forEach((element) {
      if (element.id.toString() == product_id) {
        onhand_qty = double.parse(element.onhand);
      }
    });
    return onhand_qty;
  }

  Future<dynamic> fetProductToTransformList(String product_id) {
    List<Transformlist> _item = [];
    if (listproductall != null) {
      listproductall.forEach((element) {
        if (element.id.toString() != product_id) {
          Transformlist _xitem = Transformlist(
            from_product_id: product_id,
            to_product_id: element.id,
            to_product_name: element.name,
            from_qty: '0',
            to_qty: '0',
          );
          _item.add(_xitem);
        }
      });
    }
    listtransformlist = _item;
    notifyListeners();
  }

  Future<dynamic> fetProductbyroute(String route_id) async {
    _isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _issue_date = new DateTime.now().toString();

    final Map<String, dynamic> filterData = {'route_id': route_id};

    print(filterData);
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_product_by_route),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Productissuebp> data = [];
        // print('data length is ${res["data"].length}');
        print('product data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Products.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Productissuebp productresult = Productissuebp(
            id: res['data'][i]['id'].toString(),
            code: res['data'][i]['code'].toString(),
            name: res['data'][i]['name'].toString(),
            sale_price: res['data'][i]['sale_price'].toString(),
            onhand: res['data'][i]['onhand'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listproductissuebp = data;
        _isLoading = false;
        notifyListeners();
        return listproductissuebp;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetProductionRec() async {
    // String _user_id;
    String _company_id = "";
    String _branch_id = "";
    String _order_date = new DateTime.now().toString();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      //  _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> filterData = {
      'company_id': _company_id,
      'branch_id': _branch_id,
    };

    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_production_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<ProductionRecData> data = [];
        print('data pos length is ${res["data"].length}');
        //  print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final ProductionRecData orderresult = ProductionRecData(
            id: res['data'][i]['id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            trans_date: res['data'][i]['trans_date'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
            created_name: res['data'][i]['created_name'].toString(),
          );

          data.add(orderresult);
        }

        listproductionrec = data;
        _isLoading = false;

        notifyListeners();

        return listproductionrec;
      }
    } catch (_) {
      print('has server data error');
    }
  }

  Future<bool> removeProdrecLine(String line_id) async {
    bool is_completed = false;
    String _user_id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
    }
    final Map<String, dynamic> delete_id = {
      'id': line_id,
      'user_id': _user_id,
    };

    print("data will cancel is ${delete_id}");

    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_delete_prodrec_line),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(delete_id));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data delete length is ${res["data"]}');

        is_completed = true;
      }
    } catch (_) {}

    notifyListeners();
    return is_completed;
  }

  Future<dynamic> fetProductTransfer() async {
    String _user_id;
    String _company_id = "";
    String _branch_id = "";
    String _order_date = new DateTime.now().toString();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> filterData = {
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
    };

    _isLoading = true;
    notifyListeners();
    print('data product transfer is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_product_transfer_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<ProducttransferList> data = [];
        print('data product transfer length is ${res["data"].length}');
        //  print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final ProducttransferList orderresult = ProducttransferList(
            id: res['data'][i]['id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            trans_date: res['data'][i]['trans_date'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
            created_name: res['data'][i]['created_name'].toString(),
            warehouse_name: res['data'][i]['warehouse_name'].toString(),
          );

          data.add(orderresult);
        }

        listproducttransfer = data;
        _isLoading = false;

        notifyListeners();

        return listproducttransfer;
      }
    } catch (_) {
      print('has server data error');
    }
  }

  Future<bool> removeProductTransferLine(String line_id) async {
    bool is_completed = false;
    String _user_id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
    }
    final Map<String, dynamic> delete_id = {
      'id': line_id,
      'user_id': _user_id,
    };

    print("data will cancel is ${delete_id}");

    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_delete_product_transfer_line),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(delete_id));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data delete length is ${res["data"]}');

        is_completed = true;
      }
    } catch (_) {}

    notifyListeners();
    return is_completed;
  }

  Future<bool> removeProductTransformLine(String line_id) async {
    bool is_completed = false;
    String _user_id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
    }
    final Map<String, dynamic> delete_id = {
      'id': line_id,
      'user_id': _user_id,
    };

    print("data will cancel transform is ${delete_id}");

    try {
      http.Response response;
      response = await http.post(
          Uri.parse(url_to_delete_product_transform_line),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(delete_id));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data delete length is ${res["data"]}');

        is_completed = true;
      }
    } catch (_) {}

    notifyListeners();
    return is_completed;
  }

  Future<bool> addProductTransfer(List<Addprodrec> listdata) async {
    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.product_id,
              'qty': e.qty,
              'transfer_branch_id': e.transfer_branch_id,
            })
        .toList();

    final Map<String, dynamic> saveData = {
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'warehouse_id': 1,
      'production_type': 5,
      'data': jsonx,
    };
    print('data will save product transfer is ${saveData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_product_transfer),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(saveData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added product transfer is  ${res["data"]}');
        if (res != null) {
          product_transfer_after_add = res["data"][0]["journal_no"];
          print('${res["data"][0]["journal_no"]}');
        }
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<List> findProductAll(String query) async {
    await Future.delayed(Duration(microseconds: 500));
    return listproductall
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<bool> addTransform(
      String product_id, String issue_qty, List<Transformlist> listdata) async {
    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.to_product_id,
              'qty': e.to_qty,
            })
        .toList();

    final Map<String, dynamic> prodrecData = {
      'product_id': product_id,
      'issue_qty': issue_qty,
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
    };
    print('data will save transform is ${prodrecData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_transform),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(prodrecData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added prodrec is  ${res["data"]}');
        // if (res != null) {
        //   prodrec_after_add = res["data"][0]["journal_no"];
        //   print('${res["data"][0]["journal_no"]}');
        // }
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<bool> addDailycount(List<CountitemList> listdata) async {
    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.product_id,
              'qty': double.parse(e.qty),
            })
        .toList();

    final Map<String, dynamic> prodrecData = {
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
    };
    print('data will save counting is ${prodrecData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_dailycount),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(prodrecData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added counting is  ${res["data"]}');
        if (res != null) {
          count_no_after_save = res["data"][0]["id"].toString();
        }
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
    // return true;
  }

  Future<bool> addDailytransfer(List<CountitemList> listdata) async {
    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.product_id,
              'qty': e.qty,
            })
        .toList();

    final Map<String, dynamic> prodrecData = {
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
    };
    print('data will save transfer is ${prodrecData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_dailytransfer),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(prodrecData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added transfer is  ${res["data"]}');
        print('data added transfer is  ${res["data"][0]['id']}');
        if (res != null) {
          count_no_after_save = res["data"][0]["id"].toString();
        }
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<dynamic> fetTransformAll() async {
    _isLoading = true;
    notifyListeners();
    String _company_id;
    String _branch_id;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _issue_date = new DateTime.now().toString();

    if (prefs.getString('user_id') != null) {
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> postdata = {
      'company_id': _company_id,
      'branch_id': _branch_id,
    };

    print("find trans from data is ${postdata}");
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_transform_listall),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(postdata));

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<Transformlistall> data = [];
        // print('data length is ${res["data"].length}');
        print('transform data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          // var product = Products.fromJson(res[i]);
          //print(res['data'][i]['code']);
          // data.add(product);
          final Transformlistall productresult = Transformlistall(
            id: res['data'][i]['id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            trans_date: res['data'][i]['trans_date'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
            created_name: res['data'][i]['created_name'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listtransformall = data;
        print("transform len is ${listtransformall.length}");
        _isLoading = false;
        notifyListeners();
        return listtransformall;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<bool> addScrap(List<AddscrapItem> listdata) async {
    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.product_id,
              'qty': e.qty,
            })
        .toList();

    final Map<String, dynamic> prodrecData = {
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
      'order_no': '',
    };
    print('data will save scrap is ${prodrecData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_scrap),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(prodrecData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added prodrec is  ${res["data"]}');
        if (res != null) {
          after_scrap_no = res["data"][0]["journal_no"];
          print('${res["data"][0]["journal_no"]}');
        }
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<dynamic> fetScrap() async {
    // String _user_id;
    String _company_id = "";
    String _branch_id = "";
    String _order_date = new DateTime.now().toString();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      //  _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> filterData = {
      'company_id': _company_id,
      'branch_id': _branch_id,
    };
    print('data scrap filter is ${filterData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_scrap_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        List<Scraplist> data = [];
        print('data scrap length is ${res["data"].length}');
        //  print('data is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final Scraplist orderresult = Scraplist(
            journal_id: res['data'][i]['line_id'].toString(),
            journal_no: res['data'][i]['journal_no'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          data.add(orderresult);
        }

        listscrap = data;
        _isLoading = false;

        notifyListeners();

        return listscrap;
      }
    } catch (_) {
      print('has server data error');
    }
  }

  Future<bool> cancelScrap(String line_id) async {
    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";
    bool _iscomplated = false;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    final Map<String, dynamic> prodrecData = {
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'id': line_id,
    };
    print('data will cancel scrap is ${prodrecData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_cancel_scrap),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(prodrecData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data cancel scrap is  ${res["data"]}');
        if (res != null) {}
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }
}
