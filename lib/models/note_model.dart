import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String noteId;
  // List<String> noteAnswers;
  Map<String, dynamic> noteAnswer;
  // bool isRequired;
  String noteCreationDate;
  // String questionType;

  NoteModel({
    this.noteId,
    this.noteAnswer,
    // this.isRequired,
    this.noteCreationDate,
    // this.questionType,
  });

  NoteModel.fromJson(QueryDocumentSnapshot queryDocumentSnapshot) {
    noteId = queryDocumentSnapshot.get('questionId');
    noteAnswer = queryDocumentSnapshot.get('noteAnswer');
    // isRequired = queryDocumentSnapshot.get('isRequired');
    noteCreationDate = queryDocumentSnapshot.get('noteCreationDate');
    // questionType = queryDocumentSnapshot.get('questionType');
    /*return QuestionModel(
      questionId: queryDocumentSnapshot.get('questionId'),
      questionText: queryDocumentSnapshot.get('questionText'),
      isRequired: queryDocumentSnapshot.get('isRequired'),
      questionCreationDate: queryDocumentSnapshot.get('questionCreationDate'),
      questionType: queryDocumentSnapshot.get('questionType'),
      questionTypeAnswer: queryDocumentSnapshot.get('questionTypeAnswer'),
    );*/
  }

  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'noteAnswer': noteAnswer,
      // 'isRequired': isRequired,
      'noteCreationDate': noteCreationDate,
      // 'questionType': questionType,
    };
  }

  @override
  String toString() {
    return 'NoteModel{noteId: $noteId, noteAnswers: $noteAnswer, noteCreationDate: $noteCreationDate}';
  }
}
