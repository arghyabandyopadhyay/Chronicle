import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
class ContactListPage extends StatefulWidget {
  const ContactListPage({Key key}) : super(key: key);
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> _contacts;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _isSearching=false;
  List<Contact> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  //Widgets
  Widget appBarTitle = Text("",
    textScaleFactor: 1,
    style: TextStyle(
        fontSize: 24.0,
        height: 2.5),
  );
  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
      );
      this.appBarTitle = Text("Contacts",
      );
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=_contacts.where((Contact element) => (element.displayName.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))).toList();
      setState(() {
      });
    }
  }
  @override
  initState() {
    super.initState();
    refreshContacts();
    appBarTitle=Text("Contacts");
  }
  refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // Load without thumbnails initially.
      var contacts = (await ContactsService.getContacts(withThumbnails: false))
          .toList();
      setState(() {
        _contacts = contacts;
      });

      // Lazy load thumbnails after rendering initial contacts.
      for (final contact in contacts) {
        ContactsService.getAvatar(contact).then((avatar) {
          if (avatar == null) return; // Don't redraw if no change.
          setState(() => contact.avatar = avatar);
        });
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }
  updateContact() async {
    Contact ninja = _contacts.toList().firstWhere((contact) => contact.familyName.startsWith("Ninja"));
    ninja.avatar = null;
    await ContactsService.updateContact(ninja);

    refreshContacts();
  }
  Future<PermissionStatus> _getContactPermission() async {
    return await Permission.contacts.request();
  }
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      globalShowInSnackBar(scaffoldMessengerKey, "Access Denied by the user!!");
    } else if (permissionStatus == PermissionStatus.restricted) {
      globalShowInSnackBar(scaffoldMessengerKey, "Location data is not available on device");
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appBarTitle,
        leading: IconButton(onPressed: () { if(!_isSearching)Navigator.of(context).pop(); }, icon: Icon(_isSearching?Icons.search:(Icons.contacts)),),
        actions: [
          new IconButton(icon: icon, onPressed:(){
            setState(() {
              if(this.icon.icon == Icons.search)
              {
                this.icon=new Icon(Icons.close);
                this.appBarTitle=TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search...",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,);
                _handleSearchStart();
              }
              else _handleSearchEnd();
            });
          }),
        ],),
      body: _contacts != null
          ? _contacts.length==0?NoDataError():_isSearching?ListView.builder(
        shrinkWrap: true,
        physics:BouncingScrollPhysics(),
        itemCount: searchResult.length,
        itemBuilder: (BuildContext context1, int index) {
          Contact c = searchResult?.elementAt(index);
          var phone=c.phones;
          return ListTile(
            onTap: () {
              Navigator.pop(context,c);
            },
            leading: (c.avatar != null && c.avatar.length > 0)
                ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                : CircleAvatar(child: Text(c.initials())),
            title: Text(c.displayName ?? ""),
            subtitle: Text(phone!=null&&phone.length>0?phone.first.value:""),

          );
        },
      ):ListView.builder(
        shrinkWrap: true,
        physics:BouncingScrollPhysics(),
        itemCount: _contacts.length,
        itemBuilder: (BuildContext context1, int index) {
          Contact c = _contacts?.elementAt(index);
          var phone=c.phones;
          return ListTile(
            onTap: () {
              Navigator.pop(context,c);
            },
            leading: (c.avatar != null && c.avatar.length > 0)
                ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                : CircleAvatar(child: Text(c.initials())),
            title: Text(c.displayName ?? ""),
            subtitle: Text( phone!=null&&phone.length>0?phone.first.value:""),

          );
        },
      )
          : Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey.withOpacity(0.5),
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 4,
                    )
                ),
              ),
            ],
          )
      ),
    ),key: scaffoldMessengerKey,);
  }
}

class AddressesTile extends StatelessWidget {
  AddressesTile(this._addresses);
  final Iterable<PostalAddress> _addresses;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(title: Text("Addresses")),
        Column(
          children: _addresses.map((a) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("Street"),
                  trailing: Text(a.street ?? ""),
                ),
                ListTile(
                  title: Text("Postcode"),
                  trailing: Text(a.postcode ?? ""),
                ),
                ListTile(
                  title: Text("City"),
                  trailing: Text(a.city ?? ""),
                ),
                ListTile(
                  title: Text("Region"),
                  trailing: Text(a.region ?? ""),
                ),
                ListTile(
                  title: Text("Country"),
                  trailing: Text(a.country ?? ""),
                ),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class ItemsTile extends StatelessWidget {
  ItemsTile(this._title, this._items);
  final Iterable<Item> _items;
  final String _title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(title: Text(_title)),
        Column(
          children: _items.map((i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              title: Text(i.label ?? ""),
              trailing: Text(i.value ?? ""),
            ),),
          ).toList(),
        ),
      ],
    );
  }
}

