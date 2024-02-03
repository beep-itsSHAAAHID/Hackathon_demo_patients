import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDocuments extends StatefulWidget {
  const AddDocuments({Key? key}) : super(key: key);

  @override
  State<AddDocuments> createState() => _AddDocumentsState();
}

class _AddDocumentsState extends State<AddDocuments> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _getImageFromDevice(String documentType) async {
    try {
      final XFile? pickedFile =
      await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Convert the picked file to Uint8List
        Uint8List fileBytes = await pickedFile.readAsBytes();

        // Call a function to handle the document
        _handleDocument(documentType, fileBytes);

        // Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Display an error message if no image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No image selected.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleDocument(String documentType, Uint8List documentBytes) {
    // Replace this with your code to handle the document.
    // You can save it locally, send it to a server, or perform any desired action.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Documents',style: TextStyle(
          fontWeight: FontWeight.w500
        ),)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DocumentContainer(
                  icon: Icons.description,
                  label: 'Add Test Results',
                  onTap: () => _getImageFromDevice('Test Results'),
                ),
                DocumentContainer(
                  icon: Icons.local_hospital,
                  label: 'Add Prescriptions',
                  onTap: () => _getImageFromDevice('Prescriptions'),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DocumentContainer(
                  icon: Icons.scanner,
                  label: 'Add X-ray',
                  onTap: () => _getImageFromDevice('X-ray'),
                ),
                DocumentContainer(
                  icon: Icons.scanner,
                  label: 'Add Scans',
                  onTap: () => _getImageFromDevice('Scans'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DocumentContainer({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 80.0,
              color: Colors.blue,
            ),
            SizedBox(height: 16.0),
            Text(
              label,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
