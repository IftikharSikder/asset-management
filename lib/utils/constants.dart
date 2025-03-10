import 'package:flutter/material.dart';

class AppColors {
  static final Color primary = Colors.blue;
  static final Color background = Colors.white;
  static final Color bodyColor = Color(0xfff6f6f6);
  static final Color cardShadow = Colors.black12;
  static final Color textPrimary = Colors.black;
  static final Color textSecondary = Colors.grey.shade600;
  static final Color tabUnselected = Colors.grey.shade200;
  static final Color deleteBackground = Colors.red.withValues(alpha: .3);
  static final Color iconBlue = Colors.blue;
  static final Color successBackground = Colors.green.shade100;
  static final Color errorBackground = Colors.red.shade100;
}

class AppTextStyles {
  static final TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle totalLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  static final TextStyle totalCount = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle tabSelected = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle tabUnselected = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle employeeName = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static final TextStyle employeeTitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );
}

class AppStrings {
  static const String appTitle = 'Employees';
  static String totalEmployeesLabel = 'Department Employee Count';
  static const String allEmployeesTab = 'All Employees';
  static const String itDepartmentTab = 'IT Department';
  static const String salesTab = 'Sales';
  static const String addEmployeeTitle = 'Add New Employee';
  static const String editEmployeeTitle = 'Edit Employee';
  static const String nameLabel = 'Name';
  static const String jobTitleLabel = 'Job Title';
  static const String cancelButton = 'CANCEL';
  static const String addButton = 'ADD';
  static const String updateButton = 'UPDATE';
  static const String successAddTitle = 'Success';
  static const String successAddMessage = 'Employee added successfully';
  static const String successEditMessage = 'Employee updated successfully';
  static const String errorTitle = 'Error';
  static const String errorMessage = 'Please fill all fields';
  static const String employeeRemovedTitle = 'Employee Removed';
  static const String employeeRemovedMessage = ' has been removed';
}
