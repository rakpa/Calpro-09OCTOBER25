import 'package:flutter/material.dart';

class CalculatorItem {
  final String title;
  final String description;
  final String route;
  final IconData icon;
  final List<Color> gradient;

  const CalculatorItem({
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
    required this.gradient,
  });
}

const List<CalculatorItem> kCalculators = [
  CalculatorItem(
    title: 'Percentage Calculator',
    description: 'Calculate percentages and proportions',
    route: '/percentage',
    icon: Icons.percent,
    gradient: [Color(0xFF34D399), Color(0xFF14B8A6)],
  ),
  CalculatorItem(
    title: 'Basic Calculator',
    description: 'Simple arithmetic calculations',
    route: '/basic',
    icon: Icons.calculate,
    gradient: [Color(0xFF60A5FA), Color(0xFF4F46E5)],
  ),
  CalculatorItem(
    title: 'Unit Converter',
    description: 'Convert between different units',
    route: '/convert',
    icon: Icons.swap_vert,
    gradient: [Color(0xFFC084FC), Color(0xFF7C3AED)],
  ),
  CalculatorItem(
    title: 'Financial Calculator',
    description: 'Calculate loans, interest and more',
    route: '/financial',
    icon: Icons.attach_money,
    gradient: [Color(0xFFFBBF24), Color(0xFFF97316)],
  ),
  CalculatorItem(
    title: 'Mortgage Calculator',
    description: 'Calculate monthly mortgage payments',
    route: '/mortgage',
    icon: Icons.home,
    gradient: [Color(0xFFFB7185), Color(0xFFDB2777)],
  ),
  CalculatorItem(
    title: 'Age Calculator',
    description: 'Calculate exact age and date differences',
    route: '/age',
    icon: Icons.calendar_today,
    gradient: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
  ),
  CalculatorItem(
    title: 'Scientific Calculator',
    description: 'Advanced mathematical calculations',
    route: '/scientific',
    icon: Icons.science,
    gradient: [Color(0xFFE879F9), Color(0xFF9333EA)],
  ),
  CalculatorItem(
    title: 'Time Calculator',
    description: 'Calculate time differences and durations',
    route: '/time',
    icon: Icons.access_time,
    gradient: [Color(0xFFA3E635), Color(0xFF22C55E)],
  ),
  CalculatorItem(
    title: 'Date Difference Calculator',
    description: 'Calculate the exact difference between dates',
    route: '/date-diff',
    icon: Icons.date_range,
    gradient: [Color(0xFFFB923C), Color(0xFFEF4444)],
  ),
  CalculatorItem(
    title: 'Discount Calculator',
    description: 'Calculate sale prices and savings',
    route: '/discount',
    icon: Icons.local_offer,
    gradient: [Color(0xFF38BDF8), Color(0xFF2563EB)],
  ),
  CalculatorItem(
    title: 'Tip Calculator',
    description: 'Split bills and calculate tips',
    route: '/tip',
    icon: Icons.restaurant,
    gradient: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
  ),
  CalculatorItem(
    title: 'Health Calculator',
    description: 'BMI and ideal weight estimates',
    route: '/health',
    icon: Icons.favorite,
    gradient: [Color(0xFFF472B6), Color(0xFFE11D48)],
  ),
];
