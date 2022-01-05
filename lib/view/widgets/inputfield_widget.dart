import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldWidget extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final String prefixImage;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final bool enable;
  final bool textAlignCenter;
  final int maxLines;
  final focusNode;
  final Function onChange;
  final bool isSvg;
  final bool showPadding;
  final String label;
  final bool showDropArrow;
  final TextAlignVertical textAlignVertical;

  InputFieldWidget(
      {this.focusNode,
      this.hint,
      this.prefixIcon,
      this.prefixImage,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscure = false,
      this.enable = true,
      this.textAlignCenter = false,
      this.maxLines,
      this.onChange,
      this.isSvg = false,
      this.showPadding = false,
      this.label,
      this.showDropArrow = false,
      this.textAlignVertical = TextAlignVertical.center});

  @override
  _InputFieldWidgetState createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode ?? null,
      cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
      maxLines: widget.maxLines == null ? 1 : widget.maxLines,
      onChanged: widget.onChange,
      enabled: widget.enable,
      controller: widget.controller,
      textAlign:
          widget.textAlignCenter == true ? TextAlign.center : TextAlign.start,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      textAlignVertical: widget.textAlignVertical,
      obscureText: widget.obscure ? obscure : widget.obscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        contentPadding: widget.showPadding ? EdgeInsets.only(left: 12) : null,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        border: buildUnderlineInputBorder(),
        enabledBorder: buildUnderlineInputBorder(),
        errorBorder: buildUnderlineInputBorder(),
        focusedBorder: buildUnderlineInputBorder(),
        disabledBorder: buildUnderlineInputBorder(),
        prefixIconConstraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.width * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  widget.prefixIcon,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : widget.prefixImage != null
                ? Container(
                    width: 20,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(widget.prefixImage))
                : null,
        suffixIcon: widget.showDropArrow
            ? Icon(Icons.arrow_drop_down_outlined)
            : !widget.obscure
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    child: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColor,
                      size: 23,
                    ),
                  ),
      ),
    );
  }

  OutlineInputBorder buildUnderlineInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(27.5));
  }
}
