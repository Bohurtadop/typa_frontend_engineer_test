import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailScreen({super.key, required this.item});

  @override
  // ignore: library_private_types_in_public_api
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  File? _image;
  int _numberOfStudents = 0;
  final TextEditingController _studentsController = TextEditingController();

  @override
  void dispose() {
    // Liberar el controlador cuando el widget se descarte
    _studentsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _numberOfStudents = 0;
    });
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.item['image'] = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.item['image'] != null
                ? Image.file(
                    widget.item['image']!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _getImage,
                child: const Text('Upload image'),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Name: ${widget.item['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Country: ${widget.item['country']}'),
            const SizedBox(height: 8),
            _numberOfStudents == 0
                ? Text('Number of students: ${widget.item['numberOfStudents']}')
                : const Text('Number of students: Unknown'),
            const SizedBox(height: 8),
            Text('Code: ${widget.item['alpha_two_code']}'),
            const SizedBox(height: 8),
            Text('Domains: ${widget.item['domains'].join(', ')}'),
            const SizedBox(height: 8),
            const Text('Web pages:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.item['web_pages'].map<Widget>((webPage) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: InkWell(
                    onTap: () async {
                      final url = Uri.parse(webPage);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'No se pudo abrir la URL: $url';
                      }
                    },
                    child: Text(
                      webPage,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _studentsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of students',
                hintText: 'Enter the number of students',
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  _saveNumberOfStudents();
                },
                child: const Text('Save number of students'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveNumberOfStudents() {
    final String numberOfStudents = _studentsController.text;

    if (numberOfStudents.isNotEmpty && int.tryParse(numberOfStudents) != null) {
      widget.item['numberOfStudents'] = int.parse(numberOfStudents);
      setState(() {
        _numberOfStudents:
        int.parse(numberOfStudents);
      });

      _studentsController.clear();

      _showConfirmationDialog('Number of students saved correctly.');
    } else {
      _showErrorDialog('Please enter a valid number of students.');
    }
  }

  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Successfull'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }
}
