import 'package:chronicle/Modules/universal_module.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Models/client_model.dart';

import '../custom_colors.dart';

class ClientCardWidget extends StatefulWidget {
  final Key key;
  final ClientModel item;
  final double size;
  final Function onTapList;
  final Function onLongPressed;
  final Function onDoubleTap;
  final int index;
  ClientCardWidget(
      {this.item,
      this.key,
      this.size,
      this.onTapList,
      this.index,
      this.onLongPressed,
      this.onDoubleTap});
  @override
  _ClientCardWidgetState createState() => _ClientCardWidgetState();
}

class _ClientCardWidgetState extends State<ClientCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onTapList(widget.index);
        },
        onLongPress: () {
          widget.onLongPressed(widget.index);
        },
        onDoubleTap: () {
          widget.onDoubleTap(widget.index);
        },
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.only(bottom: 2),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            color: widget.item.isSelected ? Colors.grey.withOpacity(0.1) : null,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      this.widget.item.name,
                      style: TextStyle(fontWeight: FontWeight.w900),
                    )),
                    Text(
                      (this.widget.item.startDate != null
                              ? (getMonth(this.widget.item.startDate.month) +
                                  this.widget.item.startDate.day.toString() +
                                  "," +
                                  this.widget.item.startDate.year.toString() +
                                  " to ")
                              : "") +
                          ((this.widget.item.endDate != null)
                              ? (getMonth(this.widget.item.endDate.month) +
                                  this.widget.item.endDate.day.toString() +
                                  "," +
                                  this.widget.item.endDate.year.toString())
                              : ""),
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (this.widget.item.registrationId != null &&
                                this.widget.item.registrationId != ""
                            ? this.widget.item.registrationId
                            : this.widget.item.id.key),
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ),
                    Text("\u2706: " +
                        (this.widget.item.mobileNo != null
                            ? this.widget.item.mobileNo
                            : "N/A")),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (this.widget.item.address != null &&
                                this.widget.item.address != "")
                            ? ("Address: " + this.widget.item.address)
                            : "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                        this.widget.item.due == 0
                            ? "Last Month"
                            : ("${this.widget.item.due < 0 ? "Paid" : "Due"}: " +
                                (this.widget.item.due.abs() +
                                        (this.widget.item.due < 0 ? 1 : 0))
                                    .toString()),
                        style: TextStyle(
                            color: this.widget.item.due <= 0
                                ? this.widget.item.due == 0
                                    ? CustomColors.lastMonthTextColor
                                    : CustomColors.paidTextColor
                                : CustomColors.dueTextColor,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
