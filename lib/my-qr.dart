import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner_generator/about-us.dart';
import 'package:qr_scanner_generator/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQR extends StatefulWidget {
  const MyQR({super.key});

  @override
  State<MyQR> createState() => _MyQRState();
}

class _MyQRState extends State<MyQR> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController organizationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('My QR'),
        backgroundColor: Colors.cyan[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text('Share your contact info via QR',style: TextStyle(fontWeight: FontWeight.w600),),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Phone Number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an E-mail address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: organizationController,
                      decoration:
                          InputDecoration(labelText: 'Organization Name'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        backgroundColor: Colors.cyan[200],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          String qrData = formatQRData();
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setBool('checkIn', true);
                          prefs.setString('qrData', qrData);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DisplayMyQRCode(qrData: qrData),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Generate QR Code',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Only Enter Data you want to Share'),
                    Text('Next Time you open My QR, your contact QR will be displayed.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatQRData() {
    return 'Full Name: ${nameController.text}\n'
        'Organization: ${organizationController.text}\n'
        'E-mail: ${emailController.text}\n'
        'Phone Number: ${phoneController.text}';
  }
}

class DisplayMyQRCode extends StatelessWidget {
  final String qrData;

  DisplayMyQRCode({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 200,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                },
                leading: Icon(Icons.home),
                title: Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.history),
                title: Text(
                  'History',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () => HomePage(),
                leading: Icon(Icons.qr_code_scanner),
                title: Text(
                  'Scan QR',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () => HomePage(),
                leading: Icon(Icons.image),
                title: Text(
                  'Scan from Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () {},
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ));
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
        backgroundColor: Colors.cyan[200],
        title: Text('My QR Code'),
        // popup menu button
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.save_alt),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Save")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete")
                  ],
                ),
              ),
            ],
            offset: Offset(0, 50),
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirm Delete'),
                      content:
                          Text('Are you sure you want to delete this QR code?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async{
                            var prefs = await SharedPreferences.getInstance();
                            prefs.setBool('checkIn', false);
                            await prefs.remove('qrData');
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('Delete'),
                        )

                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white30, width: 10),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: QrImageView(
                data: qrData,
                size: 300,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
