import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);

Future<String> generateResponse(String prompt) async {
  const apiKey = apiSecretKey;

  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      'temperature': 0,
      'max_tokens': 2000,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    }),
  );

  // Do something with the response
  Map<String, dynamic> newresponse = jsonDecode(response.body);

  return newresponse['choices'][0]['text'];
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "RealAssist.AI",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Visibility(
                child: Text(
              'This is private message, between you and Assistant.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ))
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Text(
                                'Creating blog content specific to real estate'),
                            SizedBox(
                              width: 60,
                            ),
                            Icon(
                              Icons.arrow_outward,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Text(
                                'Creating blog content sepcific to real estate'),
                            SizedBox(
                              width: 60,
                            ),
                            Icon(
                              Icons.arrow_outward,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Text(
                                'Creating email drip campaign content for your client'),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_outward,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Text(
                                'Writing answers to your clients texts/emails'),
                            SizedBox(
                              width: 55,
                            ),
                            Icon(
                              Icons.arrow_outward,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildInput(),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: Colors.blue,
        child: IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: Colors.white,
          ),
          onPressed: () async {
            setState(
              () {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
          },
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.grey),
        controller: _textController,
        decoration: const InputDecoration(
          hintText: 'Ask RealAssist Something',
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(25),
      color:
          chatMessageType == ChatMessageType.bot ? Colors.white : Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.smart_toy,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
