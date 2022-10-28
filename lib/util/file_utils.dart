// Initialize file
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> initFile(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File file = File('$path/$fileName');
  //create file if don't exist
  if (!(await file.exists())) {
    await file.create();
  }
  return file;
}