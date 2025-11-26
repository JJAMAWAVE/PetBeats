import 'package:flutter/material.dart';
import 'track_model.dart';

class Mode {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final Color color;
  final List<String> scientificFacts;
  final List<Track> tracks;

  Mode({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.scientificFacts,
    this.tracks = const [],
  });
}
