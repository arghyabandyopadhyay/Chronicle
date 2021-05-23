import 'package:firebase_database/firebase_database.dart';

class CourseIndexModel {
  final String uid;
  String authorName;
  String title;
  String description;
  String previewThumbnailUrl;
  int totalUsers;
  double sellingPrice;
  DatabaseReference id;

  CourseIndexModel({this.uid,this.authorName, this.title,this.description,this.previewThumbnailUrl,this.totalUsers,this.sellingPrice});

  factory CourseIndexModel.fromJson(Map<String, dynamic> json1,String idKey) {
    return CourseIndexModel(
      uid: json1['UID'],
      authorName: json1['AuthorName'],
      title: json1['Title'],
      description:json1['Description'],
      previewThumbnailUrl: json1['PreviewThumbnailUrl'],
      totalUsers: json1['TotalUsers'],
      sellingPrice:json1['SellingPrice']!=null?double.parse(json1['SellingPrice'].toString()):null,
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  void update(){
    this.id.update(this.toJson());
  }

  Map<String,dynamic> toJson() =>
      {
        "Title":this.title,
        "AuthorName":this.authorName,
        "UID":this.uid,
        "PreviewThumbnailUrl":this.previewThumbnailUrl,
        "Description":this.description,
        "TotalUsers": this.totalUsers,
        "SellingPrice":this.sellingPrice,
      };
}