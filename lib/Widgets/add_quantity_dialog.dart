import 'package:chronicle/Models/payment_detail_model.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddQuantityDialog extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const AddQuantityDialog({Key key, this.scaffoldMessengerKey})
      : super(key: key);
  @override
  _AddQuantityDialogState createState() => _AddQuantityDialogState();
}

class _AddQuantityDialogState extends State<AddQuantityDialog> {
  // This widget is the root of your application.
  TextEditingController quantityController = new TextEditingController();
  TextEditingController remarksController = new TextEditingController();
  TextEditingController unitPriceController = new TextEditingController();
  List<int> items = [1, 2, 3, 4, 5, 12];
  bool _showCross = false;
  bool _showCrossUnitPrice = false;
  bool _showCrossRemarks = false;
  String modeOfPaymentDropDown;
  //Overrides
  @override
  void initState() {
    super.initState();
  }

  void handleSubmitted(value) {
    try {
      if (modeOfPaymentDropDown != null)
        Navigator.of(context).pop(new PaymentDetailsModel(
            noOfPayments: int.parse(quantityController.text),
            paymentType: modeOfPaymentDropDown,
            unitPrice: double.parse(unitPriceController.text),
            remarks: remarksController.text));
      else
        globalShowInSnackBar(
            widget.scaffoldMessengerKey, "Please select a mode of payment.");
    } catch (E) {
      globalShowInSnackBar(widget.scaffoldMessengerKey,
          "Invalid Values in quantity or unit price");
      quantityController.clear();
      unitPriceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 400,
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
                  suffixIcon: _showCross
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            quantityController.text = "";
                            setState(() {
                              _showCross = false;
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  if (value == "" && _showCross) {
                    setState(() {
                      _showCross = false;
                    });
                  } else if (!_showCross) {
                    setState(() {
                      _showCross = true;
                    });
                  }
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.none,
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
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          alignment: Alignment.center,
                          height: 20,
                          width: MediaQuery.of(context).size.width / 8,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1.0, style: BorderStyle.solid),
                          ),
                          child: Text(
                            items[id].toString(),
                            textScaleFactor: 1,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        onTap: () {
                          int newVal = ((quantityController.text != null &&
                                      quantityController.text.length != 0)
                                  ? int.parse(quantityController.text)
                                  : 0) +
                              items[id];
                          quantityController.text = newVal.toString();
                          if (!_showCross) {
                            setState(() {
                              _showCross = true;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: unitPriceController,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                    hintText: 'Enter Amount(per quantity)',
                    suffixIcon: _showCrossUnitPrice
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              unitPriceController.text = "";
                              setState(() {
                                _showCrossUnitPrice = false;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    if (value == "" && _showCrossUnitPrice) {
                      setState(() {
                        _showCrossUnitPrice = false;
                      });
                    } else if (!_showCrossUnitPrice) {
                      setState(() {
                        _showCrossUnitPrice = true;
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.none),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                value: modeOfPaymentDropDown,
                icon: Icon(Icons.arrow_downward),
                decoration: InputDecoration(
                  labelText: "Mode of Payment",
                  contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  border: const OutlineInputBorder(),
                ),
                items: <String>['Cash', 'Online'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    modeOfPaymentDropDown = newValue;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: remarksController,
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  hintText: 'Add Remarks',
                  suffixIcon: _showCrossRemarks
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            remarksController.text = "";
                            setState(() {
                              _showCrossRemarks = false;
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  if (value == "" && _showCrossRemarks) {
                    setState(() {
                      _showCrossRemarks = false;
                    });
                  } else if (!_showCrossRemarks) {
                    setState(() {
                      _showCrossRemarks = true;
                    });
                  }
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: handleSubmitted,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    handleSubmitted(null);
                  },
                  child: Text(
                    "Ok",
                    textScaleFactor: 1,
                    style: TextStyle(),
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
