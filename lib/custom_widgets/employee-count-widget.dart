import 'package:flutter/material.dart';
import 'package:asset_management/utils/constants.dart';

class EmployeeCountWidget extends StatelessWidget {
  final int employeeCount;
  final bool isLoading;

  const EmployeeCountWidget({
    Key? key,
    required this.employeeCount,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.totalEmployeesLabel,
                      style: AppTextStyles.totalLabel,
                    ),
                    const SizedBox(height: 8),
                     Text(
                      '$employeeCount',
                      style: AppTextStyles.totalCount,
                    ),
                  ],
                ),
                Icon(
                  Icons.people,
                  color: AppColors.primary,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}