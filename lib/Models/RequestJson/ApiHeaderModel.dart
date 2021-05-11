class ApiHeaderModel
{
  String authorization;
  String contentType;
  ApiHeaderModel({this.authorization,this.contentType});

  Map<String,String> toJson() =>
      {
        "Authorization":authorization,
        "Content-Type":contentType,
      };
}