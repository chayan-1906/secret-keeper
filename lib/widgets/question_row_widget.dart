import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:diary_app/services/color_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class QuestionRowWidget extends StatelessWidget {
  final QuestionModel questionModel;

  const QuestionRowWidget({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Device.screenWidth,
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
              BoxShadow(
                color: Colors.grey.shade400,
                offset: Offset(5, 5),
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),

              /// top left
              BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(-5, -5),
                blurRadius: 4.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 12.0),

              /// question text
              Row(
                children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.pan_tool_alt_rounded),
                  ),
                  SizedBox(width: 5.0),
                  SkywaText(
                    text: questionModel.questionText,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                  /*SkywaRichText(
                    texts: [
                      questionModel.questionText,
                      questionModel.isRequired ? ' *' : '',
                    ],
                    textStyles: [
                      TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      TextStyle(
                        color: ColorThemes.errorColor,
                        letterSpacing: 0.6,
                      ),
                    ],
                    onTaps: [() {}],
                  ),*/
                ],
              ),
              const SizedBox(height: 10.0),

              /// question type
              Container(
                width: 75.0,
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorThemes.chipColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: SkywaText(
                  text: questionModel.questionType,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
        if (questionModel.isRequired)
          Positioned(
            top: 20.0,
            right: 25.0,
            child: SkywaText(
              text: '*',
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: ColorThemes.errorColor,
            ),
          ),
      ],
    );
  }
}
