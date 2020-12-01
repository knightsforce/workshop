import 'package:flutter/widgets.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:workshop_demo/base/error_handler.dart';
import '../temp_wm.dart';
import 'temp_component.dart';

/// Билдер для [$Temp$WidgetModel]
$Temp$WidgetModel create$Temp$WidgetModel(BuildContext context) {
  var component = Injector.of<$Temp$Component>(context).component;

  final dependencies = WidgetModelDependencies(
    errorHandler: BaseErrorHandler(),
  );

  return $Temp$WidgetModel(dependencies, component.navigator);
}
