import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {
  final CollectionReference employeesRef = FirebaseFirestore.instance.collection('employee');

  final departments = <String>[].obs;
  final selectedDepartment = Rx<String?>('All Employees');
  final isLoadingDepartments = false.obs;

  final employeeCount = 0.obs;
  final isCountLoading = false.obs;

  StreamSubscription<QuerySnapshot>? _employeeSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
    refreshEmployeeCount();
  }

  @override
  void onClose() {
    _employeeSubscription?.cancel();
    super.onClose();
  }

  void setupEmployeeListener() {
    _employeeSubscription?.cancel();
    _employeeSubscription = getFilteredQuery().snapshots().listen((snapshot) {
      employeeCount.value = snapshot.size;
    }, onError: (error) {
      print('Error in employee listener: $error');
    });
  }

  Future<void> refreshEmployeeCount() async {
    try {
      isCountLoading.value = true;

      if (selectedDepartment.value == null || selectedDepartment.value == 'All Employees') {
        final AggregateQuerySnapshot snapshot = await employeesRef.count().get();
        employeeCount.value = snapshot.count!;
      } else {
        final QuerySnapshot snapshot = await employeesRef
            .where('department', isEqualTo: selectedDepartment.value)
            .get();
        employeeCount.value = snapshot.size;
      }
    } catch (e) {
      print('Error fetching employee count: $e');
      try {
        final QuerySnapshot snapshot = await getFilteredQuery().get();
        employeeCount.value = snapshot.size;
      } catch (e) {
        print('Fallback count also failed: $e');
        employeeCount.value = 0;
      }
    } finally {
      isCountLoading.value = false;
    }
  }

  Future<void> fetchDepartments() async {
    try {
      isLoadingDepartments.value = true;
      QuerySnapshot snapshot = await employeesRef.get();
      Set<String> uniqueDepartments = {};

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('department') && data['department'] != null && data['department'].toString().isNotEmpty) {
          uniqueDepartments.add(data['department']);
        }
      }

      departments.value = ['All Employees', ...uniqueDepartments.toList()];

      refreshEmployeeCount();
    } catch (e) {
      print('Error fetching departments: $e');
    } finally {
      isLoadingDepartments.value = false;
    }
  }

  Query<Object?> getFilteredQuery() {
    if (selectedDepartment.value == null || selectedDepartment.value == 'All Employees') {
      return employeesRef.orderBy('id');
    } else {
      return employeesRef.where('department', isEqualTo: selectedDepartment.value);
    }
  }
}
