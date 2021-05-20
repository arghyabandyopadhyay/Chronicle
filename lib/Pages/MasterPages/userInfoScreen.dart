
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/OwnerModules/clientAccessEditPage.dart';
import 'package:chronicle/OwnerModules/dispatchNotificationConsole.dart';
import 'package:chronicle/Pages/helpAndFeedbackPage.dart';
import 'package:chronicle/Pages/settingsPage.dart';
import 'package:chronicle/PdfModule/api/pdfInvoiceApi.dart';
import 'package:chronicle/PdfModule/model/customer.dart';
import 'package:chronicle/PdfModule/model/invoice.dart';
import 'package:chronicle/PdfModule/model/supplier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:async';
import '../../Modules/auth.dart';
import '../../appBarVariables.dart';
import '../../customColors.dart';
import '../TutorPages/qrCodePage.dart';
import '../notificationsPage.dart';
import '../routingPage.dart';
import '../../globalClass.dart';

class UserInfoScreen extends StatefulWidget {
  final BuildContext mainScreenContext;
  final bool hideStatus;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const UserInfoScreen({Key key, this.mainScreenContext, this.hideStatus, this.scaffoldKey}):super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _isSigningOut = false;
  Razorpay razorpay;
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  Route _routeToRoutingPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RoutingPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }
  void openCheckout(){
    var options = {
      "key" : "rzp_test_q6cu1m0YjMEw86",
      "amount" : GlobalClass.userDetail.yearlyPaymentPrice*100,
      "name" : "Chronicle",
      "description" : "Chronicle yearly payment",
      "prefill" : {
        "email" : GlobalClass.userDetail.email
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };
    try{
      razorpay.open(options);

    }catch(e){
      debugPrint('Error: e');
    }
  }
  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  Future<void> handlerPaymentSuccess(PaymentSuccessResponse response) async {
    globalShowInSnackBar(scaffoldMessengerKey,"SUCCESS: " + response.paymentId);
    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));

    final invoice = Invoice(
      title: "Chronicle Yearly Payment ${DateTime.now().year}",
      supplier: Supplier(
        name: 'Chronicle Business Solutions',
        address: 'Smriti nagar, Bhilai',
        email: 'chroniclebusinesssolutions@gmail.com',
      ),
      customer: Customer(
        name: GlobalClass.userDetail.displayName,
        email: GlobalClass.userDetail.email,
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'My description...',
        number: '${DateTime.now().year}-9999',
      ),
      items: [
        InvoiceItem(
          description: 'Coffee',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 5.99,
        ),
        InvoiceItem(
          description: 'Water',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Apple',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 3.99,
        ),
        InvoiceItem(
          description: 'Mango',
          date: DateTime.now(),
          quantity: 1,
          vat: 0.19,
          unitPrice: 1.59,
        ),
        InvoiceItem(
          description: 'Blue Berries',
          date: DateTime.now(),
          quantity: 5,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Lemon',
          date: DateTime.now(),
          quantity: 4,
          vat: 0.19,
          unitPrice: 1.29,
        ),
      ],
    );

    final pdfFile = await PdfInvoiceApi.generate(invoice);
    sendRegisterAppEmail(scaffoldMessengerKey,pdfFile);
    // PdfApi.openFile(pdfFile);
  }

  void handlerErrorFailure(PaymentFailureResponse response){
    globalShowInSnackBar(scaffoldMessengerKey,"ERROR: " + response.code.toString() + " - " + response.message);
  }

  void handlerExternalWallet(ExternalWalletResponse response){
    globalShowInSnackBar(scaffoldMessengerKey,"EXTERNAL_WALLET: " + response.walletName);
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child:Scaffold(
      appBar: AppBar(
        // leading: IconButton(icon:Icon(Icons.menu),onPressed: (){widget.scaffoldKey.currentState.openDrawer();},),
        title: AppBarVariables.appBarLeading(widget.mainScreenContext),
        actions: [
          new IconButton(icon: Icon(Icons.notifications_outlined), onPressed:(){
            setState(() {
              Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (notificationPageContext)=>NotificationsPage()));
            });
          }),
          PopupMenuButton<ModalOptionModel>(
            itemBuilder: (BuildContext popupContext){
              return [
                if(GlobalClass.userDetail.isAppRegistered==1&&GlobalClass.userDetail.canAccess==0)ModalOptionModel(particulars: "Yearly Subscription Payment",icon: Icons.payment_outlined,iconColor:CustomColors.addPaymentIconColor,onTap: (){
                  Navigator.pop(popupContext);
                  openCheckout();
                }),
                ModalOptionModel(particulars: "My Qr Code",icon: Icons.qr_code_outlined,iconColor:CustomColors.qrcodeIconColor,onTap: () async {
                  Navigator.pop(popupContext);
                  UserModel userModel=await getUserDetails();
                  if(userModel.qrcodeDetail!=null){
                    Navigator.of(widget.mainScreenContext).push(new CupertinoPageRoute(builder: (qrCodePageContext)=>QrCodePage(qrCode: userModel.qrcodeDetail)));
                  }
                  else {
                    String _data = '';
                    try {
                      final pickedFile = await ImagePicker().getImage(
                        source: ImageSource.gallery,
                        maxWidth: 300,
                        maxHeight: 300,
                        imageQuality: 30,
                      );
                      setState(() {
                        QrCodeToolsPlugin.decodeFrom(pickedFile.path).then((value) {
                          _data = value;
                          userModel.qrcodeDetail=_data;
                          userModel.update();
                        });

                      });
                    } catch (e) {
                      globalShowInSnackBar(scaffoldMessengerKey,"Invalid File!!");
                      setState(() {
                        _data = '';
                      });
                    }
                  }
                }),
                ModalOptionModel(particulars: "Help and Feedback",icon: Icons.help_outline,iconColor:CustomColors.helpIconColor,onTap: () async {
                  Navigator.pop(popupContext);
                  Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (settingsContext)=>HelpAndFeedbackPage()));
                }),
                ModalOptionModel(particulars: "Settings",icon: Icons.settings,iconColor:CustomColors.settingsIconColor,onTap: () async {
                  Navigator.pop(popupContext);
                  Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (settingsContext)=>SettingsPage()));
                }),
                if(GlobalClass.user!=null&&GlobalClass.userDetail!=null&&GlobalClass.userDetail.isOwner==1)ModalOptionModel(particulars: "Dispatch Notification",icon: Icons.send,iconColor:CustomColors.sendIconColor,onTap: () async {
                    Navigator.of(popupContext).pop();
                    Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>DispatchNotificationConsole()));
                  },
                ),
                if(GlobalClass.user!=null&&GlobalClass.userDetail!=null&&GlobalClass.userDetail.isOwner==1)ModalOptionModel(particulars: "Users Access",icon: Icons.account_box_outlined,iconColor:CustomColors.sendIconColor,onTap: () async {
                    Navigator.of(context).pop();
                    Navigator.of(widget.mainScreenContext).push(CupertinoPageRoute(builder: (context)=>ClientAccessEditPage()));
                  },
                ),
              ].map((ModalOptionModel choice){
                return PopupMenuItem<ModalOptionModel>(
                  value: choice,
                  child: ListTile(title: Text(choice.particulars),leading: Icon(choice.icon,color: choice.iconColor),onTap: choice.onTap,),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            children: [
              SizedBox(height: 50.0),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                child: GlobalClass.user.photoURL != null
                    ? ClipOval(
                  child: Material(
                    color: CustomColors.firebaseGrey.withOpacity(0.3),
                    child: Image.network(
                      GlobalClass.user.photoURL,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
                    : ClipOval(
                  child: Material(
                    color: CustomColors.firebaseGrey.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: CustomColors.firebaseGrey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                GlobalClass.user.displayName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${GlobalClass.user.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),

              SizedBox(height: 16.0),
              if(GlobalClass.userDetail.isAppRegistered==0)GestureDetector(
                onTap: (){
                  openCheckout();
                },
                child: Container(color:Colors.transparent,child: Text(
                  'Become an Instructor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      letterSpacing: 0.2),
                ),),
              ),
              SizedBox(height: 24.0),
              _isSigningOut?CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ):GestureDetector(
                onTap:() async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(widget.mainScreenContext).pushReplacement(_routeToRoutingPage());
                },
                child: Container(color:Colors.transparent,child: Text(
                  'Sign out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      letterSpacing: 0.2),
                ),),
              )
            ],
          ),
        ),
    ),key:scaffoldMessengerKey);
  }
}