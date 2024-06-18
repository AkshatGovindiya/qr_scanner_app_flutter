import 'package:flutter/material.dart';
import 'package:qr_scanner_generator/generate_new_qr.dart';

class ListOfQRTypePage extends StatefulWidget {
  const ListOfQRTypePage({super.key});

  @override
  State<ListOfQRTypePage> createState() => _ListOfQRTypePageState();
}

class _ListOfQRTypePageState extends State<ListOfQRTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Type of QR'),
        backgroundColor: Colors.cyan[200],
      ),
      body: ListView(
        children: [
          getQRType(context, Icons.person, 'Contact'),
          getQRType(context, Icons.location_on, 'Location'),
          getQRType(context, Icons.sms_outlined, 'SMS'),
          getQRType(context, Icons.phone, 'Phone Number'),
          getQRType(context, Icons.link, 'URL'),
        ],
      ),
    );
  }
}

Widget getQRType(BuildContext context, IconData icon, String qrName) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerateQRCode(
            qrType: qrName,
          ),
        ),
      );
    },
    child: Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, size: 30),
            SizedBox(
              width: 20,
            ),
            Text(
              qrName,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.00),
            )
          ],
        ),
      ),
    ),
  );
}
