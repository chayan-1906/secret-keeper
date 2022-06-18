import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:diary_app/services/color_themes.dart';
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
    return Container(
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
              /// bullet
              /*Container(
                height: 6.0,
                width: 6.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(),
              ),*/
              SkywaText(
                text: 'Q: ',
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(width: 5.0),
              SkywaText(
                text: questionModel.questionText,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: questionModel.questionType,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (questionModel.isRequired)
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(0.0, -2.0),
                        child: RichText(
                          text: TextSpan(
                            text: '  *',
                            style: TextStyle(color: ColorThemes.errorColor),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
