import 'package:flutter/material.dart';

import '../framework/widgets/skywa_appbar.dart';
import '../models/folder_model.dart';

class AddNotesScreen extends StatefulWidget {
  final FolderModel folderModel;

  const AddNotesScreen({Key key, @required this.folderModel}) : super(key: key);

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  FolderModel folderModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SkywaAppBar(appbarText: 'Add Notes'),
      ),
      body: ListView.builder(
        // itemCount: folderModel.,
        itemBuilder: (BuildContext buildContext, int index) {},
      ),
    );
  }
}
