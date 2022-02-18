import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/OwnerModules/chronicle_user_details.dart';
import 'package:chronicle/OwnerModules/chronicle_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChronicleUsersList extends StatefulWidget {
  final List<ChronicleUserModel> listItems;
  final Function refreshData;
  final ScrollController scrollController;
  ChronicleUsersList(this.listItems, this.refreshData, this.scrollController);
  @override
  _ChronicleUsersListState createState() => _ChronicleUsersListState();
}

class _ChronicleUsersListState extends State<ChronicleUsersList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        displacement: 10,
        key: _refreshIndicatorKey,
        onRefresh: widget.refreshData,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          itemCount: this.widget.listItems.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (chronicleUserDetailsContext) =>
                        ChronicleUserDetailsPage(
                          user: this.widget.listItems[index],
                        )));
              },
              child: Card(
                color: this.widget.listItems[index].cloudStorageSize <
                        this.widget.listItems[index].cloudStorageSizeLimit
                    ? Colors.transparent
                    : Colors.red.withOpacity(0.5),
                elevation: 0,
                margin: EdgeInsets.only(bottom: 2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            this.widget.listItems[index].displayName,
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            this.widget.listItems[index].email,
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "${classifySize(this.widget.listItems[index].cloudStorageSize)} of ${classifySize(this.widget.listItems[index].cloudStorageSizeLimit)}",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      )),
                      IconButton(
                          icon:
                              this.widget.listItems[index].isAppRegistered == 1
                                  ? Icon(
                                      Icons.desktop_access_disabled_outlined,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.how_to_reg_outlined,
                                      color: Colors.green,
                                    ),
                          onPressed: () {
                            setState(() {
                              this.widget.listItems[index].isAppRegistered =
                                  (this
                                              .widget
                                              .listItems[index]
                                              .isAppRegistered +
                                          1) %
                                      2;
                              this.widget.listItems[index].update(true);
                            });
                          })
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
