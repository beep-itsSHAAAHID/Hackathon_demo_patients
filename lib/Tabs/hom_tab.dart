import 'package:flutter/material.dart';
import '../blockchain_add_view_data/documents.dart';
import '../core/color.dart';
import '../core/text.dart';
import '../pages/ai_doctor.dart';
import '../pages/doctordetails_page.dart';
import '../widgets/buildSpecialization.dart';
import '../pages/appointmentpage.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(),
              SizedBox(
                width: 20,
              ),
              Text(
                "Hello name!",
                style: AppTextStyle.subtext.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.black),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Select a Doctor Specialization:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            child: buildSpecializationList(),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Nearby Doctors:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: buildNearbyDoctorsList(context),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return ChatBot();
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border:
                      Border.all(color: AppColors.textblue, width: 2)),
                  child: Text("AI Doctor"),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return AppointmentDetailsPage();
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border:
                      Border.all(color: AppColors.textblue, width: 2)),
                  child: Text("Book Appointment"),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return AppointmentDetailsPage();
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border:
                        Border.all(color: AppColors.textblue, width: 2)),
                    child: Text("View My Bookings"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return AddDocuments();
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border:
                        Border.all(color: AppColors.textblue, width: 2)),
                    child: Text("Add Documents"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNearbyDoctorsList(BuildContext context) {
    List<Map<String, String>> nearbyDoctors = [
      {
        'name': 'Dr. John Doe',
        'image': 'assets/doctor.jpg',
      },
      {
        'name': 'Dr. Jane Smith',
        'image': 'assets/doctor.jpg',
      },
      {
        'name': 'Dr. Jane Smith',
        'image': 'assets/doctor.jpg',
      }
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final doctor in nearbyDoctors)
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsPage(doctor: doctor),
                    ),
                  );
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(doctor['image']!),
                    ),
                    SizedBox(height: 10),
                    Text(
                      doctor['name']!,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
