import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:flutter/cupertino.dart';

class FolderModel {
  String folderId;
  String folderName;
  String folderCreationDate;
  List<dynamic> questions;

  FolderModel({
    @required this.folderId,
    @required this.folderName,
    @required this.folderCreationDate,
    @required this.questions,
  });

  FolderModel.fromJson(QueryDocumentSnapshot queryDocumentSnapshot) {
    folderId = queryDocumentSnapshot.get('folderId');
    folderName = queryDocumentSnapshot.get('folderName');
    folderCreationDate = queryDocumentSnapshot.get('folderCreationDate');
    // questions = queryDocumentSnapshot.get('questions');
    questions = [];
    for (var question in queryDocumentSnapshot.get('questions')) {
      var questionFromJson = QuestionModel.fromJson(question);
      questions.add(questionFromJson.toMap());
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'folderId': folderId,
      'folderName': folderName,
      'folderCreationDate': folderCreationDate,
      'questions': questions,
    };
  }

  @override
  String toString() {
    return 'FolderModel{folderId: $folderId, folderName: $folderName, folderCreationDate: $folderCreationDate, questions: $questions}';
  }
}
