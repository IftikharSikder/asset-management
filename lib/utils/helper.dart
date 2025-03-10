import 'package:flutter/material.dart';

class AssetHelpers {
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'phone':
        return Icons.phone_android_sharp;
      case 'laptop':
        return Icons.laptop_chromebook;
      case 'desktop':
        return Icons.devices;
      case 'monitor':
        return Icons.monitor;
      case 'keyboard':
        return Icons.keyboard;
      case 'mouse':
        return Icons.mouse;
      case 'others':
      default:
        return Icons.devices_other;
    }
  }
}