import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_scanner_generator/about-us.dart';
import 'package:qr_scanner_generator/list_of_qr_code.dart';
import 'package:qr_scanner_generator/my-qr.dart';
import 'package:qr_scanner_generator/scan_qr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrResult = '';
  final ImagePicker _picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 200,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              // ListTile(
              //   onTap: () {},
              //   leading: Icon(Icons.history),
              //   title: Text(
              //     'History',
              //     style: TextStyle(fontWeight: FontWeight.w600),
              //   ),
              // ),
              ListTile(
                onTap: () => scanQR(),
                leading: Icon(Icons.qr_code_scanner),
                title: Text(
                  'Scan QR',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () => pickImageFromGallery(),
                leading: Icon(Icons.image),
                title: Text(
                  'Scan from Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: (){
                  whereTogo();
                },
                leading: Icon(Icons.person_pin_outlined),
                title: Text(
                  'My QR',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
                title: Text(
                  'Setting',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUs(),));
                },
                leading: Icon(Icons.info_outline),
                title: Text(
                  'About Us',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "QR Code Scanner & Generator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        backgroundColor: Colors.cyan[200],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListOfQRTypePage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.cyan,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset('assets/plus.gif', width: 150),
                          SizedBox(
                            height: 10,
                          ),
                          const Text(
                            textAlign: TextAlign.center,
                            'Generate New\n QR code',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => scanQR(),
                child: Card(
                  color: Colors.white,
                  elevation: 20,
                  shadowColor: Colors.cyan,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset('assets/qr-code.gif', width: 150),
                          SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Scan QR code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        'blue', // Color of the scan line
        'Cancel', // Text for the cancel button
        true, // Whether to show the flash icon
        ScanMode.QR, // Scan mode (QR code)
      );

      if (!mounted) return;

      if (qrCode != '-1') {
        // If the scan is successful and not cancelled
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScanResultPage(result: qrCode),
        ));
      } else {
        setState(() {
          qrResult = 'Scan cancelled';
        });
      }
    } on PlatformException {
      setState(() {
        qrResult = 'Failed to scan QR Code';
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        String? qrCode = await QrCodeToolsPlugin.decodeFrom(pickedFile.path);
        if (qrCode != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScanResultPage(result: qrCode),
          ));
        } else {
          setState(() {
            qrResult = 'No QR code found in the image';
          });
        }
      } else {
        setState(() {
          qrResult = 'No image selected';
        });
      }
    } catch (e) {
      setState(() {
        qrResult = 'Failed to pick image: $e';
      });
    }
  }

  void whereTogo() async{
    var prefs = await SharedPreferences.getInstance();
    var isCheckIn = prefs.getBool('checkIn') ?? false;
    var qrData = prefs.getString('qrData') ?? '';

      if(isCheckIn){
        Navigator.push(context,MaterialPageRoute(builder: (context) => DisplayMyQRCode(qrData: qrData),));
      }
      else{
        Navigator.push(context,MaterialPageRoute(builder: (context) => MyQR(),));

      }
  }
}
