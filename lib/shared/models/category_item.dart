import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.name,
    required this.type,
    required this.iconName,
    required this.colorValue,
  });

  final String id;
  final String name;
  final String type;
  final String iconName;
  final int colorValue;

  IconData get icon => _iconFromName(iconName);
  Color get color => Color(colorValue);

  factory CategoryItem.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return CategoryItem(
      id: doc.id,
      name: data['name'] as String? ?? 'Danh mục',
      type: data['type'] as String? ?? 'expense',
      iconName: data['icon'] as String? ?? 'category',
      colorValue: data['color'] as int? ?? 0xFF607D8B,
    );
  }

  static IconData _iconFromName(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'payments':
        return Icons.payments;
      case 'workspace_premium':
        return Icons.workspace_premium;
      default:
        return Icons.category;
    }
  }
}
