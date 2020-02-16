import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

Future<void> pdfdoc() async {


final Uint8List fontData = File('/home/samthekiller/Downloads/flutterprojects/new_project/vaid/vaidya/fonts/open-sans/OpenSans-Regular.ttf').readAsBytesSync();
final Font ttf = Font.ttf(fontData.buffer.asByteData());
  final Document pdf = Document();

  pdf.addPage(Page(
      pageFormat: PdfPageFormat.legal,
      build: (Context context) {
        return Center(
          child: Text("Hello World",style: TextStyle(fontSize: 9, font: ttf)),
          
        ); // Center
      })); // Page

  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  final File file = File('"$tempPath/example.pdf');
  file.writeAsBytesSync(pdf.save());
}