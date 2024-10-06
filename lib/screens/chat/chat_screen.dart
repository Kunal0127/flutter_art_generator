import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openai_test/provider/api_key_provider.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_openai_test/model/chat_complition_response_model.dart';
import 'package:flutter_openai_test/constant/constants.dart';
import 'package:flutter_openai_test/model/message_model.dart';
import 'package:flutter_openai_test/widget/card.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const kvalue = 15.0;
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // static const apiKey = OPENAI_API;
  String apiKey = "";
  final List<MessageModel> message = [MessageModel(isBot: true, message: "hi")];
  bool isBotTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    apiKey = Provider.of<ApiKeyProvider>(context).apiKey;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          // style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.green[400],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                shrinkWrap: true,
                itemCount: message.length,
                itemBuilder: (context, index) {
                  final isBot = message[index].isBot;
                  final alignment =
                      isBot ? Alignment.centerLeft : Alignment.centerRight;
                  return Align(
                    alignment: alignment,
                    child: card(
                      index: index,
                      alignment: alignment,
                      isBot: isBot,
                      message: message[index].message.trim(),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textController,
                        autofocus: false,
                        // decoration: InputDecoration(
                        //   hintText: 'Enter question here',
                        //   border: InputBorder.none,
                        //   contentPadding: EdgeInsets.all(8),
                        // ),
                        decoration: InputDecoration(
                          hintText: "Enter question here",
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.send,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter some text";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          askQuestion();
                        },
                      ),
                    ),
                    isBotTyping
                        ? Transform.scale(
                            scale: 0.8,
                            child: CircularProgressIndicator(
                              strokeWidth: 5,
                              color: Colors.blue,
                            ),
                          )
                        : IconButton.filled(
                            color: Colors.green[300],
                            onPressed: askQuestion,
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void askQuestion() async {
    if (_formKey.currentState!.validate()) {
      message.add(
        MessageModel(isBot: false, message: _textController.text),
      );
      setState(() => isBotTyping = true);

      final response = await http.post(
        Uri.parse(CHAT_COMPLITION_URL),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            // "messages": prompt,
            "messages": [
              {"role": "user", "content": _textController.text}
            ],
            "temperature": 0.7,
            "stream": false,
          },
        ),
      );
      _textController.clear();
      debugPrint("response: $response");
      debugPrint("response.body : ${response.body}");
      debugPrint("response.statuscode : ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          final chatComplitionResponseModel =
              ChatComplitionResponseModel.fromJson(
            jsonDecode(response.body),
          );
          message.add(
            MessageModel(
              isBot: true,
              message:
                  "${chatComplitionResponseModel.choices?[0].message?.content}",
            ),
          );
          isBotTyping = false;
        });
      }
    }
  }
}
