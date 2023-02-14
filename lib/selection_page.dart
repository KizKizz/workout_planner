import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    final selectedOptionIndex = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          title: Text(selectedOptionIndex),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [ElevatedButton(onPressed: (){

          }, child:const Text('Build Muscle')),
          ElevatedButton(onPressed: (){

          }, child:const Text('Lose Weight')),
          ElevatedButton(onPressed: (){

          }, child:const Text('Full Equiptment')),
          ElevatedButton(onPressed: (){

          }, child:const Text('No Equiptment'))],),),
        );
  }
}
