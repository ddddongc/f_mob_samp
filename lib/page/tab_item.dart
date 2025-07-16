import 'package:flutter/material.dart';

class TabInfo{
  final IconData icon;
  final String label;

  const TabInfo({
    required this.icon,
    required this.label,

  });
}

const TABS = [
  TabInfo(
    icon :Icons.calendar_today,
    label: '일정',
  ),
  TabInfo(
    icon :Icons.directions_run_sharp, //location_on,
    label: '러닝',
  ),
  TabInfo(
    icon :Icons.add_chart,//supervisor_account_rounded,
    label: '활동',
  ),
  TabInfo(
    icon :Icons.settings,
    label: '옵션',
  ),
];