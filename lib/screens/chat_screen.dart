import 'dart:developer';import 'package:chatgpt/constant/constant.dart';import 'package:chatgpt/models/chat_model.dart';import 'package:chatgpt/providers/models_provider.dart';import 'package:chatgpt/services/api_service.dart';import 'package:chatgpt/services/assets_manager.dart';import 'package:chatgpt/services/services.dart';import 'package:flutter/material.dart';import 'package:flutter_spinkit/flutter_spinkit.dart';import 'package:provider/provider.dart';import '../widgets/chat_widget.dart';class ChatScreen extends StatefulWidget {  const ChatScreen({Key? key}) : super(key: key);  @override  State<ChatScreen> createState() => _ChatScreenState();}class _ChatScreenState extends State<ChatScreen> {  bool _isTyping = false;  late TextEditingController textController;  late FocusNode focusNode;  @override  void initState() {    // TODO: implement initState    textController = TextEditingController();    focusNode = FocusNode();    super.initState();  }  @override  void dispose() {    textController.dispose();    focusNode.dispose();    super.dispose();  }  List<ChatModel> chatList = [];  @override  Widget build(BuildContext context) {    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);    return Scaffold(        appBar: AppBar(          elevation: 2,          leading: Padding(            padding: const EdgeInsets.all(8.0),            child: Image.asset(AssetsManager.openaiLogo),          ),          title: const Text("ChatGPT"),          actions: [            IconButton(                onPressed: () async {                  await Services.showModalSheet(context: context);                },                icon: const Icon(Icons.more_vert_rounded, color: Colors.white))          ],        ),        body: SafeArea(            child: Column(          children: [            Flexible(                child: ListView.builder(                    itemCount: chatList.length,                    itemBuilder: (context, index) {                      return ChatWidget(                        msg: chatList[index].msg,                        chatIndex: chatList[index].chatIndex,                      );                    })),            if (_isTyping) ...[              const SpinKitThreeBounce(                color: Colors.white,                size: 18,              ),            ],            SizedBox(height: 15),            Material(                color: cardColor,                child: Padding(                  padding: const EdgeInsets.all(8.0),                  child: Row(                    children: [                      Expanded(                          child: TextField(                        controller: textController,                        onSubmitted: (value) {                          //To Do send message                        },                        style: TextStyle(color: Colors.white),                        decoration: const InputDecoration.collapsed(                            hintText: "How can I help you?",                            hintStyle: TextStyle(color: Colors.black)),                      )),                      IconButton(                          onPressed: () async {                            sendMessageFunction(modelsProvider: modelsProvider);                          },                          icon: Icon(Icons.send, color: Colors.white))                    ],                  ),                ))          ],        )));  }  Future<void> sendMessageFunction(      {required ModelsProvider modelsProvider}) async {    try {      setState(() {        _isTyping = true;        chatList.add(ChatModel(msg: textController.text, chatIndex: 0));        textController.clear();        focusNode.unfocus();      });      chatList.addAll(await ApiService.sendMessage(          message: textController.text,          modelId: modelsProvider.getCurrentModel));      setState(() {});    } catch (e) {      log("Error $e");    } finally {      setState(() {        _isTyping = false;      });    }  }}