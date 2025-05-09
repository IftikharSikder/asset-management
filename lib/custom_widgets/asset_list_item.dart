import 'package:asset_management/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asset_management/utils/constants.dart';
import 'package:asset_management/controllers/employee_details_controller.dart';
import '../screens/employee_asset_details.dart';
import 'asset_dialog.dart';
import 'package:get/get.dart';
class AssetListItem extends StatelessWidget {
  final Map<String, dynamic> asset;

  final int index;

  final EmployeeDetailsController controller;
  final DocumentSnapshot employee;
 AssetListItem({
    Key? key,

    required this.asset,
    required this.index,
    required this.controller,
   required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = asset['category'] ?? 'Others';

    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: (){   Get.to(() => EmployeeAssetsDetailScreen(serialNumber: asset['sn'],employee:employee));},
        leading: Icon(
          AssetHelpers.getCategoryIcon(category),
          color: AppColors.primary,
        ),
        title: Text(asset['name'] ?? 'Unknown Asset'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SN: ${asset['sn'] ?? 'N/A'}'),
            Text('Category: $category',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  AssetDialogs.showEditAssetDialog(context, controller, asset, index);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  AssetDialogs.showDeleteConfirmationDialog(context, controller, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}