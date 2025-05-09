import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeService {
  final CollectionReference employeesRef = FirebaseFirestore.instance.collection('employee');

  Future<void> deleteEmployee(String id) async {
    try {
      DocumentSnapshot employeeDoc = await employeesRef.doc(id).get();
      
      if (employeeDoc.exists) {
        final employeeId = employeeDoc['id'];

        QuerySnapshot assetDocs = await FirebaseFirestore.instance
            .collection('assets')
            .where('assinee_id', isEqualTo: employeeId)
            .get();

        WriteBatch batch = FirebaseFirestore.instance.batch();

        // Add all asset documents to the batch for deletion
        for (var assetDoc in assetDocs.docs) {
          batch.delete(assetDoc.reference);
        }


        await batch.commit();
        

        await employeesRef.doc(id).delete();


        Get.snackbar(
          "Success",
          "Employee and all associated assets deleted successfully",
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          duration: Duration(seconds: 3),
        );
      } else {

        Get.snackbar(
          "Error",
          "Employee not found",
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (error) {

      Get.snackbar(
        "Error",
        "Failed to delete: $error",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: Duration(seconds: 3),
      );
    }
  }
}
