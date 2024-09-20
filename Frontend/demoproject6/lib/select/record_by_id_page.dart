import 'package:flutter/material.dart';
import 'package:demoproject6/services/api_service/api_select.dart';

class RecordByIDPage extends StatefulWidget {
  const RecordByIDPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordByIDPageState createState() => _RecordByIDPageState();
}

class _RecordByIDPageState extends State<RecordByIDPage> {
  final TextEditingController _tableController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  Map<String, dynamic>? recordData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchRecordByID() async {
    String table = _tableController.text.trim();
    int id = int.tryParse(_idController.text.trim()) ?? 0;

    if (table.isEmpty || id == 0) {
      setState(() {
        errorMessage = 'Please enter a valid table name and ID.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var fetchedRecord = await ApiService().getRecordByID(table, id);
      setState(() {
        recordData = fetchedRecord;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record by ID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tableController,
              decoration: const InputDecoration(
                labelText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Record ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchRecordByID,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit'),
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (recordData != null)
              Card(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recordData!.entries.map((entry) {
                      return Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 16),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
