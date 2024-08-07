import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ice_app_new/models/addissuedata.dart';
import 'package:ice_app_new/models/issueitemhistory.dart';

import 'package:ice_app_new/models/issueitems.dart';
import 'package:ice_app_new/models/reviewload.dart';
import 'package:ice_app_new/models/routeolestock.dart';
import 'package:ice_app_new/models/transferproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueData with ChangeNotifier {
  final String url_to_issue_list_open =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/checkopen";

  final String url_to_issue_list =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/list2";
  final String url_to_oldstockroute_list =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/oldstockroute";
  final String url_to_oldstockroute_history_list =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/carissuehistory";
  final String url_to_user_confirm =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/issueconfirm2";

  final String url_to_user_confirmvp18 =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/issueconfirm2vp18";

  final String url_to_user_confirm_cancel =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/issueconfirmcancel";

  final String url_to_add_product_issue =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/createissuebp";
  final String url_to_cancel_issue_car =
      "http://103.253.73.108/icesystemdindang/frontend/web/api/journalissue/cancelissuecar";

  List<Issueitems> _issue;
  List<Issueitems> get listissue => _issue;
  List<RouteOldStock> _oldstock;
  List<RouteOldStock> get listoldstock => _oldstock;
  List<ReviewLoadData> _reviewload;
  List<ReviewLoadData> get listreview => _reviewload;

  List<IssueitemHistory> _issuehistory;
  List<IssueitemHistory> get listissuehistory => _issuehistory;

  bool _isLoading = false;
  bool _isApicon = false;

  List<TransferProduct> _transferProducts;
  List<TransferProduct> get transferproductitems => _transferProducts;

  String _issueno_after_save = '';
  String get issueno_after_save => _issueno_after_save;

  //int _avl_qty = 0;
  int _id = 0;
  int _transferouttotal = 0;
  bool _hasissue_open = false;
  int _user_confirm = 0;

  bool get hasissue_open => _hasissue_open;
  int get idIssue => _id;

  int get userconfirm => _user_confirm;
  set userconfirm(int val) {
    _user_confirm = val;
    notifyListeners();
  }

  set issueno_after_save(String order_no) {
    _issueno_after_save = order_no;
  }

  set idIssue(int val) {
    _id = val;
    notifyListeners();
  }

  set listissue(List<Issueitems> val) {
    _issue = val;
    notifyListeners();
  }

  set listissuehistory(List<IssueitemHistory> val) {
    _issuehistory = val;
    notifyListeners();
  }

  set listoldstock(List<RouteOldStock> val) {
    _oldstock = val;
    notifyListeners();
  }

  set listreview(List<ReviewLoadData> val) {
    _reviewload = val;
    notifyListeners();
  }

  set transferproductitems(List<TransferProduct> val) {
    _transferProducts = val;
    notifyListeners();
  }

  set hasissue_open(bool val) {
    _hasissue_open = val;
    notifyListeners();
  }

  bool get is_loading {
    return _isLoading;
  }

  bool get is_apicon {
    return _isApicon;
  }

  double get totalAmount {
    double total = 0.0;
    listissue.forEach((paymentitem) {
      total += double.parse(paymentitem.avl_qty);
      // double old_qty = getOldqty(paymentitem.product_id);
      // total = total + old_qty;
    });
    return total;
  }

  double getOldqty(String product_id) {
    double old_qty = 0.0;
    listoldstock.forEach((element) {
      if (element.product_id == product_id) {
        old_qty = double.parse(element.qty);
      }
    });
    return old_qty;
  }

  Future<Null> resetqty() {
    _transferouttotal = 0;
  }

  double get transferouttotal {
    double total = 0;
    _transferProducts.forEach((item) {
      total += double.parse(item.qty);
    });
    return total;
  }

  Future<bool> fetIssueitemopen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _issue_date = new DateTime.now().toString();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'issue_date': _issue_date
    };
    print(filterData);
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_issue_list_open),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);

        print('data customer length is ${res["data"].length}');
        print('data has new issue is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        String has_record = '';
        String has_status = '';

        List<ReviewLoadData> data = [];

        for (var i = 0; i < res['data'].length; i++) {
          has_record = res['data'][i]['has_record'].toString();
          idIssue = int.parse(res['data'][i]['issue_id'].toString());
          has_status = res['data'][i]['status'].toString();

          final ReviewLoadData issueresult = ReviewLoadData(
            issue_id: res['data'][i]['issue_id'].toString(),
            code: res['data'][i]['code'].toString(),
            name: res['data'][i]['name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          data.add(issueresult);
        }

        print('list is issue ${data}');

        if (has_record == "1" && has_status == "150") {
          hasissue_open = true;
          userconfirm = 0;
        } else {
          hasissue_open = false;
        }
        listreview = data;
        _isLoading = false;
        notifyListeners();
        return hasissue_open;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
    }
  }

  Future<dynamic> fetIssueitems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'issue_date': _issue_date,
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    print(filterData);
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_issue_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<Issueitems> data = [];

        print('data customer length is ${res["data"].length}');
        print('data server is ${res["data"]}');

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
          //  idIssue = int.parse(res['data'][i]['issue_id'].toString());

          if (res['data'][i]['status'].toString() == "150") {
            userconfirm = 0;
          } else if (res['data'][i]['status'].toString() == "2") {
            userconfirm = 1;
          }
          final Issueitems issueresult = Issueitems(
            line_issue_id: res['data'][i]['id'].toString(),
            issue_id: res['data'][i]['issue_id'].toString(),
            issue_no: res['data'][i]['issue_no'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            product_image: res['data'][i]['image'].toString(),
            qty: res['data'][i]['issue_qty'].toString(),
            price: res['data'][i]['price'].toString(),
            avl_qty: res['data'][i]['avl_qty'].toString(),
            issue_status: res['data'][i]['status'].toString(),
          );

          //  print('data from server is ${issueresult}');

          data.add(issueresult);
        }

        listissue = data;

        _isLoading = false;
        notifyListeners();
        return listissue;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
    }
  }

  Future<bool> issueconfirm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _userid = '';
    String _route_id = '';
    if (prefs.getString('user_id') != null) {
      _userid = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> updateData = {
      'user_id': _userid,
      'issue_id': idIssue,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'route_id': _route_id
    };

    print('confirmissue is ${updateData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_user_confirmvp18),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<Issueitems> data = [];

        print('data confirm length is ${res["data"].length}');
        print('data server is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        for (var i = 0; i < res['data'].length; i++) {
          if (res['data'][i]['id'].toString() == "1") {
            return true;
          } else {
            return false;
          }
        }
        // hasissue_open = false;
        return true;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
      return false;
    }
  }

  Future<bool> issueconfirmcancel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _userid = '';
    String _route_id = '';
    if (prefs.getString('user_id') != null) {
      _userid = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
      _route_id = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> updateData = {
      'user_id': _userid,
      'issue_id': idIssue,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'route_id': _route_id
    };

    print('confirmissue is ${updateData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_user_confirm_cancel),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<Issueitems> data = [];

        print('data confirm cancel length is ${res["data"].length}');
        print('data server cancel is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        for (var i = 0; i < res['data'].length; i++) {
          if (res['data'][i]['id'].toString() == "1") {
            return true;
          } else {
            return false;
          }
        }
        return true;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
      return false;
    }
  }

  Future<dynamic> fetTransferitems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _issue_date = new DateTime.now().toString();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'issue_date': _issue_date
    };
    print(filterData);
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_issue_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<TransferProduct> data = [];
        print('data transfer length is ${res["data"].length}');
        print('data server is ${res["data"]}');

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
          final TransferProduct transferitem = TransferProduct(
            id: res['data'][i]['product_id'].toString(),
            code: res['data'][i]['product_name'].toString(),
            name: res['data'][i]['product_name'].toString(),
            qty: '0',
            sale_price: res['data'][i]['price'].toString(),
            avl_qty: res['data'][i]['avl_qty'].toString(),
            issue_ref_id: res['data'][i]['issue_id'].toString(),
          );
          data.add(transferitem);
        }

        transferproductitems = data;
        _isLoading = false;
        notifyListeners();
        return transferproductitems;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
    }
  }

  Future<dynamic> updateTotalUp(String product_id, String qty) {
    _transferProducts.forEach((element) {
      if (product_id == element.id) {
        element.qty = qty;
      }
    });
    notifyListeners();
  }

  Future<dynamic> updateTotalDown(String product_id, String qty) {
    _transferProducts.forEach((element) {
      if (product_id == element.id) {
        element.qty = qty;
      }
    });
    notifyListeners();
  }

  Future<dynamic> fetoldstockroute() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _routeid = '';
    if (prefs.getString('user_id') != null) {
      _routeid = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> filterData = {
      'route_id': _routeid,
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    print(filterData);
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_oldstockroute_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<RouteOldStock> data = [];

        print('data old length is ${res["data"].length}');
        print('data server is ${res["data"]}');

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
          //  idIssue = int.parse(res['data'][i]['issue_id'].toString());

          // if (res['data'][i]['status'].toString() == "150") {
          //   userconfirm = 0;
          // } else if (res['data'][i]['status'].toString() == "2") {
          //   userconfirm = 1;
          // }
          final RouteOldStock oldstockresult = RouteOldStock(
            product_code: res['data'][i]['product_code'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
          );

          //  print('data from server is ${issueresult}');

          data.add(oldstockresult);
        }

        listoldstock = data;

        _isLoading = false;
        notifyListeners();
        return listoldstock;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
    }
  }

  Future<dynamic> fetoldstockrouteHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _user_id = '';
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }
    final Map<String, dynamic> filterData = {
      'user_id': _user_id,
      'company_id': _company_id,
      'branch_id': _branch_id
    };
    print("data for issue history is ${filterData}");
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_oldstockroute_history_list),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<IssueitemHistory> data = [];

        print('data old length is ${res["data"].length}');
        print('data server is ${res["data"]}');

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
          //  idIssue = int.parse(res['data'][i]['issue_id'].toString());

          // if (res['data'][i]['status'].toString() == "150") {
          //   userconfirm = 0;
          // } else if (res['data'][i]['status'].toString() == "2") {
          //   userconfirm = 1;
          // }
          final IssueitemHistory oldstockresult = IssueitemHistory(
            issue_no: res['data'][i]['issue_no'].toString(),
            issue_id: res['data'][i]['issue_id'].toString(),
            line_issue_id: res['data'][i]['line_issue_id'].toString(),
            product_id: res['data'][i]['product_id'].toString(),
            product_name: res['data'][i]['product_name'].toString(),
            qty: res['data'][i]['qty'].toString(),
            route_id: res['data'][i]['route_id'].toString(),
            route_name: res['data'][i]['route_code'].toString(),
            trans_date: res['data'][i]['trans_date'].toString(),
          );

          //  print('data from server is ${issueresult}');

          data.add(oldstockresult);
        }

        listissuehistory = data;

        _isLoading = false;
        notifyListeners();
        return listissuehistory;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
    }
  }

  Future<bool> addProductissue(
    String route_id,
    List<Addissuedata> listdata,
  ) async {
    String _user_id = "";
    String _route_id = "";
    String _company_id = "";
    String _branch_id = "";

    bool _iscomplated = false;

    String _order_date = new DateTime.now().toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_id') != null) {
      _user_id = prefs.getString('user_id');
      //   _route_id = prefs.getString('emp_route_id');
      _company_id = prefs.getString('company_id');
      _branch_id = prefs.getString('branch_id');
    }

    var jsonx = listdata
        .map((e) => {
              'product_id': e.product_id,
              'qty': e.qty,
              'price': e.sale_price,
            })
        .toList();

    final Map<String, dynamic> orderData = {
      'order_date': _order_date,
      'user_id': _user_id,
      'route_id': route_id,
      'company_id': _company_id,
      'branch_id': _branch_id,
      'data': jsonx,
    };
    print('data will save product issue is ${orderData}');
    try {
      http.Response response;
      response = await http.post(Uri.parse(url_to_add_product_issue),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData));

      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        print('data added product issue is  ${res["data"]}');
        if (res != null) {
          issueno_after_save = res["data"][0]["issue_no"];
          print('${res["data"][0]["issue_no"]}');
        }
        _iscomplated = true;
      }
    } catch (_) {
      _iscomplated = false;
      // print('cannot create order');
    }
    return _iscomplated;
  }

  Future<bool> cancelissuecar(String issue_id, String route_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String _company_id = "";
    String _branch_id = "";
    String _issue_date = new DateTime.now().toString();
    String _userid = '';
    String _route_id = '';
    if (prefs.getString('user_id') != null) {
      _userid = prefs.getString('user_id');
    }
    final Map<String, dynamic> updateData = {
      'user_id': _userid,
      'issue_id': issue_id,
      'route_id': route_id,
    };

    print('cancel is ${updateData}');
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse(url_to_cancel_issue_car),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        _isApicon = true;
        Map<String, dynamic> res = json.decode(response.body);
        List<Issueitems> data = [];

        print('data confirm cancel length is ${res["data"].length}');
        print('data server cancel is ${res["data"]}');

        if (res == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (res['data'] == null) {
          _isLoading = false;
          notifyListeners();
          return false;
        }

        for (var i = 0; i < res['data'].length; i++) {
          if (res['data'][i]['message'].toString() == "success") {
            return true;
          } else {
            return false;
          }
        }
        return true;
      }
    } catch (_) {
      _isApicon = false;
      print('cannot connect api.');
      return false;
    }
  }
}
