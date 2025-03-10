import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailsController extends GetxController {
  final employee = Rx<DocumentSnapshot?>(null);
  final assets = <Map<String, dynamic>>[].obs;
  final assetCounts = <String, int>{}.obs;
  final totalAssets = 0.obs;
  final isLoading = true.obs;

  final selectedCategory = 'Phone'.obs;
  final categories = [
    'Phone',
    'Laptop',
    'Desktop',
    'Monitor',
    'Keyboard',
    'Mouse',
    'Others'
  ].obs;

  final assetDocIds = <String>[].obs;

  void setEmployee(DocumentSnapshot employeeDoc) {
    employee.value = employeeDoc;
    fetchEmployeeAssets();
  }

  void fetchEmployeeAssets() async {
    isLoading.value = true;

    try {
      final employeeId = employee.value?['id'];

      if (employeeId != null) {
        var numericQuery = await FirebaseFirestore.instance
            .collection('assets')
            .where('assinee_id', isEqualTo: int.parse(employeeId.toString()))
            .get();

        var stringQuery = await FirebaseFirestore.instance
            .collection('assets')
            .where('assinee_id', isEqualTo: employeeId.toString())
            .get();

        // Clear previous data
        assets.clear();
        assetCounts.clear();
        assetDocIds.clear();

        // Process numeric query results
        for (var doc in numericQuery.docs) {
          final assetData = doc.data() as Map<String, dynamic>;
          assets.add(assetData);
          assetDocIds.add(doc.id);

          final category = assetData['category'] ?? 'Other';
          assetCounts[category] = (assetCounts[category] ?? 0) + 1;
        }

        // Process string query results
        for (var doc in stringQuery.docs) {
          // Avoid duplicates (in case an asset appears in both queries)
          if (!assetDocIds.contains(doc.id)) {
            final assetData = doc.data() as Map<String, dynamic>;
            assets.add(assetData);
            assetDocIds.add(doc.id);

            // Count by category
            final category = assetData['category'] ?? 'Other';
            assetCounts[category] = (assetCounts[category] ?? 0) + 1;
          }
        }

        totalAssets.value = assets.length;

        // Force UI update with refresh
        assets.refresh();
        assetCounts.refresh();
        assetDocIds.refresh();
      }
    } catch (e) {
      print('Error fetching employee assets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedCategory(String newCategory) {
    selectedCategory.value = newCategory;
  }

  void addAsset(Map<String, dynamic> assetData) async {
    try {
      // Add the asset to Firestore
      await FirebaseFirestore.instance.collection('assets').add(assetData);

      // Refresh assets
      fetchEmployeeAssets();
    } catch (e) {
      print('Error adding asset: $e');
    }
  }

  void updateAsset(int index, Map<String, dynamic> assetData) async {
    try {
      if (index >= 0 && index < assetDocIds.length) {
        String docId = assetDocIds[index];

        // Update the asset in Firestore
        await FirebaseFirestore.instance
            .collection('assets')
            .doc(docId)
            .update(assetData);

        // Update local data
        assets[index] = {...assets[index], ...assetData};
        assets.refresh();
      }
    } catch (e) {
      print('Error updating asset: $e');
    }
  }

  void deleteAsset(int index) async {
    try {
      if (index >= 0 && index < assetDocIds.length) {
        String docId = assetDocIds[index];

        // Delete the asset from Firestore
        await FirebaseFirestore.instance
            .collection('assets')
            .doc(docId)
            .delete();

        // Remove from local lists
        assets.removeAt(index);
        assetDocIds.removeAt(index);
        assets.refresh();
        assetDocIds.refresh();

        // Update total count
        totalAssets.value = assets.length;
      }
    } catch (e) {
      print('Error deleting asset: $e');
    }
  }
}