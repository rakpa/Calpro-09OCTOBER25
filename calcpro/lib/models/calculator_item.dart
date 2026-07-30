import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';

class CalculatorItem {
  final String title;
  final String shortTitle;
  final String description;
  final String route;
  final IconData icon;
  final Color accent;
  final List<String> tags;
  final double rating;
  final int ratingCount;

  const CalculatorItem({
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.route,
    required this.icon,
    required this.accent,
    this.tags = const ['Popular'],
    this.rating = 4.8,
    this.ratingCount = 120,
  });
}

const List<CalculatorItem> kCalculators = [
  CalculatorItem(
    title: 'Percentage Calculator',
    shortTitle: 'Percentage',
    description: 'Find percentages, proportions & change',
    route: '/percentage',
    icon: Icons.percent_rounded,
    accent: AppColors.accentPink,
    tags: ['Popular', 'Favorites'],
    rating: 4.9,
    ratingCount: 248,
  ),
  CalculatorItem(
    title: 'Basic Calculator',
    shortTitle: 'Basic',
    description: 'Everyday arithmetic, beautifully simple',
    route: '/basic',
    icon: Icons.calculate_rounded,
    accent: AppColors.accentBlue,
    tags: ['Popular', 'Recent'],
    rating: 4.8,
    ratingCount: 412,
  ),
  CalculatorItem(
    title: 'Scientific Calculator',
    shortTitle: 'Scientific',
    description: 'Trig, powers, and advanced math',
    route: '/scientific',
    icon: Icons.science_rounded,
    accent: AppColors.accentPurple,
    tags: ['Popular'],
    rating: 4.7,
    ratingCount: 186,
  ),
  CalculatorItem(
    title: 'Unit Converter',
    shortTitle: 'Converter',
    description: 'Length, weight, temperature & more',
    route: '/convert',
    icon: Icons.swap_vert_rounded,
    accent: AppColors.accentTeal,
    tags: ['Popular'],
    rating: 4.8,
    ratingCount: 301,
  ),
  CalculatorItem(
    title: 'Financial Calculator',
    shortTitle: 'Loan',
    description: 'Loans, interest, and amortization',
    route: '/financial',
    icon: Icons.attach_money_rounded,
    accent: AppColors.accentBlue,
    tags: ['Popular'],
    rating: 4.6,
    ratingCount: 154,
  ),
  CalculatorItem(
    title: 'Mortgage Calculator',
    shortTitle: 'Mortgage',
    description: 'Monthly payments with tax & insurance',
    route: '/mortgage',
    icon: Icons.home_rounded,
    accent: AppColors.accentOrange,
    tags: ['Popular', 'Favorites'],
    rating: 4.9,
    ratingCount: 219,
  ),
  CalculatorItem(
    title: 'Age Calculator',
    shortTitle: 'Age',
    description: 'Exact age and date milestones',
    route: '/age',
    icon: Icons.cake_rounded,
    accent: AppColors.accentTeal,
    tags: ['Recent'],
    rating: 4.5,
    ratingCount: 98,
  ),
  CalculatorItem(
    title: 'Time Calculator',
    shortTitle: 'Time',
    description: 'Durations and time differences',
    route: '/time',
    icon: Icons.access_time_rounded,
    accent: AppColors.accentGreen,
    tags: ['History'],
    rating: 4.6,
    ratingCount: 112,
  ),
  CalculatorItem(
    title: 'Date Difference',
    shortTitle: 'Date Diff',
    description: 'Days, weeks, and months between dates',
    route: '/date-diff',
    icon: Icons.date_range_rounded,
    accent: AppColors.accentOrange,
    tags: ['Recent'],
    rating: 4.7,
    ratingCount: 133,
  ),
  CalculatorItem(
    title: 'Discount Calculator',
    shortTitle: 'Discount',
    description: 'Sale prices and savings',
    route: '/discount',
    icon: Icons.local_offer_rounded,
    accent: AppColors.accentPink,
    tags: ['Popular'],
    rating: 4.8,
    ratingCount: 177,
  ),
  CalculatorItem(
    title: 'Tip Calculator',
    shortTitle: 'Tip',
    description: 'Tips and bill splitting',
    route: '/tip',
    icon: Icons.restaurant_rounded,
    accent: AppColors.accentPurple,
    tags: ['Favorites'],
    rating: 4.9,
    ratingCount: 265,
  ),
  CalculatorItem(
    title: 'Health Calculator',
    shortTitle: 'BMI',
    description: 'BMI and ideal weight estimates',
    route: '/health',
    icon: Icons.favorite_rounded,
    accent: AppColors.accentGreen,
    tags: ['Popular'],
    rating: 4.7,
    ratingCount: 201,
  ),
];

CalculatorItem? calculatorByRoute(String route) {
  for (final c in kCalculators) {
    if (c.route == route) return c;
  }
  return null;
}
