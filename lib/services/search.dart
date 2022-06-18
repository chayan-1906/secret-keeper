import 'package:diary_app/models/folder_model.dart';
import 'package:flutter/cupertino.dart';

class Search {
  static List<FolderModel> folderSearch({
    @required String searchText,
    @required List<FolderModel> folders,
  }) {
    List<FolderModel> listToBeReturned = [];
    for (FolderModel folderModel in folders) {
      if (folderModel.folderName
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        listToBeReturned.add(folderModel);
      }
    }
    return listToBeReturned;
  }

  static List noteSearch({
    @required String searchText,
    @required List notes,
  }) {
    List listToBeReturned = [];
    String firebaseStorageBaseUrl = 'https://firebasestorage.googleapis.com/';
    notes.forEach((item) {
      item['noteAnswer'].entries.forEach((MapEntry noteAnswer) {
        // print('28: ${noteAnswer.value.toString().toLowerCase().startsWith(baseUrl)}');
        if (!noteAnswer.value
                .toString()
                .toLowerCase()
                .startsWith(firebaseStorageBaseUrl) &&
            noteAnswer.value
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          print('32: noteAnswer: ${noteAnswer}');
          listToBeReturned.add(item);
        }
      });
    });
    return listToBeReturned;
  }

  static List questionSearch({
    @required String searchText,
    @required List questions,
  }) {
    List listToBeReturned = [];
    questions.forEach((questionModel) {
      if (questionModel['questionText']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          questionModel['questionType']
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
        listToBeReturned.add(questionModel);
      }
    });
    print('listToBeReturned: $listToBeReturned');
    return listToBeReturned;
  }
}
