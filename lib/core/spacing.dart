import 'package:flutter/material.dart';

class Spacing {
  final BuildContext context;

  Spacing(this.context);

  // أبعاد الشاشة الأساسية
  double get screenHeight => MediaQuery.of(context).size.height;
  double get screenWidth => MediaQuery.of(context).size.width;

  // ==================== المسافات العمودية (Vertical Height) ====================
  double get heightXs => screenHeight * 0.01; // ~1% من ارتفاع الشاشة
  double get heightSm => screenHeight * 0.02; // ~2% من ارتفاع الشاشة
  double get heightMd => screenHeight * 0.04; // ~4% من ارتفاع الشاشة
  double get heightLg => screenHeight * 0.06; // ~6% من ارتفاع الشاشة
  double get heightXl => screenHeight * 0.10; // ~10% من ارتفاع الشاشة

  // ==================== المسافات الأفقية (Horizontal Width) ====================
  double get widthXs => screenWidth * 0.02; // ~2% من عرض الشاشة
  double get widthSm => screenWidth * 0.04; // ~4% من عرض الشاشة
  double get widthMd => screenWidth * 0.06; // ~6% من عرض الشاشة
  double get widthLg => screenWidth * 0.08; // ~8% من عرض الشاشة
  double get widthxLg => screenWidth * 0.11; // ~8% من عرض الشاشة
  double get widthXl => screenWidth * 0.12; // ~12% من عرض الشاشة

  // ==================== الحواف والـ Padding الجاهزة ====================
  EdgeInsets get paddingAllSmall => EdgeInsets.all(screenWidth * 0.03);
  EdgeInsets get paddingAllMedium => EdgeInsets.all(screenWidth * 0.05);
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: screenWidth * 0.04);
  EdgeInsets get paddingVertical =>
      EdgeInsets.symmetric(vertical: screenHeight * 0.02);
}
