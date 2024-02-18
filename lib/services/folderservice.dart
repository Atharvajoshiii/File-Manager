import 'dart:convert';
import 'dart:io';

import 'package:filemanager/filemodel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FolderService extends ChangeNotifier {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/folders.json');
  }

  Future<List<Folder>> readFolders() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Folder.fromJson(json)).toList().cast<Folder>(); // cast to Folder
    } catch (e) {
      return [];
    }
  }

  Future<File> writeFolders(List<Folder> folders) async {
    final file = await _localFile;
    final List<dynamic> jsonList = folders.map((folder) => folder.toJson()).toList();
    final jsonString = json.encode(jsonList);
    return file.writeAsString(jsonString);
  }

  Future<File> addFolder(Folder folder) async {
    final folders = await readFolders();
    folders.add(folder);
    return writeFolders(folders);
  }

  Future<File> removeFolder(Folder folder) async {
    final folders = await readFolders();
    final index = folders.indexWhere((f) => f.name == folder.name);
    if (index != -1) {
      folders.removeAt(index);
    }
    return writeFolders(folders);
  }

  Future<File> updateFolder(Folder oldFolder, Folder newFolder) async {
    final folders = await readFolders();
    final index = folders.indexOf(oldFolder);
    if (index != -1) {
      folders[index] = newFolder;
    }
    return writeFolders(folders);
  }
}
