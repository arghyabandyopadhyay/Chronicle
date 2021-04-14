import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AddQuantityDialog extends StatefulWidget {
  const AddQuantityDialog({Key key}) : super(key: key);
  @override
  _AddQuantityDialogState createState() => _AddQuantityDialogState();
}

class _AddQuantityDialogState extends State<AddQuantityDialog>  {
  // This widget is the root of your application.
  TextEditingController quantityController=new TextEditingController();
  List<int> items=[1,2,3,4,5,12];
  bool _showCross=false;
  //Overrides
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: quantityController,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Quantity',
                  suffixIcon:_showCross?IconButton(icon: Icon(Icons.clear),onPressed: (){
                    quantityController.text="";
                    setState(() {
                      _showCross=false;
                    });
                  },):null,
                ),
                onChanged: (value) {
                  if(value==""&&_showCross)
                  {
                    setState(() {
                      _showCross=false;
                    });
                  }
                  else if(!_showCross)
                  {
                    setState(() {
                      _showCross=true;
                    });
                  }
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(quantityController.text);
                  },
                  child: Text(
                    "Ok",textScaleFactor: 1,
                    style: TextStyle(),
                  ),
                ),
              ),
              new Flexible(
                child: Container(
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, id) {
                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2  ),
                          alignment: Alignment.center,
                          height: 20,
                          width: MediaQuery.of(context).size.width/8,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1.0,style: BorderStyle.solid),
                          ),
                          child: Text(items[id].toString(),
                            textScaleFactor: 1,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        onTap: (){
                          int newVal=((quantityController.text!=null&&quantityController.text.length!=0)?int.parse(quantityController.text):0)+items[id];
                          quantityController.text=newVal.toString();
                          if(!_showCross)
                          {
                            setState(() {
                              _showCross=true;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}