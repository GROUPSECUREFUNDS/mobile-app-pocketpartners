import "package:flutter/material.dart";

class RouteModel {
  final String path;
  final String name;
  final IconData icon;

  const RouteModel({
    required this.path,
    required this.name,
    required this.icon,
  });
}