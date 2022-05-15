import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String questionId;
  String questionText;
  bool isRequired;
  String questionCreationDate;
  String questionType;
  String questionTypeAnswer;

  QuestionModel({
    this.questionId,
    this.questionText,
    this.isRequired,
    this.questionCreationDate,
    this.questionType,
    this.questionTypeAnswer,
  });

  factory QuestionModel.fromJson(QueryDocumentSnapshot queryDocumentSnapshot) {
    return QuestionModel(
      questionId: queryDocumentSnapshot.get('questionId'),
      questionText: queryDocumentSnapshot.get('questionText'),
      isRequired: queryDocumentSnapshot.get('isRequired'),
      questionCreationDate: queryDocumentSnapshot.get('questionCreationDate'),
      questionType: queryDocumentSnapshot.get('questionType'),
      questionTypeAnswer: queryDocumentSnapshot.get('questionTypeAnswer'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'isRequired': isRequired,
      'questionCreationDate': questionCreationDate,
      'questionType': questionType,
      'questionTypeAnswer': questionTypeAnswer,
    };
  }

  @override
  String toString() {
    return 'QuestionModel{questionId: $questionId, questionText: $questionText, isRequired: $isRequired, questionCreationDate: $questionCreationDate, questionType: $questionType, questionTypeAnswer: $questionTypeAnswer}';
  }
}
