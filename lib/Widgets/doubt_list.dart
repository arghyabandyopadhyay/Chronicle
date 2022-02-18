import 'package:chronicle/Models/CourseModels/doubtModel.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoubtList extends StatelessWidget {
  final List<DoubtModel> listItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final ScrollController scrollController;
  final bool isTutor;
  final TextEditingController textEditingController;
  DoubtList(
      {this.listItems,
      this.scaffoldMessengerKey,
      this.scrollController,
      this.isTutor,
      this.textEditingController});
  @override
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 100),
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          title: Text(listItems[index].question),
          subtitle: Text(listItems[index].answer != null
              ? listItems[index].answer
              : "Not answered yet by the instructor."),
          trailing: isTutor
              ? IconButton(
                  icon: Icon(Icons.quickreply_outlined),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                              title: Text(listItems[index].question),
                              content: TextField(
                                controller: textEditingController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Reply",
                                  contentPadding: EdgeInsets.only(
                                      bottom: 10.0, left: 10.0, right: 10.0),
                                ),
                              ),
                              actions: [
                                ActionChip(
                                    label: Text("Reply"),
                                    onPressed: () {
                                      if (textEditingController.text != "") {
                                        listItems[index].answer =
                                            textEditingController.text;
                                        listItems[index].replyToDoubtToVideo();
                                        textEditingController.clear();
                                        Navigator.pop(_);
                                      } else {
                                        globalShowInSnackBar(
                                            scaffoldMessengerKey,
                                            "Please enter a valid reply for the doubt!!");
                                        Navigator.of(_).pop();
                                      }
                                    }),
                                ActionChip(
                                    label: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(_).pop();
                                    }),
                              ],
                            ));
                  },
                )
              : null,
        );
      },
    );
  }
}
