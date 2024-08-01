import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.PageTheme> myPageTheme(PdfPageFormat format, pw.Font font) async {
  final logoImage = pw.MemoryImage((await rootBundle.load("assets/pngs/ogo.png")).buffer.asUint8List());
  return pw.PageTheme(
    margin: const pw.EdgeInsets.symmetric(
      horizontal: 1 * PdfPageFormat.cm,
      vertical: 0.5 * PdfPageFormat.cm,
    ),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
    buildBackground: (context) => pw.FullPage(
      ignoreMargins: true,
      child: pw.Watermark(
        angle: 20,
        child: pw.Opacity(
          opacity: 0.5,
          child: pw.Image(
            alignment: pw.Alignment.center,
            logoImage,
            fit: pw.BoxFit.cover,
          ),
        ),
      ),
    ),
    theme: pw.ThemeData.withFont(
      base: font,
      bold: font,
      italic: font,
      boldItalic: font,
    ),
  );
}

Future<void> saveAsFile(
    final BuildContext context,
    final LayoutCallback build,
    final PdfPageFormat pageFormat,
    ) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  const defaultFileName = 'document.pdf';
  final initialDirectory = appDocDir.path;

  final filePath = await FilePicker.platform.getDirectoryPath() ?? initialDirectory;

  final file = File('$filePath/$defaultFileName');

  await file.writeAsBytes(bytes);

  await OpenFile.open(file.path);
}