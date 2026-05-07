import 'package:flutter/material.dart';
import 'package:app/bootstrap.dart';
import 'package:app/core/utils/app_flavor.dart';
import 'package:app/frapp_app.dart';


Future<void> mainApp(AppFlavour config) async =>
    bootstrap(config, () => runApp(const FrappeApp()));