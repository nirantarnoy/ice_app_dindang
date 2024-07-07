// import 'package:camera/camera.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:ice_app_new/models/deliveryroute.dart';
import 'package:ice_app_new/page_offline/createorder_new_offline.dart';
import 'package:ice_app_new/page_offline/orderofflinecheckout.dart';
import 'package:ice_app_new/page_offline/orderofflinedetail.dart';
// import 'package:ice_app_new/models/transfer_total.dart';
import 'package:ice_app_new/pages/assetcheck.dart';
import 'package:ice_app_new/pages/carload_review.dart';
import 'package:ice_app_new/pages/checkinpage.dart';
import 'package:ice_app_new/pages/create_scrap.dart';
import 'package:ice_app_new/pages/createorder_boot.dart';
import 'package:ice_app_new/pages/createorder_new.dart';
import 'package:ice_app_new/pages/createorder_new_pos.dart';
import 'package:ice_app_new/pages/createplan.dart';
import 'package:ice_app_new/pages/createproducttransfer.dart';
import 'package:ice_app_new/pages/createtransform.dart';
import 'package:ice_app_new/pages/dailycount.dart';
import 'package:ice_app_new/pages/dailytransfer.dart';
import 'package:ice_app_new/pages/home.dart';
import 'package:ice_app_new/pages/home_offline.dart';
import 'package:ice_app_new/pages/home_pos.dart';
import 'package:ice_app_new/pages/journalissue.dart';
import 'package:ice_app_new/pages/offlinetest.dart';
import 'package:ice_app_new/pages/onhand.dart';
import 'package:ice_app_new/pages/ordercheckout.dart';
import 'package:ice_app_new/pages/ordercheckoutpospage.dart';
import 'package:ice_app_new/pages/orderposdetail.dart';
import 'package:ice_app_new/pages/paymentcheckout.dart';
import 'package:ice_app_new/pages/paymenthistory.dart';
import 'package:ice_app_new/pages/plancheckout.dart';
import 'package:ice_app_new/pages/plandetail.dart';
import 'package:ice_app_new/pages/product_rec.dart';
import 'package:ice_app_new/pages/productissue_history.dart';
import 'package:ice_app_new/pages/productissuecheckout.dart';
import 'package:ice_app_new/pages/productrec_checkout.dart';
import 'package:ice_app_new/pages/productionrec.dart';
import 'package:ice_app_new/pages/producttransfer.dart';
import 'package:ice_app_new/pages/producttransfercheckout.dart';
import 'package:ice_app_new/pages/scrap.dart';
import 'package:ice_app_new/pages/scrapcheckout.dart';
// import 'package:ice_app_new/pages/take_photo.dart';
import 'package:ice_app_new/pages/transferin_review.dart';
import 'package:ice_app_new/pages/transferout_review.dart';
import 'package:ice_app_new/pages/transform.dart';
import 'package:ice_app_new/providers/car.dart';
import 'package:ice_app_new/providers/dailysum.dart';
import 'package:ice_app_new/providers/deliveryroute.dart';
import 'package:ice_app_new/providers/plan.dart';
import 'package:ice_app_new/providers/transferin.dart';
import 'package:ice_app_new/providers/transferout.dart';
import 'package:ice_app_new/sqlite/providers/Offlineitem.dart';
import 'package:ice_app_new/sqlite/providers/customer_price.dart';
import 'package:ice_app_new/sqlite/providers/orderoffline.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'pages/auth.dart';

import 'providers/product.dart';
import 'providers/customer.dart';
import 'providers/user.dart';
import 'providers/order.dart';
import 'providers/issuedata.dart';
import 'providers/paymentreceive.dart';
import 'pages/main_test.dart';

import 'pages/order.dart';
import 'pages/orderdetail.dart';
import 'pages/createorder.dart';
import 'pages/payment.dart';

//import 'pages/photo_cap.dart';

