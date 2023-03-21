


import 'package:flutter/material.dart';
//import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class LoadOther extends StatefulWidget {
  const LoadOther({Key? key}) : super(key: key);

  @override
  State<LoadOther> createState() => _LoadOtherState();
}

class _LoadOtherState extends State<LoadOther> {
   String pathPDF = "";
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: ElevatedButton(
          child: Text("Open PDF"),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (_) => const PDFViewerFromUrl(
                  url: 'http://www.leomay.com/upload/file/mmo-20170707165001.pdf',
                ),
              ),)
        ),
      ),
    );}
}
class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pdf_word'),
      ),
      // body: const PDF().fromUrl(
      //   url,
      //   placeholder: (double progress) => Center(child: Text('$progress %')),
      //   errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      // ),
    );
  }
}