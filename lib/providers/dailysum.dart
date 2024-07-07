import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:ice_app_new/models/balanceinlist.dart';

import 'package:ice_app_new/models/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailysumData with ChangeNotifier {
  final String url_to_balance_in_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getbalancein";

  final String url_to_prodrec_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getprodrec";
  final String url_to_scrap_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getscrap";
  final String url_to_count_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getcounting";
  final String url_to_cash_qty_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getcashqty";

  final String url_to_credit_qty_list =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getcreditqty";

  final String url_to_calclose_shift =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/calcloseshift";
  final String url_to_transfer =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/gettransferqty";
  final String url_to_repack =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getrepackqty";

  final String url_to_reprocesscar =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getreprocesscarqty";

  final String url_to_refill =
      //  "http://192.168.1.120/icesystembp/frontend/web/api/product/list";
      "http://103.253.73.108/icesystemdindang/frontend/web/api/dailysummary/getrefillqty";

  List<BalanceinList> _balancein;
  List<BalanceinList> get listbalancein => _balancein;

  List<BalanceinList> _prodrec;
  List<BalanceinList> get listprodrec => _prodrec;

  List<BalanceinList> _scrap;
  List<BalanceinList> get listscrap => _scrap;

  List<BalanceinList> _counting;
  List<BalanceinList> get listcounting => _counting;

  List<BalanceinList> _cashqty;
  List<BalanceinList> get listcashqty => _cashqty;

  List<BalanceinList> _creditqty;
  List<BalanceinList> get listcreditqty => _creditqty;

  List<BalanceinList> _transferqty;
  List<BalanceinList> get listtransferqty => _transferqty;

  List<BalanceinList> _repackqty;
  List<BalanceinList> get listrepackqty => _repackqty;

  List<BalanceinList> _reprocesscarqty;
  List<BalanceinList> get listreprocesscarqty => _reprocesscarqty;

  List<BalanceinList> _refillqty;
  List<BalanceinList> get listrefillqty => _refillqty;

  bool _isLoading = false;

  int _id = 0;
  int get idProduct => _id;

  set idProduct(int val) {
    _id = val;
    notifyListeners();
  }

  set listbalancein(List<BalanceinList> val) {
    _balancein = val;
    notifyListeners();
  }

  set listprodrec(List<BalanceinList> val) {
    _prodrec = val;
    notifyListeners();
  }

  set listscrap(List<BalanceinList> val) {
    _scrap = val;
    notifyListeners();
  }

  set listcounting(List<BalanceinList> val) {
    _counting = val;
    notifyListeners();
  }

  set listcashqty(List<BalanceinList> val) {
    _cashqty = val;
    notifyListeners();
  }

  set listcreditqty(List<BalanceinList> val) {
    _creditqty = val;
    notifyListeners();
  }

  set listtransferqty(List<BalanceinList> val) {
    _transferqty = val;
    notifyListeners();
  }

  set listrepackqty(List<BalanceinList> val) {
    _repackqty = val;
    notifyListeners();
  }

  set listreprocesscarqty(List<BalanceinList> val) {
    _reprocesscarqty = val;
    notifyListeners();
  }

  set listrefillqty(List<BalanceinList> val) {
    _refillqty = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  Future<dynamic> fetBalancein() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    //  print(filterData);
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_balance_in_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('balance data is ${res["data"]}');

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
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listbalancein = data;
        _isLoading = false;
        notifyListeners();
        return listbalancein;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetProdrec() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    print('prod rec is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_prodrec_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('prodrec data is ${res["data"]}');

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
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listprodrec = data;
        _isLoading = false;
        notifyListeners();
        return listprodrec;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetScrap() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    //  print(filterData);
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_scrap_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('balance data is ${res["data"]}');

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
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listscrap = data;
        _isLoading = false;
        notifyListeners();
        return listscrap;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetCounting() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    //  print(filterData);
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_count_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('balance data is ${res["data"]}');

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
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listcounting = data;
        _isLoading = false;
        notifyListeners();
        return listcounting;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetCashQty() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    print('cash qty data is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_cash_qty_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        //print('cash qty data is ${res["data"]}');

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
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listcashqty = data;
        _isLoading = false;
        notifyListeners();
        return listcashqty;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetCreditQty() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    print('prod rec is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_credit_qty_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('prodrec data is ${res["data"]}');

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

        // listcreditqty.clear();

        for (var i = 0; i < res['data'].length; i++) {
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listcreditqty = data;
        _isLoading = false;
        notifyListeners();
        return listcreditqty;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetTransferQty() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    print('prod rec is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_transfer),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('transfer data is ${res["data"]}');

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
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listtransferqty = data;
        _isLoading = false;
        notifyListeners();
        return listtransferqty;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetRepackQty() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    print('prod rec is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_repack),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('repack data is ${res["data"]}');

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
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listrepackqty = data;
        _isLoading = false;
        notifyListeners();
        return listrepackqty;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetReprocesscarQty() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    print('reprocesscar is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_repack),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('reprocesscar data is ${res["data"]}');
        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listreprocesscarqty = data;
        _isLoading = false;
        notifyListeners();
        return listreprocesscarqty;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<dynamic> fetRefillQty() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    print('refill is ${filterData}');
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_refill),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('refill data is ${res["data"]}');

        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }

        for (var i = 0; i < res['data'].length; i++) {
          final BalanceinList productresult = BalanceinList(
            product_id: res['data'][i]['product_id'].toString(),
            product_code: res['data'][i]['product_code'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${productresult}');
          data.add(productresult);
        }

        listrefillqty = data;
        _isLoading = false;
        notifyListeners();
        return listrefillqty;
      } else {
        print('not status 200');
      }
    } catch (_) {
      print('call api error');
    }
  }

  Future<bool> fetCalcloseshift() async {
    _isLoading = true;
    notifyListeners();

    String _user_id = "";
    String _company_id = "";
    String _branch_id = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _routeid = '';
    String _issue_date = new DateTime.now().toString();
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
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

    //  print(filterData);
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_calclose_shift),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        print('api ok');
        Map<String, dynamic> res = json.decode(response.body);
        List<BalanceinList> data = [];
        // print('data length is ${res["data"].length}');
        print('balance data is ${res["data"]}');

        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return true;
        }

        return true;
      } else {
        print('not status 200');
        return false;
      }
    } catch (_) {
      print('call api error');
      return false;
    }
  }
}
