import 'package:chronicle/Models/registerModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RegisterOptionBottomSheet extends StatelessWidget {
  //list of options you want to show in the bottom sheet
  final List<RegisterModel>? list;
  const RegisterOptionBottomSheet({Key? key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        title: Text("Registers"),
        leading: IconButton(
          icon: Icon(Icons.addchart_outlined),
          onPressed: (){},
        ),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.clear), onPressed:(){
            //closes the modal on pressing the Icons Button
            Navigator.pop(context);
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(child:ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: list!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(list![index].name!),
                onTap: (){
                  print(list![index].name!);
                }
              );
            },
          ),)
        ],
      ),
    );

  }
}