import 'package:flutter/material.dart';
import 'package:demoproject6/services/api_service/api_select.dart';

class RecordByIDPage extends StatefulWidget {
  const RecordByIDPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordByIDPageState createState() => _RecordByIDPageState();
}

class _RecordByIDPageState extends State<RecordByIDPage> {
  final TextEditingController _idController = TextEditingController();
  Map<String, dynamic>? recordData;
  bool isLoading = false;
  String? errorMessage;
  final Map<String, String> tableMap = {
    'Disaster Events': 'disaster_events',
    'Resources': 'resources',
    'Volunteers': 'volunteers',
    'Aid Distribution': 'aid_distribution',
    'Incident Reports': 'incident_reports',
  };

  String? selectedTable;

  Future<void> fetchRecordByID() async {
    int id = int.tryParse(_idController.text.trim()) ?? 0;

    if (selectedTable == null || id == 0) {
      setState(() {
        errorMessage = 'Please select a table and enter a valid ID.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      var fetchedRecord = await ApiService().getRecordByID(selectedTable!, id);
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
            DropdownButtonFormField<String>(
              value: selectedTable,
              items: tableMap.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTable = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Table',
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
