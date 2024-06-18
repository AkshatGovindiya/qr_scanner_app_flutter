import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateQRCode extends StatefulWidget {
  final String qrType;

  GenerateQRCode({required this.qrType});

  @override
  _GenerateQRCodeState createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        title: Text(
          'Generate QR for ${widget.qrType}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  
          child: Column(
            children: [
              _buildFields(),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: Colors.cyan[200],
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    String qrData = _formatQRData(widget.qrType, _formData);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayQRCode(qrData: qrData)),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFields() {
    switch (widget.qrType) {
      case 'Contact':
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _formData['name'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
              onSaved: (value) {
                _formData['phone'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (value) {
                _formData['email'] = value;
              },
            ),
            // Add more fields as required
          ],
        );
      case 'Location':
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Latitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a latitude';
                }
                return null;
              },
              onSaved: (value) {
                _formData['latitude'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Longitude'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a longitude';
                }
                return null;
              },
              onSaved: (value) {
                _formData['longitude'] = value;
              },
            ),
          ],
        );
      case 'SMS':
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
              onSaved: (value) {
                _formData['phone'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Message'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
              onSaved: (value) {
                _formData['message'] = value;
              },
            ),
          ],
        );
      case 'Phone Number':
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
              onSaved: (value) {
                _formData['phone'] = value;
              },
            ),
          ],
        );
      case 'URL':
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a URL';
                }
                return null;
              },
              onSaved: (value) {
                _formData['url'] = value;
              },
            ),
          ],
        );
      default:
        return Center(child: Text('Invalid QR Type'));
    }
  }

  String _formatQRData(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'Contact':
        return 'NAME : ${data['name']}\n'
            'TELEPHONE : ${data['phone']}\n'
            'EMAIL : ${data['email']}\n';
      case 'Location':
        return 'geo:${data['latitude']},${data['longitude']}';
      case 'SMS':
        return 'SMS:${data['phone']}:${data['message']}';
      case 'Phone Number':
        return 'PhoneNumber:${data['phone']}';
      case 'URL':
        return 'https://${data['url']}';
      default:
        return 'Invalid QR Type';
    }
  }
}

class DisplayQRCode extends StatefulWidget {
  final String qrData;

  DisplayQRCode({required this.qrData});

  @override
  State<DisplayQRCode> createState() => _DisplayQRCodeState();
}

class _DisplayQRCodeState extends State<DisplayQRCode> {
  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        title: Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _qrKey,
              child: QrImageView(
                data: widget.qrData,
                size: 200,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                var url = widget.qrData;
                try {
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                }
                catch (e){
                  _showSnackbar('Can not launch url $e');
                }
              },
              child: Text(widget.qrData),
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
              onPressed: () => _capturePng(),
              child: Text('Save QR Code',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: Colors.cyan[200],
              ),
              onPressed: () {},
              child: Text('Share QR Code',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
      _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      final whitePaint = Paint()
        ..color = Colors.white;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getExternalStorageDirectory();
      final path = directory?.path;
      String fileName = 'qr_code';
      int i = 1;
      while (await File('$path/$fileName.png').exists()) {
        fileName = 'qr_code_$i';
        i++;
      }

      final file = await File('$path/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      await GallerySaver.saveImage(file.path);

      if (!mounted) return;
      _showSnackbar('QR code saved to gallery');
    } catch (e) {
      _showSnackbar('Failed to save QR Code: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
