import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> pdfdoc() async {

  final Document pdf = Document();

  pdf.addPage(Page(
      pageFormat: PdfPageFormat.legal,
      build: (Context context) {
        return Center(
          child: Text("Hello World"),
          
        ); // Center
      })); // Page

  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  final File file = File('"$tempPath/example.pdf');
  file.writeAsBytesSync(pdf.save());
}