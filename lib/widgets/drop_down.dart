import 'package:chatgpt/constant/constant.dart';import 'package:flutter/material.dart';class ModalsDropDownWidget extends StatefulWidget {  const ModalsDropDownWidget({Key? key}) : super(key: key);  @override  State<ModalsDropDownWidget> createState() => _ModalsDropDownWidgetState();}class _ModalsDropDownWidgetState extends State<ModalsDropDownWidget> {  String currentModal = "model1";  @override  Widget build(BuildContext context) {    return DropdownButton(      dropdownColor: scaffoldBackgroundColor,        iconEnabledColor: Colors.white,        items: getModelsItem,        onChanged: (item) {          setState(() {            currentModal = item.toString();          });        });  }}