import 'package:chronicle/Models/RequestJson/ApiHeaderModel.dart';
import 'package:chronicle/Models/client_model.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/global_class.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

postForBulkMessage(List<ClientModel> list, String messageBody) {
  list.forEach((element) async {
    String address = element.mobileNo;
    String message = "${element.name}, $messageBody";
    if (address != null && address != "")
      responseGeneratorPost(
          address,
          GlobalClass.userDetail.smsMobileNo,
          message,
          GlobalClass.userDetail.smsApiUrl,
          GlobalClass.userDetail.smsUserId,
          GlobalClass.userDetail.smsAccessToken);
  });
}

responseGeneratorPost(String to, String from, String body, String url,
    String userName, String password) async {
  ApiHeaderModel headerModel = new ApiHeaderModel(
      authorization: "Basic ${encrypt('$userName:$password')}",
      contentType: 'application/x-www-form-urlencoded');
  try {
    http.post(
      Uri.parse(url),
      headers: headerModel.toJson(),
      body: {"To": "+91" + to.replaceAll(" ", ""), "From": from, "Body": body},
    );
  } catch (E) {
    Connectivity connectivity = Connectivity();
    await connectivity.checkConnectivity().then((value) => {
          if (value == ConnectivityResult.none)
            {
              throw "NoInternet",
            }
          else
            throw "ErrorHasOccurred"
        });
  }
}
