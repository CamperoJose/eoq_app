import 'package:flutter/material.dart';

import 'chat_gpt_response.dart';

class ChatGPTMessage extends StatelessWidget {
  final String imageUrl;
  final List<double?> eoqData;

  const ChatGPTMessage({
    Key? key,
    required this.eoqData,
    this.imageUrl = 'assets/cait_gpt.jpeg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (eoqData[0] == 0 && eoqData[1] == 0 && eoqData[2] == null) {
      return buildMessage(context, 'Hola, en qué puedo ayudarte?');
    } else {
      return FutureBuilder<String>(
        future: getGPTAdvice(eoqData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildMessage(context, snapshot.data!);
          }
        },
      );
    }
  }

  Widget buildMessage(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
