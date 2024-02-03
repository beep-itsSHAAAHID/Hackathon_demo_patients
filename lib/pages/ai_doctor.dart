import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final apikey = "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";
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> chatMessages = [];
  bool isLoading = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage(String message) async {
    if (message.trim().isEmpty) {
      print('Empty message. Nothing to send.');
      return;
    }

    setState(() {
      isLoading = true;
      chatMessages.add(ChatMessage(text: message, isUser: true));
    });

    try {
      final request = http.Request(
        'POST',
        Uri.parse("https://api.openai.com/v1/chat/completions"),
      );
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apikey',
      });
      request.body = jsonEncode({
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 150,
        'model': 'gpt-3.5-turbo', // Specify the GPT model
      });

      final response =
      await request.send().timeout(const Duration(seconds: 10));

      print('Request URL: ${request.url}');
      print('Request headers: ${request.headers}');
      print('Request body: ${request.body}');

      final responseString = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseString');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseString);
        setState(() {
          chatMessages.add(ChatMessage(
            text: jsonResponse['choices'][0]['message']['content'].trim(),
            isUser: false,
          ));
          isLoading = false;
        });
      } else {
        print("Request failed with status: ${response.statusCode}.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Caught error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("AI Doctor"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (ctx, index) {
                  final message = chatMessages[index];
                  return ChatBubble(
                    text: message.text,
                    isUser: message.isUser,
                  );
                },
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: 'Enter your message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(messageController.text);
                      messageController.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text("AI"),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (isUser)
            const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person),
            ),
        ],
      ),
    );
  }
}