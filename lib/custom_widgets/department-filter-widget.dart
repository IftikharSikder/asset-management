import 'package:flutter/material.dart';
import 'package:asset_management/utils/constants.dart';
import 'package:get/get.dart';
import 'package:asset_management/controllers/employee-controller.dart';

class DepartmentFilterWidget extends StatelessWidget {
  final EmployeeController controller;

  const DepartmentFilterWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadingDepartments.value
        ? SizedBox() // Empty widget instead of CircularProgressIndicator
        : Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.departments.length,
              itemBuilder: (context, index) {
                final department = controller.departments[index];
                final isSelected = department == (controller.selectedDepartment.value ?? 'All Employees');

                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.selectedDepartment.value = department == 'All Employees' ? null : department;
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          department,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    // Add space between tabs (except after the last one)
                    if (index < controller.departments.length - 1)
                      SizedBox(width: 12),
                  ],
                );
              },
            ),
          )
    );
  }
}
