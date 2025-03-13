import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_details_controller.dart';
import '../utils/constants.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0 * textScale),
      child: Row(
        children: [
          Icon(icon, size: 20 * textScale, color: Colors.blueAccent),
          SizedBox(width: 8 * textScale),
          Text(label + ': ',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14 * textScale)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 14 * textScale)),
          ),
        ],
      ),
    );
  }
}

class EmployeeAssetsDetailScreen extends StatelessWidget {
  final String serialNumber;
  final DocumentSnapshot employee;

  EmployeeAssetsDetailScreen({
    Key? key,
    required this.serialNumber,
    required this.employee,
  }) : super(key: key);

  String _getMonthName(int month) {
    const monthNames = ['', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return monthNames[month];
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeDetailsController());
    controller.fetchEmployeeAssetsDetails(serialNumber);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Asset Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final assetData = controller.assetData.value;
        if (assetData.isEmpty) {
          return Center(child: Text('Asset not found'));
        }

        final assetName = assetData['name'] ?? 'Unknown Asset';
        final assetSN = assetData['sn'] ?? 'N/A';
        final assetImage = assetData['image_url'] ??
            'https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg';
        final employeeImage = employee['img'] ?? 'https://img.freepik.com/free-vector/cheerful-rabbit-cartoon-character-smiling-vector-style_1308-161809.jpg';
        final employeeName = employee['name'] ?? 'Unassigned';
        final employeePosition = employee['designation'] ?? 'No Position';
        final department = employee['department'] ?? 'Not specified';

        // Handle timestamp and duration calculation
        final assignedTimestamp = assetData['timestamp'];
        String assignedDateText = 'Not specified';
        String durationText = 'N/A';
        String debugInfo = ''; // Add debug info

        if (assignedTimestamp is Timestamp) {
          final assignedDate = assignedTimestamp.toDate().toUtc();
          final currentDate = DateTime.now().toUtc();

          assignedDateText = '${_getMonthName(assignedDate.month)} ${assignedDate.day}, ${assignedDate.year}';

          if (currentDate.isAfter(assignedDate)) {
            final difference = currentDate.difference(assignedDate);
            durationText = '${difference.inDays+1} days';
          } else {
            durationText = '1 days (future date)';
          }
        } else {
          debugInfo = 'Timestamp type: ${assignedTimestamp.runtimeType}';
        }


        print('DEBUG INFO: $debugInfo');

        return ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          assetImage,
                          height: screenHeight * 0.35,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assetName,
                            style: TextStyle(
                                fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            assetSN,
                            style:
                            TextStyle(fontSize: screenWidth * 0.04, color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(employeeImage),
                          radius: screenWidth * 0.07,
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employeeName,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              employeePosition,
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: screenWidth * 0.04),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    InfoRow(icon: Icons.calendar_today, label: 'Assigned Date', value: assignedDateText),
                    InfoRow(icon: Icons.access_time, label: 'Duration', value: durationText),
                    InfoRow(icon: Icons.business, label: 'Department', value: department),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}