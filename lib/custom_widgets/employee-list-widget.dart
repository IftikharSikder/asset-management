// import 'package:asset_management/screens/edit_employee_screen.dart';
// import 'package:asset_management/screens/employee_details.dart';
// import 'package:asset_management/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
//
// class EmployeeListWidget extends StatefulWidget {
//   final Query<Object?> query;
//   final Function refreshDepartments;
//   final Function? onEmployeeDeleted;
//
//   const EmployeeListWidget({
//     Key? key,
//     required this.query,
//     required this.refreshDepartments,
//     this.onEmployeeDeleted,
//   }) : super(key: key);
//
//   @override
//   _EmployeeListWidgetState createState() => _EmployeeListWidgetState();
// }
//
// class _EmployeeListWidgetState extends State<EmployeeListWidget> {
//   List<DocumentSnapshot> employees = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchEmployees();
//   }
//
//   void _fetchEmployees() {
//     widget.query.snapshots().listen((snapshot) {
//       if (mounted) {
//         setState(() {
//           employees = snapshot.docs;
//           isLoading = false;
//         });
//       }
//     }, onError: (error) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//         Get.snackbar(
//           "Error",
//           "Failed to load employees: $error",
//           backgroundColor: Colors.red[100],
//           colorText: Colors.red[800],
//         );
//       }
//     });
//   }
//
//   Future<void> deleteEmployee(String id, int index) async {
//     setState(() {
//       employees.removeAt(index);
//     });
//
//     if (widget.onEmployeeDeleted != null) {
//       widget.onEmployeeDeleted!();
//     }
//
//     try {
//       final employeesRef = FirebaseFirestore.instance.collection('employee');
//       final employeeDoc = await employeesRef.doc(id).get();
//
//       if (employeeDoc.exists) {
//         final employeeId = employeeDoc['id'];
//
//         final assetDocs = await FirebaseFirestore.instance
//             .collection('assets')
//             .where('assinee_id', isEqualTo: employeeId)
//             .get();
//
//         // Create a batch for deleting assets
//         WriteBatch batch = FirebaseFirestore.instance.batch();
//         for (var assetDoc in assetDocs.docs) {
//           batch.delete(assetDoc.reference);
//         }
//
//         // Execute batch deletion
//         await batch.commit();
//
//         // After assets are deleted, delete the employee
//         await employeesRef.doc(id).delete();
//
//         // Show success message
//         Get.snackbar(
//           "Success",
//           "Employee and all associated assets deleted successfully",
//           backgroundColor: Colors.green[100],
//           colorText: Colors.green[800],
//           duration: Duration(seconds: 3),
//         );
//       }
//     } catch (error) {
//       // Show error message if deletion fails
//       Get.snackbar(
//         "Error",
//         "Failed to delete: $error",
//         backgroundColor: Colors.red[100],
//         colorText: Colors.red[800],
//         duration: Duration(seconds: 3),
//       );
//
//       // Note: We don't restore the item in the UI because Firestore will
//       // automatically update the stream if the deletion failed
//     }
//   }
//
//   void navigateToEditScreen(BuildContext context, DocumentSnapshot employee) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditEmployeeScreen(
//           id: employee.id,
//           name: employee['name'],
//           designation: employee['designation'],
//           department: employee['department'],
//         ),
//       ),
//     ).then((_) {
//       widget.refreshDepartments();
//       if (widget.onEmployeeDeleted != null) {
//         widget.onEmployeeDeleted!();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     if (employees.isEmpty) {
//       return Center(child: Text("No employees found"));
//     }
//
//     return ListView.builder(
//       itemCount: employees.length,
//       itemBuilder: (context, index) {
//         var employee = employees[index];
//         return Dismissible(
//           key: Key(employee.id),
//           direction: DismissDirection.endToStart,
//           onDismissed: (direction) {
//             // Call delete function with index for immediate UI update
//             deleteEmployee(employee.id, index);
//           },
//           background: Container(
//             color: Colors.red,
//             alignment: Alignment.centerRight,
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Icon(Icons.delete, color: Colors.white),
//           ),
//           child: Card(
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             color: AppColors.background,
//             elevation: 1,
//             child: ListTile(
//               contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//               leading: CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: NetworkImage(employee['img']),
//               ),
//               title: Text(
//                 employee['name'],
//                 style: AppTextStyles.employeeName,
//               ),
//               subtitle: Text(
//                 employee['designation'],
//                 style: AppTextStyles.employeeTitle,
//               ),
//               trailing: IconButton(
//                 icon: Icon(
//                   Icons.edit,
//                   color: AppColors.iconBlue,
//                 ),
//                 onPressed: () => navigateToEditScreen(context, employee),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EmployeeDetailScreen(employee),
//                   ),
//                 ).then((_) {
//                   widget.refreshDepartments();
//                   if (widget.onEmployeeDeleted != null) {
//                     widget.onEmployeeDeleted!();
//                   }
//                 });
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//


