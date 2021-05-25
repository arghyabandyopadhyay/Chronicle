import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Widgets/loaderWidget.dart';
import 'package:chronicle/Widgets/courseList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globalClass.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:chronicle/PdfModule/api/pdfApi.dart';
import 'package:chronicle/PdfModule/api/pdfInvoiceApi.dart';
import 'package:chronicle/PdfModule/model/customer.dart';
import 'package:chronicle/PdfModule/model/invoice.dart';
import 'package:chronicle/PdfModule/model/supplier.dart';


class CheckoutPage extends StatefulWidget {
  final bool isFromPreviewPage;
  final List<CourseIndexModel> courses;
  const CheckoutPage({ Key key,this.courses,this.isFromPreviewPage}) : super(key: key);
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}
class _CheckoutPageState extends State<CheckoutPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();
  double total;
  Razorpay razorpay;

  //Controller
  void openCheckout(){
    if(widget.courses!=null){
      var options = {
        "key" : "rzp_test_q6cu1m0YjMEw86",
        "amount" : total*100,
        "name" : "Chronicle Courses",
        "description" : "Courses purchased by ${GlobalClass.userDetail.displayName}",
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
          number: '${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}',
        ),
        items: widget.courses.map((e) => InvoiceItem(
          description: e.title,
          date: DateTime.now(),
          quantity: 1,
          vat: 0.18,
          unitPrice: e.sellingPrice,
        ),).toList()
    );
    final pdfFile = await PdfInvoiceApi.generate(invoice);
    PdfApi.openFile(pdfFile);

    if(widget.isFromPreviewPage){
      List<CourseIndexModel> temp=GlobalClass.myCourses.where((element) => element.uid==widget.courses[0].uid).toList();
      if(temp.length==0)addCoursesToOwnLists("Courses",widget.courses[0]);
      else{
        temp.first.courseStatus="Courses";
        temp.first.update();
      }
    }
    await Future.forEach(widget.courses,(CourseIndexModel element) async {
      CourseModel courseDetail=await getCourse(element);
      courseDetail.totalUsers++;
      courseDetail.update();
      element.courseStatus="Courses";
      element.update();
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void handlerErrorFailure(PaymentFailureResponse response){
    globalShowInSnackBar(scaffoldMessengerKey,"ERROR: " + response.code.toString() + " - " + response.message);
  }

  void handlerExternalWallet(ExternalWalletResponse response){
    globalShowInSnackBar(scaffoldMessengerKey,"EXTERNAL_WALLET: " + response.walletName);
  }
  @override
  void initState() {
    super.initState();
    final netTotal = widget.courses
        .map((item) => item.sellingPrice)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = 0.18;
    final vat = netTotal * vatPercent;
    total = netTotal + vat;
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }
  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(
        appBar: AppBar(
          title: Text("Checkout"),),
        body: widget.courses!=null?widget.courses.length==0?NoDataError():Column(children: <Widget>[
          Expanded(child:
          Provider.value(
              value: 0,
              updateShouldNotify: (oldValue, newValue) => true,
              child: CourseList(listItems:widget.courses,scaffoldMessengerKey:scaffoldMessengerKey,
                refreshData: (){
                  return ;
                },
                refreshIndicatorKey: refreshIndicatorKey,
                scrollController: scrollController,
                onTapList:(index) {},
              )
          )),
        ]): LoaderWidget(),
        floatingActionButton:
        FloatingActionButton.extended(heroTag: "checkoutPageHeroTag",onPressed:(){
          openCheckout();
        }, label: Text("Pay ₹$total"),icon: Icon(Icons.payment_outlined),)
    ),);
  }
}