import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asset_management/controllers/employee_details_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AssetDialogs {
  static void showEditAssetDialog(BuildContext context, EmployeeDetailsController controller, Map<String, dynamic> asset, int assetIndex) {
    final TextEditingController nameController = TextEditingController(text: asset['name']);
    final TextEditingController snController = TextEditingController(text: asset['sn']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Asset'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Asset Name'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: snController,
                  decoration: InputDecoration(labelText: 'Serial Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Create updated data
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'sn': snController.text,
                };

                // Call controller method to update asset
                controller.updateAsset(assetIndex, updatedData);

                // Close dialog
                Navigator.of(context).pop();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Asset updated successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  static void showAddAssetDialog(BuildContext context, EmployeeDetailsController controller) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController snController = TextEditingController();

    // Reset selected category to default
    controller.selectedCategory.value = controller.categories[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Asset'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Asset Name'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: snController,
                  decoration: InputDecoration(labelText: 'Serial Number'),
                ),
                SizedBox(height: 16),
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value,
                  items: controller.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.updateSelectedCategory(newValue);
                    }
                  },
                )),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Get employee ID
                final employeeId = controller.employee.value?['id'];

                if (employeeId != null) {
                  // Create new asset data
                  Map<String, dynamic> newAssetData = {
                    'name': nameController.text,
                    'sn': snController.text,
                    'category': controller.selectedCategory.value,
                    'assinee_id': employeeId,
                    'timestamp': FieldValue.serverTimestamp(),
                  };

                  // Call controller method to add asset
                  controller.addAsset(newAssetData);

                  // Close dialog
                  Navigator.of(context).pop();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Asset added successfully')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showDeleteConfirmationDialog(BuildContext context, EmployeeDetailsController controller, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Asset'),
          content: Text('Are you sure you want to delete this asset?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                controller.deleteAsset(index);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Asset deleted successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}