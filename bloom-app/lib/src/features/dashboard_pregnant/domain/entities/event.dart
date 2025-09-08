import 'package:flutter/material.dart';

/// Modelo de dados para um evento no calendário.
class Event {
  final String title;
  final String description;
  final Color color;

  const Event({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  String toString() => title;
}
