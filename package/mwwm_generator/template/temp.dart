import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'di/temp_wm_builder.dart';
import 'di/temp_component.dart';
import 'temp_wm.dart';

/// Экран
class $Temp$ extends MwwmWidget<$Temp$Component> {
  $Temp$({
    WidgetModelBuilder widgetModelBuilder = create$Temp$WidgetModel,
  }) : super(
    widgetModelBuilder: widgetModelBuilder,
    dependenciesBuilder: (context) => $Temp$Component(context),
    widgetStateBuilder: () => _$Temp$State(),
  );
}

class _$Temp$State extends WidgetState<$Temp$WidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Injector
          .of<$Temp$Component>(context)
          .component
          .scaffoldKey,
      body: Container(
        child: Text("temp screen"),
      ),
    );
  }
}