import 'package:asset_management/screens/edit_employee_screen.dart';
import 'package:asset_management/screens/employee_details.dart';
import 'package:asset_management/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EmployeeListWidget extends StatefulWidget {
  final Query<Object?> query;
  final Function refreshDepartments;
  final Function? onEmployeeDeleted;

  const EmployeeListWidget({
    Key? key,
    required this.query,
    required this.refreshDepartments,
    this.onEmployeeDeleted,
  }) : super(key: key);

  @override
  _EmployeeListWidgetState createState() => _EmployeeListWidgetState();
}

class _EmployeeListWidgetState extends State<EmployeeListWidget> {
  List<DocumentSnapshot> employees = [];
  bool isLoading = true;
  Stream<QuerySnapshot>? _employeeStream;

  @override
  void initState() {
    super.initState();
    _setupEmployeeStream();
  }

  @override
  void didUpdateWidget(EmployeeListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This is key: detect when the query changes and update the stream
    if (oldWidget.query != widget.query) {
      _setupEmployeeStream();
    }
  }

  void _setupEmployeeStream() {
    setState(() {
      isLoading = true;
    });

    _employeeStream = widget.query.snapshots();

    _employeeStream!.listen((snapshot) {
      if (mounted) {
        setState(() {
          employees = snapshot.docs;
          isLoading = false;
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
          "Error",
          "Failed to load employees: $error",
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    });
  }

  Future<void> deleteEmployee(String id, int index) async {
    setState(() {
      employees.removeAt(index);
    });

    if (widget.onEmployeeDeleted != null) {
      widget.onEmployeeDeleted!();
    }

    try {
      final employeesRef = FirebaseFirestore.instance.collection('employee');
      final employeeDoc = await employeesRef.doc(id).get();

      if (employeeDoc.exists) {
        final employeeId = employeeDoc['id'];

        final assetDocs = await FirebaseFirestore.instance
            .collection('assets')
            .where('assinee_id', isEqualTo: employeeId)
            .get();

        // Create a batch for deleting assets
        WriteBatch batch = FirebaseFirestore.instance.batch();
        for (var assetDoc in assetDocs.docs) {
          batch.delete(assetDoc.reference);
        }

        // Execute batch deletion
        await batch.commit();

        // After assets are deleted, delete the employee
        await employeesRef.doc(id).delete();

        // Show success message
        Get.snackbar(
          "Success",
          "Employee and all associated assets deleted successfully",
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          duration: Duration(seconds: 3),
        );
      }
    } catch (error) {
      // Show error message if deletion fails
      Get.snackbar(
        "Error",
        "Failed to delete: $error",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: Duration(seconds: 3),
      );

      // Note: We don't restore the item in the UI because Firestore will
      // automatically update the stream if the deletion failed
    }
  }

  void navigateToEditScreen(BuildContext context, DocumentSnapshot employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeeScreen(
          id: employee.id,
          name: employee['name'],
          designation: employee['designation'],
          department: employee['department'],
        ),
      ),
    ).then((_) {
      widget.refreshDepartments();
      if (widget.onEmployeeDeleted != null) {
        widget.onEmployeeDeleted!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (employees.isEmpty) {
      return Center(child: Text("No employees found"));
    }

    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        var employee = employees[index];
        return Dismissible(
          key: Key(employee.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Call delete function with index for immediate UI update
            deleteEmployee(employee.id, index);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.background,
            elevation: 1,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(employee['img']),
              ),
              title: Text(
                employee['name'],
                style: AppTextStyles.employeeName,
              ),
              subtitle: Text(
                employee['designation'],
                style: AppTextStyles.employeeTitle,
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppColors.iconBlue,
                ),
                onPressed: () => navigateToEditScreen(context, employee),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeDetailScreen(employee),
                  ),
                ).then((_) {
                  widget.refreshDepartments();
                  if (widget.onEmployeeDeleted != null) {
                    widget.onEmployeeDeleted!();
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }
}