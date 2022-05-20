import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/color_themes.dart';
import '../../services/is_string_invalid.dart';
import 'skywa_date_time_picker.dart';
import 'skywa_text.dart';

class SkywaTextFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String labelText;
  final String hintText;
  final EdgeInsetsGeometry contentPadding;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final int maxLines;
  final bool showDecoration;
  ValueChanged<DateTime> onDateTimeChanged;
  DateTime initialDateTime;
  DateTime minimumDate;
  DateTime maximumDate;
  int minimumYear;
  int maximumYear;

  /// Optimize for textual information.
  ///
  /// Requests the default platform keyboard.
  SkywaTextFormField.text({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.text,
        textCapitalization = TextCapitalization.sentences,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /// Optimize for multiline textual information.
  ///
  /// Requests the default platform keyboard, but accepts newlines when the
  /// enter key is pressed. This is the input type used for all multiline text
  /// fields.
  SkywaTextFormField.multiline({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 5,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.multiline,
        textCapitalization = TextCapitalization.sentences,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /* NOT REQUIRED */
  /*SkywaTextFormField.number({
    @required this.textEditingController,
    // this.width,
    // this.height,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.number,
        textCapitalization = TextCapitalization.none,
        assert(!isStringInvalid(text: labelText)),
        assert(!isStringInvalid(text: hintText));*/

  /// Optimize for unsigned numerical information without a decimal point.
  ///
  /// Requests a default keyboard with ready access to the number keys.
  /// Additional options, such as decimal point and/or positive/negative
  /// signs, can be requested using [new TextInputType.numberWithOptions].
  SkywaTextFormField.numberWithOptions({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        textCapitalization = TextCapitalization.none,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /// Optimize for telephone numbers.
  ///
  /// Requests a keyboard with ready access to the number keys, "*", and "#".
  SkywaTextFormField.phone({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.phone,
        textCapitalization = TextCapitalization.none,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key)
  // assert(onChanged == null)
  ;

  /// Optimize for date and time information.
  ///
  /// On iOS, requests the default keyboard.
  ///
  /// On Android, requests a keyboard with ready access to the number keys,
  /// ":", and "-".
  SkywaTextFormField.datetime({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
    @required this.onDateTimeChanged,
    this.initialDateTime,
    this.minimumDate,
    this.minimumYear,
    this.maximumDate,
    this.maximumYear,
  })  : keyboardType = TextInputType.datetime,
        textCapitalization = TextCapitalization.none,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        assert(onDateTimeChanged != null),
        super(key: key);

  /// Optimize for email addresses.
  ///
  /// Requests a keyboard with ready access to the "@" and "." keys.
  SkywaTextFormField.emailAddress({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.emailAddress,
        textCapitalization = TextCapitalization.none,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /// Optimize for URLs.
  ///
  /// Requests a keyboard with ready access to the "/" and "." keys.
  SkywaTextFormField.url({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.url,
        textCapitalization = TextCapitalization.none,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /// Optimize for passwords that are visible to the user.
  ///
  /// Requests a keyboard with ready access to both letters and numbers.
  SkywaTextFormField.visiblePassword({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.visiblePassword,
        textCapitalization = TextCapitalization.words,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /// Optimized for a person's name.
  ///
  /// On iOS, requests the
  /// [UIKeyboardType.namePhonePad](https://developer.apple.com/documentation/uikit/uikeyboardtype/namephonepad)
  /// keyboard, a keyboard optimized for entering a person’s name or phone number.
  /// Does not support auto-capitalization.
  ///
  /// On Android, requests a keyboard optimized for
  /// [TYPE_TEXT_VARIATION_PERSON_NAME](https://developer.android.com/reference/android/text/InputType#TYPE_TEXT_VARIATION_PERSON_NAME).
  SkywaTextFormField.name({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.name,
        textCapitalization = TextCapitalization.words,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /// Optimized for postal mailing addresses.
  ///
  /// On iOS, requests the default keyboard.
  ///
  /// On Android, requests a keyboard optimized for
  /// [TYPE_TEXT_VARIATION_POSTAL_ADDRESS](https://developer.android.com/reference/android/text/InputType#TYPE_TEXT_VARIATION_POSTAL_ADDRESS).
  SkywaTextFormField.streetAddress({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.streetAddress,
        textCapitalization = TextCapitalization.words,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  /// Prevent the OS from showing the on-screen virtual keyboard.
  SkywaTextFormField.none({
    Key key,
    @required this.textEditingController,
    @required this.labelText,
    @required this.hintText,
    this.contentPadding,
    this.maxLines = 1,
    this.showDecoration = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.isObscure = false,
  })  : keyboardType = TextInputType.none,
        textCapitalization = TextCapitalization.none,
        assert(textEditingController != null),
        assert(labelText != null && labelText != 'null'),
        assert(hintText != null && hintText != 'null'),
        super(key: key);

  @override
  State<SkywaTextFormField> createState() => _SkywaTextFormFieldState();
}

class _SkywaTextFormFieldState extends State<SkywaTextFormField> {
  bool isObscure;
  Timer onStoppedTyping;
  bool isValidPhoneNumber = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          style: TextStyle(
            fontSize: 17.0,
            color: widget.showDecoration ? Colors.black : Colors.white,
          ),
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: isObscure,
          maxLines: widget.maxLines,
          enableSuggestions: true,
          obscuringCharacter: '*',
          cursorColor: ColorThemes.cursorColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            border: widget.showDecoration
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )
                : InputBorder.none,
            focusedBorder: widget.showDecoration
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: ColorThemes.primaryColor, width: 2.0),
                  )
                : InputBorder.none,
            contentPadding: widget.contentPadding,
            errorBorder: widget.showDecoration
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: ColorThemes.errorColor,
                      width: 2.0,
                    ),
                  )
                : InputBorder.none,
            label: SkywaText(
              text: widget.labelText,
              fontSize: 18.0,
              color: Colors.grey.shade600,
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(fontSize: 17.0),
            prefixIcon: widget.prefixIcon,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.keyboardType == TextInputType.visiblePassword)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: ColorThemes.primaryColor,
                    ),
                  ),
                if (widget.suffixIcon != null) widget.suffixIcon,
              ],
            ),
          ),
          inputFormatters: <TextInputFormatter>[
            if (widget.keyboardType ==
                const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ))
              FilteringTextInputFormatter.digitsOnly,
          ],
          onTap: widget.keyboardType == TextInputType.datetime
              ? () {
                  SkywaDateTimePicker.dateAndTime(
                    context: context,
                    onDateTimeChanged: widget.onDateTimeChanged,
                    initialDateTime: widget.initialDateTime,
                    minimumYear: widget.minimumYear,
                    minimumDate: widget.minimumDate,
                    maximumYear: widget.maximumYear,
                    maximumDate: widget.maximumDate,
                  );
                }
              : null,
          onChanged: widget.onChanged,
        ),
        if (widget.keyboardType == TextInputType.phone && !isValidPhoneNumber)
          Column(
            children: [
              const SizedBox(height: 5.0),
              SkywaText(
                text: 'Invalid Phone Number',
                color: ColorThemes.errorColor,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ],
          ),
      ],
    );
  }
}
