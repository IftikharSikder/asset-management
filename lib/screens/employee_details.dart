import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asset_management/controllers/employee_details_controller.dart';
import 'package:asset_management/utils/constants.dart';
import '../custom_widgets/asset_dialog.dart';
import '../custom_widgets/asset_list_item.dart';
import '../custom_widgets/employee_info_card.dart';
import '../custom_widgets/total_assets_card.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final DocumentSnapshot employee;

  const EmployeeDetailScreen(this.employee, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instantiate and initialize the controller
    final controller = Get.put(EmployeeDetailsController());
    controller.setEmployee(employee);

    return Scaffold(
      appBar: AppBar(
        title: Text(employee['name']),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Card
              EmployeeInfoCard(employee: employee),

              // Total Assets Card
              TotalAssetsCard(totalAssets: controller.totalAssets.value),

              // Asset List
              if (controller.assets.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Assigned Assets',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...controller.assets.asMap().entries.map((entry) {
                  final asset = entry.value;
                  final index = entry.key;
                  return AssetListItem(

                    asset: asset,
                    index: index,
                    controller: controller,
                    employee:employee,
                  );
                }).toList(),
              ],
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AssetDialogs.showAddAssetDialog(context, Get.find<EmployeeDetailsController>());
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
        tooltip: 'Add Asset',
      ),
      backgroundColor: AppColors.bodyColor,
    );
  }
}