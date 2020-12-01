import 'package:flutter/material.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:workshop_demo/ui/app/di/app_component.dart';

/// [Component] для [$Temp$]
class $Temp$Component extends Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  NavigatorState navigator;

  $Temp$Component(BuildContext context) {
    navigator = Navigator.of(context);

    final parentComponent = Injector.of<AppComponent>(context).component;
  }
}
