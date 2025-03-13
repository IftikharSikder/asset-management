import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imgController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  RxInt lastEmployeeId = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _getLastEmployeeId();
  }

  Future<void> _getLastEmployeeId() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('employee')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var lastEmployee = snapshot.docs.first;
      lastEmployeeId.value = lastEmployee['id'];
    }
  }

  void addEmployee() {
    String name = nameController.text.trim();
    String img = imgController.text.trim();
    String designation = designationController.text.trim();
    String department = departmentController.text.trim();

    if (name.isEmpty || img.isEmpty || designation.isEmpty || department.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }


    isLoading.value = true;

    int newEmployeeId = lastEmployeeId.value + 1;

    FirebaseFirestore.instance.collection('employee').add({
      "name": name,
      "id": newEmployeeId,
      "img": img,
      "designation": designation,
      "department": department,
    }).then((_) {

      lastEmployeeId.value = newEmployeeId;

      isLoading.value = false;

      Get.snackbar(
          "Success",
          "Employee Added Successfully",
      );

      if(mounted){Navigator.of(context).pop();}
    }).catchError((error) {

      isLoading.value = false;

      Get.snackbar(
          "Error",
          "Failed to add employee: ${error.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3)
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Employee")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: imgController,
              decoration: InputDecoration(labelText: "Image URL"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: designationController,
              decoration: InputDecoration(labelText: "Designation"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: departmentController,
              decoration: InputDecoration(labelText: "Department"),
            ),
            SizedBox(height: 20),
            Obx(() => isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: addEmployee,
              child: Text("Add Employee"),
            )
            ),
          ],
        ),
      ),
    );
  }
}
