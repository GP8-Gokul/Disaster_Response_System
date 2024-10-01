// import 'package:flutter/material.dart';

// class DisplayDisasterEvents extends StatelessWidget {
//   final Map<String, dynamic> event;

//   const DisplayDisasterEvents({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       shadowColor: const Color.fromARGB(255, 35, 33, 33),
//       color: const Color.fromARGB(245, 35, 32, 32),
//       margin: const EdgeInsets.only(
//           top: 64.0, left: 16.0, right: 16.0, bottom: 96.0),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Event ID',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 event['event_id'].toString(),
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               const Text(
//                 'Event Name',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 event['event_name'],
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               const Text(
//                 'Event Type',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 event['event_type'],
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               const Text(
//                 'Location',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 event['location'],
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       const Text(
//                         'Start Date',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white54,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         event['start_date'],
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       const Text(
//                         'End Date',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white54,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         event['end_date'],
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const Divider(color: Colors.white24, height: 24),
//               const Text(
//                 'Description',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white54,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 event['description'] ?? 'No description available',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
