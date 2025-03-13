// utils/dialog_utils.dart
import 'package:flutter/material.dart';
import 'package:asset_management/controllers/employee_details_controller.dart';
import '../custom_widgets/asset_dialog.dart';

class DialogUtils {
  static void showEditAssetDialog(
      BuildContext context, EmployeeDetailsController controller, Map<String, dynamic> asset, int assetIndex) {
    // Simply delegate to the existing AssetDialogs class
    AssetDialogs.showEditAssetDialog(context, controller, asset, assetIndex);
  }

  static void showAddAssetDialog(
      BuildContext context, EmployeeDetailsController controller) {
    // Simply delegate to the existing AssetDialogs class
    AssetDialogs.showAddAssetDialog(context, controller);
  }

  static void showDeleteConfirmationDialog(
      BuildContext context, EmployeeDetailsController controller, int index) {
    // Simply delegate to the existing AssetDialogs class
    AssetDialogs.showDeleteConfirmationDialog(context, controller, index);
  }
}