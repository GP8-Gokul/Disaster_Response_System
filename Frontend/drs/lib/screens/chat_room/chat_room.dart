import 'dart:async';

import 'package:drs/services/api/root_api.dart';
import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

import 'package:flutter_slidable/flutter_slidable.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});
  static String routeName = 'chat-room';

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  late Future<List<Map<String, dynamic>>> futureGetMessages;
  late int event;
  Timer? _timer;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        futureGetMessages = fetchdata('messages');
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    messageController.dispose(); 
    scrollController.dispose(); 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var eventId = args['event_id'];
    event = eventId;

    futureGetMessages = fetchdata('messages').then((messages) {
      devtools.log('Fetched messages: $messages');
      var newMessage = messages.where((message) => message['event_id'] == eventId).toList();
      devtools.log('Filtered messages: $newMessage');
      return newMessage;
    });
  }


  @override
  Widget build(BuildContext context) {

    

    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(imageName: 'background'),
            Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppbar(text: 'Chat Room'),
            body: Column(
              children: [
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureGetMessages,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(), 
                        children:[
                          SlidableAction(
                            backgroundColor: const Color.fromARGB(138, 236, 70, 70),
                            icon: Icons.delete,
                            foregroundColor: const Color.fromARGB(255, 238, 230, 230),
                            onPressed: (context) async {
                              if (chatDeleteAccess(snapshot.data![index]['sender'])) {
                                var response = await deleteData('messages', 'id', snapshot.data![index]['id']);
                                if (response != null) {
                                        setState(() {
                                        futureGetMessages = futureGetMessages.then((messages) {
                                          var updatedMessages = messages.where((message) => message['event_id'] == event).toList();
                                          updatedMessages.removeWhere((message) => message['id'] == snapshot.data![index]['id']);
                                          return updatedMessages;
                                        });
                                        });
                                }
                              } else {
                                customSnackBar(
                                    context: context,
                                    message:'You do not have access to delete this message.'
                                    );
                              }
                            },
                  )
                        ] 
                        ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                            '${snapshot.data![index]['sender']} : ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 12, 4, 242),
                            ),
                            ),
                            Expanded(
                              child: Text(
                              snapshot.data![index]['text'],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              overflow: TextOverflow.visible,
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                    },
                  );
                  } else if (snapshot.hasError) {
                  devtools.log('An error occurred ${snapshot.error}');
                  return Center(child: Text('An error occurred ${snapshot.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                children: [
                  Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    hintText: 'Enter your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    ),
                  ),
                  ),
                  IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    dynamic response = await insertData( {
                      'table': 'messages',
                      'sender': userName,
                      'text': messageController.text,
                      'event_id': event,
                    });
                    if(response != null){
                        setState(() {
                          var newMessage = {
                          'sender': userName,
                          'text': messageController.text,
                          'event_id': event,
                          };
                          futureGetMessages = futureGetMessages.then((messages) {
                          var updatedMessages = messages.where((message) => message['event_id'] == event).toList();
                          updatedMessages.add(newMessage);
                          return updatedMessages;
                          });
                          messageController.clear();
                        });
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                  }
                  },
                  ),
                ],
                ),
              ),
              ],
            ),
            )
        ],
      )
      );
  }
}