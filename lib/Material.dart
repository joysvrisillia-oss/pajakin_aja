import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF002E7A);
const Color lightBlue = Color(0xFF6FC3F7);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
  fontFamily: 'Roboto',
);
