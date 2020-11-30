import 'package:flutter/material.dart';
import 'package:workshop/validator.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final List<Validator> validators;
  final TextEditingController controller;
  final FocusNode focusNode;

  CustomTextField({
    this.labelText,
    this.validators,
    this.controller,
    this.focusNode,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController _controller;
  FocusNode _focusNode;

  bool _isAutoValidate = false;

  List<Validator> get _validators => widget.validators;

  bool get _isNotExistValidators => _validators?.isEmpty ?? true;

  String get _text => _controller.text;

  AutovalidateMode get _autoValidateMode =>
      _isAutoValidate ? AutovalidateMode.always : AutovalidateMode.disabled;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onChangeText);

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onChangeFocus);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onChangeText);
    }

    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onChangeFocus);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      validator: _validate,
      autovalidateMode: _autoValidateMode,
    );
  }

  String _validate(String text) {
    if (_isNotExistValidators) return null;

    for (Validator validator in _validators) {
      if (validator.isValid(text)) continue;
      return validator.errorText ?? '';
    }

    return null;
  }

  void _onChangeText() {
    if (_text.isEmpty || _isAutoValidate) return;
    _isAutoValidate = true;
    setState(() {});
  }

  void _onChangeFocus() {
    if (_focusNode.hasFocus || _isAutoValidate) return;
    _isAutoValidate = true;
    setState(() {});
  }
}
