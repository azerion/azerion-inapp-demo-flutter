/// Extra screens listed in the menu drawer. The demo has none.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InternalFeature {
  const InternalFeature({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final IconData icon;
  final GoRoute route;
}

final List<InternalFeature> internalFeatures = [];
