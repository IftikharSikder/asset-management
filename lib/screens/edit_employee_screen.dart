import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEmployeeScreen extends StatefulWidget {
  final String id, name, designation, department;

  const EditEmployeeScreen({super.key,
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
  });

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late TextEditingController designationController;
  late TextEditingController departmentController;

  @override
  void initState() {
    super.initState();
    designationController = TextEditingController(text: widget.designation);
    departmentController = TextEditingController(text: widget.department);
  }

  @override
  void dispose() {
    designationController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  void saveChanges() {
    FirebaseFirestore.instance.collection('employee').doc(widget.id).update({
      "designation": designationController.text,
      "department": departmentController.text,
    }).then((_) {
      if(mounted){
        Navigator.pop(context);
      }
    }).catchError((error) {
      print("Error updating employee: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Employee")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.name,
              decoration: InputDecoration(labelText: "Name"),
              enabled: false, // Name cannot be changed
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: designationController,
              decoration: InputDecoration(labelText: "Designation"),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: departmentController,
              decoration: InputDecoration(labelText: "Department"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
