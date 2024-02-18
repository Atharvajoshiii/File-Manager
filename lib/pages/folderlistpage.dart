import 'package:filemanager/filemodel.dart';
import 'package:filemanager/pages/filelistpage.dart';
import 'package:filemanager/services/folderservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final folderService = Provider.of<FolderService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Folder List'),
      ),
      body: FutureBuilder<List<Folder>>(
        future: folderService.readFolders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final folders = snapshot.data!;
            return ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                final folder = folders[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileListPage(),
                        ),
                      );
                    },
                    title: Text(folder.name),
                    subtitle: Text(folder.createdAt.toString()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await folderService.removeFolder(folder).then((value){
                          print("folder removed");
                        });
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddFolderDialog(folderService: folderService),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddFolderDialog extends StatefulWidget {
  final FolderService folderService;

  AddFolderDialog({required this.folderService});

  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final _folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Folder'),
      content: TextField(
        controller: _folderNameController,
        decoration: InputDecoration(labelText: 'Folder Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final folderName = _folderNameController.text;
            if (folderName.isNotEmpty) {
              final folder = Folder(name: folderName, createdAt: DateTime.now());
              await widget.folderService.addFolder(folder);
              Navigator.pop(context);
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }
}
