import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_ui/icon_font.dart';

typedef OnChange = void Function(String);

///
/// 自定义输入框
///
class WebCustomInputBox extends StatefulWidget {
  final TextEditingController controller;
  final double fontSize;
  final String? hintText;
  final Color? textColor;
  final Color placeholderColor;
  final Color? fillColor;
  final Color? borderColor;
  final OnChange? onChange;
  final int? maxLength;
  final bool readOnly;
  final FocusNode? focusNode;
  final double borderRadius;
  final bool closeButtonEnable; //是否开启清空按钮

  // final int maxLines;
  final bool autofocus;
  final VoidCallback? onEditingComplete;
  final bool needCounter;
  final EdgeInsets? contentPadding;
  final TextInputType keyboardType;

  const WebCustomInputBox({
    required this.controller,
    this.hintText,
    this.fontSize = 14,
    this.textColor,
    this.placeholderColor = const Color(0xff8F959E),
    this.fillColor,
    this.borderColor,
    this.maxLength,
    this.readOnly = false,
    this.focusNode,
    this.borderRadius = 4,
    this.autofocus = false,
    // this.maxLines = 1,
    this.onChange,
    this.onEditingComplete,
    this.needCounter = true,
    this.keyboardType = TextInputType.text,
    this.contentPadding,
    this.closeButtonEnable = false,
    Key? key,
  }) : super(key: key);

  @override
  _WebCustomInputBoxState createState() => _WebCustomInputBoxState();
}

class _WebCustomInputBoxState extends State<WebCustomInputBox> {
  EdgeInsets? _contentPadding;
  late bool _isMultiline;

  @override
  void initState() {
    _isMultiline = widget.keyboardType == TextInputType.multiline;
    _contentPadding = widget.contentPadding ??
        EdgeInsets.fromLTRB(12, 12, _isMultiline ? 12 : 60, 12);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = widget.borderColor ?? const Color(0xFFDEE0E3);
    final closeButtonShow =
        (widget.closeButtonEnable && _isShowClear && !widget.readOnly);
    final inputPadding = EdgeInsets.only(bottom: _isMultiline ? 15 : 0);
    return ClipRect(
        child: Stack(
      children: [
        Opacity(
          opacity: widget.readOnly ? 0.5 : 1,
          child: Container(
            padding: closeButtonShow
                ? inputPadding.copyWith(right: 8)
                : inputPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              maxLines: _isMultiline ? null : 1,
              readOnly: widget.readOnly,
              focusNode: widget.focusNode,
              onChanged: _onTextChange,
              autofocus: widget.autofocus,
              controller: widget.controller,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.textColor ??
                    Theme.of(context).textTheme.bodyMedium!.color,
              ),
              keyboardType: TextInputType.multiline,
              buildCounter: (
                context, {
                required currentLength,
                maxLength,
                required isFocused,
              }) {
                return null;
              },
              maxLength: widget.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: _contentPadding,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gapPadding: 0,
                ),
                fillColor: widget.fillColor,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    fontSize: widget.fontSize, color: widget.placeholderColor),
              ),
              onEditingComplete: widget.onEditingComplete,
            ),
          ),
        ),
        if (!widget.readOnly)
          Positioned.fill(
            child: Container(
              alignment:
                  _isMultiline ? Alignment.bottomRight : Alignment.centerRight,
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Spacer(),
                  if (closeButtonShow)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: IconButton(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          IconFont.close,
                          size: 20,
                          color: Color(0x7F8F959E),
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          _onTextChange('');
                        },
                      ),
                    ),
                  sizeWidth4,
                  RichText(
                    text: TextSpan(
                        text: '${Characters(widget.controller.text).length}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 12,
                            color: Characters(widget.controller.text).length >
                                    widget.maxLength!
                                ? theme.colorScheme.error
                                : theme.disabledColor),
                        children: [
                          TextSpan(
                            text: '/${widget.maxLength}',
                            style: theme.textTheme.bodyLarge!.copyWith(
                                fontSize: 12, color: theme.disabledColor),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          )
      ],
    ));
  }

  void _onTextChange(String val) {
    setState(() {});
    if (widget.onChange != null) widget.onChange!(val);
  }

  bool get _isShowClear => widget.controller.text.trim().isNotEmpty;
}
