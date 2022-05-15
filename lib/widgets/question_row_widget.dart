import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class QuestionRowWidget extends StatefulWidget {
  final QuestionModel questionModel;

  const QuestionRowWidget({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  State<QuestionRowWidget> createState() => _QuestionRowWidgetState();
}

class _QuestionRowWidgetState extends State<QuestionRowWidget> {
  QuestionModel questionModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    questionModel = widget.questionModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Device.screenWidth,
      height: 80.0,
      margin: EdgeInsets.symmetric(
        horizontal: Device.screenWidth * 0.03,
        vertical: 10.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Device.screenWidth * 0.05,
        // vertical: 15.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          /// bottom right
          const BoxShadow(
            color: Colors.grey,
            offset: Offset(5, 5),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),

          /// top left
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(-5, -5),
            blurRadius: 1.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// question text
          SkywaText(
            text: questionModel.questionText,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 10.0),

          /// required or not
          Row(
            children: [
              SkywaText(
                text: questionModel.questionType,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(width: 10.0),
              SkywaText(
                text: ':',
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(width: 10.0),
              SkywaText(
                text: questionModel.isRequired ? 'Mandatory' : 'Optional',
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