//void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool _isAuthenticated = false;
  String user_login_type = '';

  @override
  void initState() {
    // setState(() {
    //   _isNetworkconnect = false;
    // });
    // _model.autoAuthenticate();
    // _model.userSubject.listen((bool isAuthenticated) {
    //   setState(() {
    //     _isAuthenticated = isAuthenticated;
    //   });
    // });
    _getUserPrefer();
    super.initState();
  }

  // void checkAuthen(UserData userdata) {
  //   userdata.autoAuthenticate();
  //   setState(() {
  //     _isAuthenticated = userdata.is_authenuser;
  //   });
  //   super.initState();
  // }
  void _getUserPrefer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_login_type = prefs.getString("user_type");
      //user_email = prefs.getString("");
    });
  }

  @override
  Widget build(BuildContext context) {
    // final UserData users = Provider.of<UserData>(context);
    // checkAuthen(users);
    print('building main page');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>.value(value: UserData()),
        ChangeNotifierProvider<ProductData>.value(value: ProductData()),
        ChangeNotifierProvider<CustomerData>.value(value: CustomerData()),
        ChangeNotifierProvider<OrderData>.value(value: OrderData()),
        ChangeNotifierProvider<IssueData>.value(value: IssueData()),
        ChangeNotifierProvider<PaymentreceiveData>.value(
            value: PaymentreceiveData()),
        ChangeNotifierProvider<TransferoutData>.value(value: TransferoutData()),
        ChangeNotifierProvider<TransferinData>.value(value: TransferinData()),
        ChangeNotifierProvider<CarData>.value(value: CarData()),
        ChangeNotifierProvider<PlanData>.value(value: PlanData()),
        ChangeNotifierProvider<OfflineitemData>.value(value: OfflineitemData()),
        ChangeNotifierProvider<CustomerpriceData>.value(
            value: CustomerpriceData()),
        ChangeNotifierProvider<OrderOfflineData>.value(
            value: OrderOfflineData()),
        ChangeNotifierProvider<DeliveryRouteData>.value(
            value: DeliveryRouteData()),
        ChangeNotifierProvider<DailysumData>.value(value: DailysumData()),
      ],
      child: Consumer(builder: (context, UserData users, _) {
        // checkAuthen(users);
        users.autoAuthenticate();
        return MaterialApp(
          // debugShowMaterialGrid: true,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch:
                user_login_type == 'pos' ? Colors.green : Colors.lightBlue,
            // accentColor: Colors.lightBlue,
            // buttonColor: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            // accentColor: Colors.amber,
          ),
          // fontFamily: 'Kanit-Regular'),
          home: DoubleBack(
              message: "กดอีกครั้งเพื่อออก",
              //     child: users.is_authenuser ? MainTest() : AuthPage()),
              child: users.is_authenuser ? MainTest() : CheckinPage()),

          routes: {
            OrderPage.routeName: (ctx) => OrderPage(),
            OrderDetailPage.routeName: (ctx) => OrderDetailPage(),
            OrderPosDetailPage.routeName: (ctx) => OrderPosDetailPage(),
            CreateorderPage.routeName: (ctx) => CreateorderPage(),
            CreateorderNewPage.routeName: (ctx) => CreateorderNewPage(),
            CreateorderNewPosPage.routeName: (ctx) => CreateorderNewPosPage(),
            CreateorderBootPage.routeName: (ctx) => CreateorderBootPage(),
            PaymentPage.routeName: (ctx) => PaymentPage(),
            CarloadReviewPage.routeName: (ctx) => CarloadReviewPage(),
            HomePage.routeName: (ctx) => HomePage(),
            HomePosPage.routeName: (ctx) => HomePosPage(),
            PaymentcheckoutPage.routeName: (ctx) => PaymentcheckoutPage(),
            PaymenthistoryPage.routeName: (ctx) => PaymenthistoryPage(),
            OrdercheckoutPage.routeName: (ctx) => OrdercheckoutPage(),
            JournalissuePage.routeName: (ctx) => JournalissuePage(),
            OfflinePage.routeName: (ctx) => OfflinePage(),
            TransferInReviewPage.routeName: (ctx) => TransferInReviewPage(),
            TransferOutReviewPage.routeName: (ctx) => TransferOutReviewPage(),
            AssetcheckPage.routeName: (ctx) => AssetcheckPage(),
            CreateplanPage.routeName: (ctx) => CreateplanPage(),
            PlancheckoutPage.routeName: (ctx) => PlancheckoutPage(),
            PlanDetailPage.routeName: (ctx) => PlanDetailPage(),
            CreateorderNewOfflinePage.routeName: (ctx) =>
                CreateorderNewOfflinePage(),
            OrderofflinecheckoutPage.routeName: (ctx) =>
                OrderofflinecheckoutPage(),
            OrderOfflineDetailPage.routeName: (ctx) => OrderOfflineDetailPage(),
            HomeOfflinePage.routeName: (ctx) => HomeOfflinePage(),
            OrdercheckoutPosPage.routeName: (ctx) => OrdercheckoutPosPage(),
            ProductRecPage.routeName: (ctx) => ProductRecPage(),
            ProductrecCheckoutPage.routeName: (ctx) => ProductrecCheckoutPage(),
            ProductissuecheckoutPage.routeName: (ctx) =>
                ProductissuecheckoutPage(),
            ProductionRecPage.routeName: (ctx) => ProductionRecPage(),
            TransformPage.routeName: (ctx) => TransformPage(),
            CreateTransformPage.routeName: (ctx) => CreateTransformPage(),
            DailycountPage.routeName: (ctx) => DailycountPage(),
            DailytransferPage.routeName: (ctx) => DailytransferPage(),
            OnhandPage.routeName: (ctx) => OnhandPage(),
            ScrapPage.routeName: (ctx) => ScrapPage(),
            CreateScrapPage.routeName: (ctx) => CreateScrapPage(),
            ScrapCheckoutPage.routeName: (ctx) => ScrapCheckoutPage(),
            ProductTransferPage.routeName: (ctx) => ProductTransferPage(),
            ProducttransfercheckoutPage.routeName: (ctx) =>
                ProducttransfercheckoutPage(),
            CreateProductTransferPage.routeName: (ctx) =>
                CreateProductTransferPage(),
            ProductissueHistoryPage.routeName: (ctx) =>
                ProductissueHistoryPage(),
            //TakePictureScreen.routeName: (ctx) => TakePictureScreen(),
          },
        );
      }),
    );
  }
}
