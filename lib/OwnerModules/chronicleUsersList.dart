import 'package:chronicle/OwnerModules/chronicleUserDetails.dart';
import 'package:chronicle/OwnerModules/chronicleUserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ownerDatabaseModule.dart';

class ChronicleUsersList extends StatefulWidget {
  final List<ChronicleUserModel> listItems;
  final Function refreshData;
  ScrollController scrollController;
  ChronicleUsersList(this.listItems,this.refreshData,this.scrollController);
  @override
  _ChronicleUsersListState createState() => _ChronicleUsersListState();
}

class _ChronicleUsersListState extends State<ChronicleUsersList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        displacement: 10,
        key: _refreshIndicatorKey,
        onRefresh: widget.refreshData,
        child:ListView.builder(
          controller: widget.scrollController,
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            Navigator.of(context).push(new CupertinoPageRoute(builder: (context)=>ChronicleUserDetailsPage(user: widget.listItems[index],)));
          },
          title: Text(this.widget.listItems[index].displayName,style: TextStyle(fontWeight: FontWeight.w900),),
          subtitle: Text(this.widget.listItems[index].email,style: TextStyle(fontWeight: FontWeight.w300),),
          trailing: IconButton(icon: this.widget.listItems[index].canAccess==1?Icon(Icons.desktop_access_disabled_outlined,color: Colors.red,):Icon(Icons.how_to_reg_outlined,color: Colors.green,),onPressed: (){
            setState(() {
              this.widget.listItems[index].canAccess=(this.widget.listItems[index].canAccess+1)%2;
              updateChronicleUserDetails(this.widget.listItems[index], this.widget.listItems[index].id);
            });
          },)
        );
      },
    ));
  }
}
