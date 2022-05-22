import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/models/note_model.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:flutter/cupertino.dart';

class FolderModel {
  String folderId;
  String folderName;
  String folderCreationDate;
  List<dynamic> questions;
  List<dynamic> notes;

  FolderModel({
    @required this.folderId,
    @required this.folderName,
    @required this.folderCreationDate,
    @required this.questions,
    @required this.notes,
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
    notes = [];
    for (var note in queryDocumentSnapshot.get('notes')) {
      var noteFromJson = NoteModel.fromJson(note);
      // notes.add(noteFromJson.toMap());
      notes.add(noteFromJson);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'folderId': folderId,
      'folderName': folderName,
      'folderCreationDate': folderCreationDate,
      'questions': questions,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return '$folderId $folderName $folderCreationDate $questions $notes}';
  }
}
