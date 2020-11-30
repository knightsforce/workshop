import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop/custom_text_field.dart';
import 'package:workshop/result.dart';
import 'package:workshop/validator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Workshop'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _emptyErrorText = 'Поле не должно быть пустым';
  static const _emailErrorText = 'Неверный формат email';

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = true;

  Map<FieldId, TextEditingController> _controllers = {
    FieldId.name: TextEditingController(),
    FieldId.lastName: TextEditingController(),
    FieldId.email: TextEditingController(),
  };

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _controllers.forEach((key, value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: _buildBody(),
        ),
        if (_isLoading) _buildLoading()
      ],
    );
  }

  Widget _buildBody() {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildForm(),
            GestureDetector(
              onTap: _onPressed,
              child: Text('Регистрация'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(.1),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            labelText: 'Имя',
            controller: _controllers[FieldId.name],
            validators: [
              NoEmptyValidator(_emptyErrorText),
            ],
          ),
          const SizedBox(height: 10),
          CustomTextField(
            labelText: 'Фамилия',
            controller: _controllers[FieldId.lastName],
            validators: [
              NoEmptyValidator(_emptyErrorText),
            ],
          ),
          const SizedBox(height: 10),
          CustomTextField(
            labelText: 'Email',
            controller: _controllers[FieldId.email],
            validators: [
              NoEmptyValidator(_emptyErrorText),
              EmailValidator(_emailErrorText),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _onPressed() async {
    final bool isValid = _formKey.currentState.validate();

    if (!isValid) return;

    final sp = await SharedPreferences.getInstance();

    sp.clear();

    Navigator.of(context).pushReplacement(
      Platform.isAndroid
          ? MaterialPageRoute(builder: _buildRoute)
          : CupertinoPageRoute(builder: _buildRoute),
    );
  }

  Widget _buildRoute(_) => ResultScreen(
        name: _controllers[FieldId.name].text,
        lastName: _controllers[FieldId.lastName].text,
        email: _controllers[FieldId.email].text,
      );

  Future<bool> _onWillPop() async {
    _isLoading = true;
    setState(() {});
    await _saveData();
    _isLoading = false;
    setState(() {});
    return true;
  }

  Future<void> _saveData() async {
    final sp = await SharedPreferences.getInstance();

    for (FieldId id in FieldId.values) {
      if (!_controllers.containsKey(id)) continue;
      await sp.setString(id.value, _controllers[id].text);
    }
  }

  void _initData() async {
    try {
      final sp = await SharedPreferences.getInstance();

      String text;

      for (FieldId id in FieldId.values) {
        text = sp.getString(id.value);
        if (text?.isEmpty ?? true) continue;
        _controllers[id].text = text;
      }
    } catch (e) {}

    _isLoading = false;
    setState(() {});
  }
}

enum FieldId {
  name,
  lastName,
  email,
}

extension on FieldId {
  String get value {
    switch (this) {
      case FieldId.name:
        return 'name';
      case FieldId.lastName:
        return 'lastName';
      case FieldId.email:
        return 'email';
    }

    return '';
  }
}
