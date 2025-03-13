import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailsController extends GetxController {
  final employee = Rx<DocumentSnapshot?>(null);
  final assets = <Map<String, dynamic>>[].obs;
  final assetCounts = <String, int>{}.obs;
  final totalAssets = 0.obs;
  final isLoading = true.obs;
  final isloading_1 = true.obs;
  final assetDetails =  Rx<Map<String, dynamic>>({});
  final selectedCategory = 'Phone'.obs;
  final assetData = Rx<Map<String, dynamic>>({});
  final employeeData = Rx<Map<String, dynamic>>({});


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

  Future<bool> isSerialNumberUnique(String serialNumber) async {
    try {
      if (serialNumber.isEmpty) {
        return false;
      }

      final QuerySnapshot snQuery = await FirebaseFirestore.instance
          .collection('assets')
          .where('sn', isEqualTo: serialNumber)
          .limit(1)
          .get();

      return snQuery.docs.isEmpty;
    } catch (e) {
      print('Error checking for unique serial number: $e');
      // In case of error, prevent adding the asset to be safe
      return false;
    }
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

  void fetchEmployeeAssetsDetails(String serialNumber) async {

    try {
      // Query the asset with the given serial number
      final QuerySnapshot assetQuery = await FirebaseFirestore.instance
          .collection('assets')
          .where('sn', isEqualTo: serialNumber)
          .limit(1)
          .get();

      if (assetQuery.docs.isNotEmpty) {
        // Get the asset data
        final assetDoc = assetQuery.docs.first;
        final asset = assetDoc.data() as Map<String, dynamic>;

        // Store the asset data
        assetData.value = Map<String, dynamic>.from(asset);

        // Get employee data if available
        if (asset.containsKey('assinee_id')) {
          var assigneeId = asset['assinee_id'];

          // Convert to string if it's not already
          if (assigneeId is int) {
            assigneeId = assigneeId.toString();
          }

          // Try to fetch with string ID first
          QuerySnapshot employeeQueryString = await FirebaseFirestore.instance
              .collection('employees')
              .where('id', isEqualTo: assigneeId)
              .limit(1)
              .get();

          // If not found, try with numeric ID
          if (employeeQueryString.docs.isEmpty && assigneeId is String) {
            int? numericId = int.tryParse(assigneeId);
            if (numericId != null) {
              QuerySnapshot employeeQueryNumber = await FirebaseFirestore.instance
                  .collection('employees')
                  .where('id', isEqualTo: numericId)
                  .limit(1)
                  .get();

              if (employeeQueryNumber.docs.isNotEmpty) {
                employeeData.value = Map<String, dynamic>.from(
                    employeeQueryNumber.docs.first.data() as Map<String, dynamic>
                );
              }
            }
          } else if (employeeQueryString.docs.isNotEmpty) {
            employeeData.value = Map<String, dynamic>.from(
                employeeQueryString.docs.first.data() as Map<String, dynamic>
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching asset details: $e');
    } finally {
      isloading_1.value = false;
    }
  }

  void updateSelectedCategory(String newCategory) {
    selectedCategory.value = newCategory;
  }

  void addAsset(Map<String, dynamic> assetData) async {
    try {
      await FirebaseFirestore.instance.collection('assets').add(assetData);

      fetchEmployeeAssets();
    } catch (e) {
      print('Error adding asset: $e');
    }
  }

  void updateAsset(int index, Map<String, dynamic> assetData) async {
    try {
      if (index >= 0 && index < assetDocIds.length) {
        String docId = assetDocIds[index];

        await FirebaseFirestore.instance
            .collection('assets')
            .doc(docId)
            .update(assetData);

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

        await FirebaseFirestore.instance
            .collection('assets')
            .doc(docId)
            .delete();

        assets.removeAt(index);
        assetDocIds.removeAt(index);
        assets.refresh();
        assetDocIds.refresh();

        totalAssets.value = assets.length;
      }
    } catch (e) {
      print('Error deleting asset: $e');
    }
  }
}
