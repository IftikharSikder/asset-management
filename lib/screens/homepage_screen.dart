import 'package:asset_management/controllers/employee-controller.dart';
import 'package:asset_management/custom_widgets/department-filter-widget.dart';
import 'package:asset_management/custom_widgets/employee-count-widget.dart';
import 'package:asset_management/custom_widgets/employee-list-widget.dart';
import 'package:asset_management/screens/add_employee.dart';
import 'package:asset_management/custom_widgets/custom_app_bar.dart';
import 'package:asset_management/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageScreen extends StatelessWidget {
  final EmployeeController controller = Get.put(EmployeeController());

  HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDepartments();
      controller.setupEmployeeListener();
    });

    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => EmployeeCountWidget(
            employeeCount: controller.employeeCount.value,
            isLoading: controller.isCountLoading.value,
          )),

          DepartmentFilterWidget(
            controller: controller,
          ),

          SizedBox(height: 16),

          // Employee list
          Expanded(
            child: Obx(() => EmployeeListWidget(
              query: controller.getFilteredQuery(),
              refreshDepartments: controller.fetchDepartments,
              onEmployeeDeleted: () => controller.refreshEmployeeCount(),
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(side: BorderSide.none),
        onPressed: () {
          Get.to(AddEmployeeScreen())?.then((_) {
            controller.fetchDepartments();
            // Refresh the count when returning from add screen
            controller.refreshEmployeeCount();
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          size: 30,
          color: AppColors.bodyColor,
        ),
      ),
    );
  }
}

