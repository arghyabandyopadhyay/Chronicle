import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/registerIndexModel.dart';
import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/registerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ContactListSimmerWidget extends StatelessWidget {
  //list of options you want to show in the bottom sheet
  ContactListSimmerWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );

  }
}