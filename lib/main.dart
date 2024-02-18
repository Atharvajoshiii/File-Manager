import 'package:filemanager/pages/folderlistpage.dart';
import 'package:filemanager/services/folderservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<FolderService>(create: (_) => FolderService()),
        ],
        child: FolderListPage(),
      ),
    );
  }
}
