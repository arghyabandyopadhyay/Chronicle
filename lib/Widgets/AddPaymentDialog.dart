import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPaymentDialog extends StatelessWidget  {
  // This widget is the root of your application.
  const AddPaymentDialog({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("No of Months",textScaleFactor:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      content: Text("How many months do you want to make a payment of?",textScaleFactor:1,style: TextStyle(fontSize: 17),),
      actions: [
        CupertinoDialogAction(child: Text(
          "1", style: TextStyle(fontSize:20),
        ),
          onPressed: (){
            Navigator.of(context).pop(1);
          },
        ),
        CupertinoDialogAction(child: Text(
          "3", style: TextStyle(fontSize:20),
        ),
          onPressed: (){
            Navigator.of(context).pop(3);
          },
        ),
        CupertinoDialogAction(child: Text(
          "12", style: TextStyle(fontSize:20),
        ),
          onPressed: (){
            Navigator.of(context).pop(12);
          },
        ),
      ],
    );
  }
}