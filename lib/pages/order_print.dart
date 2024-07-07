import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:barcode_widget/barcode_widget.dart' as qrCode;
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:image/image.dart' as imageLib;
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class OrderPrintPage extends StatefulWidget {
  @override
  _OrderPrintPageState createState() => _OrderPrintPageState();
}

class _OrderPrintPageState extends State<OrderPrintPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final ScreenshotController screenshotController = ScreenshotController();

//sunmi
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

// end
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bindingPrinter().then((bool isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind;
      });
    });
  }

  /// must binding ur printer at first init in app
  Future<bool> _bindingPrinter() async {
    final bool result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  Widget slip2() {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Text("hello"),
          ],
        ),
        Row(
          children: [
            Text("world"),
          ],
        ),
      ],
    );
  }

  Widget slip() {
    // final qrCode = QrCode(4, QrErrorCorrectLevel.L)
    //   ..addData('Hello, world in QR form!');
    // final qrImage = QrImage(qrCode);
    return SizedBox(
      width: 250,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  "QRCODE",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Expanded(
                child: Text(
                  'น้ำแข็ง',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                'เลขที่ AZ210001',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
              Expanded(
                  child: Text(
                'วันที่ 23/06/2021 16:11',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                'ลูกค้า AZ001 อเมซอน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'รายการ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Text(
                  'จำนวน',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ราคา',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'รวม',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'PB หลอดใหญ่',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                    child: Text(
                  '20',
                  style: TextStyle(fontSize: 14),
                )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '5',
                    style: TextStyle(fontSize: 14),
                  ),
                )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '100',
                    style: TextStyle(fontSize: 14),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double qrSize = 200;
    final uiImg = QrPainter(
      data: "1234",
      version: QrVersions.auto,
      gapless: false,
    ).toImageData(qrSize);

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Print preview'),
        ),
        body: Column(
          children: <Widget>[
            slip(),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Print Slip'),
                      //onPressed: () => printTicket(),
                      onPressed: () => printTicketFromSunmi(),
                      // onPressed: () async {
                      //   final image =
                      //       await screenshotController.captureFromWidget(slip2());
                      //   if (image == null) {
                      //     print('no screenshort');
                      //   } else {
                      //     print('have screenshort');
                      //     printTicket2(image);
                      //     //printImageCanvas('');
                      //     //printImageByPath('Y');
                      //     //await _readPDFFile();
                      //     // var x = await saveImage(image);
                      //     // print('saved image is ');
                      //     // if (x != null) {
                      //     //   printImage(x);
                      //     //   print("ok");
                      //     // }

                      //     //await _readPDFFile();

                      //     // printRecipientPaper();
                      //   }
                      // },
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Print Slip'),
                      onPressed: () async {
                        await SunmiPrinter.cut();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List image) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(image, name: name);
    // printImageByPath(result['filePath']);
    // printImage(result['filePath']);
    // return result['filePath'];
    if (result != null) {
      return name;
    }
  }

  Future<String> saveImage2(Uint8List image) async {
    await [Permission.storage].request();
    String dir = (await getApplicationDocumentsDirectory()).path;
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    // final name = 'screenshot_$time';
    String path = '$dir/test.png';
    new File(path).writeAsBytes(image);
    printImageByPath2('');
    //printImage(result['filePath']);
    return "ok";
  }

  Future printImage(String imagename) async {
    await [Permission.storage].request();
    String dir = (await getApplicationDocumentsDirectory()).path;
    // final time = DateTime.now()
    //     .toIso8601String()
    //     .replaceAll('.', '-')
    //     .replaceAll(':', '-');
    // final name = 'screenshot_$time';
    // String fullPath = '$dir/VP.png';
    // File file = File(fullPath);
    // await file.writeAsBytes(image);
    // setState(() {
    //   pathImage = fullPath;
    //   print('file is ${pathImage}');
    // });
    if (File('/storage/emulated/0/Pictures/${imagename}.jpg').exists() ==
        true) {
      print("this file ok");
    } else {
      print("have no your file");
    }
    print("file name is ${imagename}");
    //var file = new File(imagename);
    String pathImage = '/storage/emulated/0/Pictures/${imagename}.jpg';
    var file = new File('/storage/emulated/0/Pictures/${imagename}.jpg');
    //Image image = decodeImage(file.readAsBytesSync());
    Uint8List bufferx = file.readAsBytesSync();
    Uint8List imageBytes = bufferx.buffer
        .asUint8List(bufferx.offsetInBytes, bufferx.lengthInBytes);
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        //bluetooth.writeBytes(imageBytes);
        bluetooth.printImageBytes(imageBytes);
        //bluetooth.printImage(pathImage);
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  Future<List<int>> _readPDFFileNew(String path) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${path}');
      final bytes = File(file.path).readAsBytesSync();
      return bytes;
    } catch (e) {
      print("Couldn't read file");
    }
  }

  Future printImageByPath(String image) async {
    await [Permission.storage].request();
    String dir = (await getApplicationDocumentsDirectory()).path;
    // image =
    //     '/storage/emulated/0/Pictures/screenshot_2023-05-04T18-26-14-706573.jpg';
    print('dir is ${dir}');
    //final filename = 'logo_bp_new.png';
    final filename = 'wifi_ques.pdf';
    var bytes = await rootBundle.load('assets/$filename');

    writeToFile2(bytes, '${dir}/${filename}');
    String fullPath = '${dir}/${filename}';

    // Uint8List imageBytes =
    //     bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    // final File file = File('${dir}/${filename}');
    // final bytesx = File(file.path).readAsBytesSync();

    List<int> bytesx = await _readPDFFileNew(fullPath);
    // print(bytesx);
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        //bluetooth.printImage(fullPath);
        //bluetooth.printImageBytes(bytesx);

        bluetooth.writeBytes(bytesx);
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });

    // final File file = File('${fullPath}');
    // if (file != null) {
    //   final bytesx = File(file.path).readAsBytesSync();
    //   print('file for find is ${file.path}');
    //   print(bytesx);
    //   // image =
    //   //     '/storage/emulated/0/Pictures/screenshot_2023-05-04T18-26-14-706573.jpg';
    //   bluetooth.isConnected.then((isConnected) {
    //     if (isConnected) {
    //       // bluetooth.printImage(fullPath);
    //       bluetooth.printImageBytes(bytesx);
    //       bluetooth.printNewLine();
    //       bluetooth.paperCut();
    //     }
    //   });
    // } else {
    //   print("not found file to read byte");
    // }
  }

  Future printImageByPath2(String image) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    // image =
    //     '/storage/emulated/0/Pictures/screenshot_2023-05-04T18-26-14-706573.jpg';
    print('dir is ${dir}');
    final filename = 'test.png';
    String fullPath = '$dir/$filename';
    // image =
    //     '/storage/emulated/0/Pictures/screenshot_2023-05-04T18-26-14-706573.jpg';
    bluetooth.isConnected.then((isConnected) {
      print('filename is ${fullPath}');
      if (isConnected) {
        bluetooth.printImage(fullPath);
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  Future _readPDFFile() async {
    await [Permission.storage].request();
    // try {
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // String dir = (await getTemporaryDirectory()).path;
    // final filename = 'wifi_ques.pdf';
    // var bytes = await rootBundle.load('assets/${filename}');
    // // print('dir is ${dir}');

    // Uint8List imageBytes =
    //     bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    // final imageBytes = await imagePathToUint8List('assets/wifi_ques.pdf');
    // await bluetooth.printImageBytes(imageBytes);
    // await bluetooth.paperCut();

    //await bluetooth.printImageBytes(imageBytes);
    // writeToFile(bytes, '$dir/$filename');

    // final File file = File('$dir/$filename');
    // final bytesx = File(file.path).readAsBytesSync();

    // final output = await getTemporaryDirectory();

    // final path = "${dir}/temp01.pdf";
    // print('new path is ${path}');
    // if (writeToFile2(bytes, '$path') != null) {
    //   final File file = new File('$path');
    //   final bytesx = File(file.path).readAsBytesSync();

    //   bluetooth.isConnected.then((isConnected) {
    //     if (isConnected) {
    //       bluetooth.printImageBytes(bytesx);
    //       // bluetooth.printImage(pathImage);
    //       bluetooth.printNewLine();
    //       bluetooth.paperCut();
    //     }
    //   });
    // } else {
    //   print('cannot create file');
    // }
    // } catch (e) {
    //   print("Couldn't read file");
    // }
  }

  Future<Uint8List> imagePathToUint8List(String path) async {
//converting to Uint8List to pass to printer

    ByteData data = await rootBundle.load(path);
    Uint8List imageBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return imageBytes;
  }

  //write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  //write to app path 2
  Future<void> writeToFile2(ByteData data, String path) async {
    final buffer = data.buffer;
    return await new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future printImageCanvas(String imagename) async {
    final imageBytes = await _generateImageFromString(
      'hello my name is niran',
      TextAlign.center,
    );
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printImageBytes(imageBytes);
      }
    });
  }

  Future<Uint8List> _generateImageFromString(
    String text,
    ui.TextAlign align,
  ) async {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = Canvas(
        recorder,
        Rect.fromCenter(
          center: Offset(0, 0),
          width: 450,
          height: 400, // cheated value, will will clip it later...
        ));
    TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: ui.FontWeight.bold,
      ),
      text: text,
    );
    TextPainter tp = TextPainter(
        text: span,
        maxLines: 3,
        textAlign: align,
        textDirection: TextDirection.ltr);
    tp.layout(minWidth: 550, maxWidth: 550);
    tp.paint(canvas, const Offset(0.0, 0.0));
    var picture = recorder.endRecording();
    final pngBytes = await picture.toImage(
      tp.size.width.toInt(),
      tp.size.height.toInt() - 2, // decrease padding
    );
    final byteData = await pngBytes.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

/////////////////// new
  ///
  Future<List<int>> _readPDFFilex() async {
    Uint8List bytes;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      // final filename = 'wifi_ques.pdf';
      // var bytes = await rootBundle.load('assets/$filename');
      print('path is ${directory.path}/wifi_ques.pdf');
      final File file = File('${directory.path}/wifi_ques.pdf');
      final bytes = File(file.path).readAsBytesSync();
    } catch (e) {
      print("Couldn't read file");
    }
    return bytes;
  }

  Future<void> printRecipientPaper() async {
    print("start");
    String isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await _readPDFFilex();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  void printTicket() async {
    //String mac = "DC:0D:30:CD:D1:21";
    String mac = "00:11:22:33:44:55";
    //String mac = "86:67:7a:00:6b:bd";
    //String mac = "86:67:7A:00:6B:BD";
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);

    print("bluetooth status is ${result}");
    screenshotController
        .captureFromWidget(
      // SizedBox(
      //   width: 140,
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       const Text(
      //         "ทดสอบ",
      //         style: TextStyle(
      //           color: Colors.black,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       const Text(
      //         "TEST",
      //         style: TextStyle(
      //           color: Colors.black,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      SizedBox(
        // width: 250,
        // height: 280,
        width: 199,
        height: 250,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: qrCode.BarcodeWidget(
                      barcode: qrCode.Barcode.qrCode(
                        errorCorrectLevel: qrCode.BarcodeQRCorrectionLevel.high,
                      ),
                      data: 'SO23000001',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'น้ำแข็ง',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'เลขที่ AZ210001',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                )),
                Expanded(
                    child: Text(
                  'วันที่ 23/06/2021',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'ลูกค้า AZ001 อเมซอน',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'รายการ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'จำนวน',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'ราคา',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'รวม',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'PB หลอดใหญ่',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '20',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '5',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '100',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'PB หลอดเล็ก',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '20',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '5',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '100',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'M โม่',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '20',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '5',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '100',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'รวมจำนวน',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '60',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '300',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'แคชเชียร์.....admin.....',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
      delay: Duration(milliseconds: 20),
    )
        .then((capturedImage) async {
      List<int> bytes = [];
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      bytes += generator.reset();

      final imageLib.Image image = imageLib.decodeImage(capturedImage);
      bytes += generator.image(image);

      // bytes += generator.text('Bold text', styles: PosStyles(bold: true));
      // bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
      // bytes += generator.text('Underlined text',
      //     styles: PosStyles(underline: true), linesAfter: 1);
      // bytes +=
      //     generator.text('Align left', styles: PosStyles(align: PosAlign.left));
      // bytes += generator.text('Align center',
      //     styles: PosStyles(align: PosAlign.center));
      // bytes += generator.text('Align right',
      //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);

      // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
      // bytes += generator.barcode(Barcode.upcA(barData));
      bytes += generator.feed(1);

      print('byte xx is ${bytes}');

      await PrintBluetoothThermal.writeBytes(bytes);
    });
  }

  void printTicket2(Uint8List imagex) async {
    String mac = "DC:0D:30:CD:D1:21";
    //String mac = "86:67:7a:00:6b:bd";
    //String mac = "86:67:7A:00:6B:BD";
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);

    print("bluetooth status is ${result}");
    // await screenshotController
    //     .captureFromWidget(
    //   Container(
    //     padding: EdgeInsets.all(1),
    //     child: SizedBox(
    //       width: 140,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Text('ทดสอบ'),
    //           SizedBox(
    //             height: 20,
    //           ),
    //           const Text('TEST'),
    //         ],
    //       ),
    //     ),
    //   ),
    // )
    //     .then((capturedImage) async {
    //   List<int> bytes = [];
    //   final profile = await CapabilityProfile.load();
    //   final generator = Generator(PaperSize.mm58, profile);
    //   bytes += generator.reset();

    //   final imageLib.Image image = await imageLib.decodePng(imagex);
    //   bytes += generator.image(image);

    //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    //   bytes += generator.barcode(Barcode.upcA(barData));
    //   bytes += generator.feed(1);

    //   print('byte is ${bytes}');

    //   await PrintBluetoothThermal.writeBytes(bytes);
    // });
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();

    final imageLib.Image image = await imageLib.decodePng(imagex);
    bytes += generator.image(image);

    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.feed(1);

    print('byte is ${bytes}');

    await PrintBluetoothThermal.writeBytes(bytes);
  }

  void printTicket3() async {
    String mac = "DC:0D:30:CD:D1:21";
    //String mac = "86:67:7a:00:6b:bd";
    //String mac = "86:67:7A:00:6B:BD";
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);

    print("bluetooth status is ${result}");
    // await screenshotController
    //     .captureFromWidget(
    //   Container(
    //     padding: EdgeInsets.all(1),
    //     child: SizedBox(
    //       width: 140,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Text('ทดสอบ'),
    //           SizedBox(
    //             height: 20,
    //           ),
    //           const Text('TEST'),
    //         ],
    //       ),
    //     ),
    //   ),
    // )
    //     .then((capturedImage) async {
    //   List<int> bytes = [];
    //   final profile = await CapabilityProfile.load();
    //   final generator = Generator(PaperSize.mm58, profile);
    //   bytes += generator.reset();

    //   final imageLib.Image image = await imageLib.decodePng(imagex);
    //   bytes += generator.image(image);

    //   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    //   bytes += generator.barcode(Barcode.upcA(barData));
    //   bytes += generator.feed(1);

    //   print('byte is ${bytes}');

    //   await PrintBluetoothThermal.writeBytes(bytes);
    // });
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();

    bytes += generator.row([
      PosColumn(
        text: 'สินค้า',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'ราคา',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'จำนวน',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.feed(1);

    print('byte is ${bytes}');

    await PrintBluetoothThermal.writeBytes(bytes);
  }

  void printTicketFromSunmi() async {
    // //String mac = "DC:0D:30:CD:D1:21";
    // String mac = "00:11:22:33:44:55";
    // //String mac = "86:67:7a:00:6b:bd";
    // //String mac = "86:67:7A:00:6B:BD";
    // final bool result =
    //     await PrintBluetoothThermal.connect(macPrinterAddress: mac);

    print("sunmi connect is ${printBinded.toString()}");
    screenshotController
        .captureFromWidget(
      // SizedBox(
      //   width: 140,
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       const Text(
      //         "ทดสอบ",
      //         style: TextStyle(
      //           color: Colors.black,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       const Text(
      //         "TEST",
      //         style: TextStyle(
      //           color: Colors.black,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      Container(
        // width: 250,
        // height: 280,
        color: Colors.white,
        width: 193,
        height: 250,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: qrCode.BarcodeWidget(
                      barcode: qrCode.Barcode.qrCode(
                        errorCorrectLevel: qrCode.BarcodeQRCorrectionLevel.high,
                      ),
                      data: 'SO23000001',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'น้ำแข็ง',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'เลขที่ AZ210001',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                )),
                Expanded(
                    child: Text(
                  'วันที่ 23/06/2021',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'ลูกค้า AZ001 อเมซอน',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'รายการ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'จำนวน',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'ราคา',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'รวม',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'PB หลอดใหญ่',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '20',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '5',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '100',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'PB หลอดเล็ก',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '20',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '5',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '100',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'M โม่',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '20',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '5',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '100',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'รวมจำนวน',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '60',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '300',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  'แคชเชียร์.....admin.....',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
      delay: Duration(milliseconds: 30),
    )
        .then((capturedImage) async {
      print('byte uint8list is ${capturedImage}');
      await SunmiPrinter.initPrinter();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.printImage(capturedImage);
      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.exitTransactionPrint(true);
    });
  }
}
