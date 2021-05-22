import 'package:chronicle/Models/CourseModels/courseIndexModel.dart';
import 'package:chronicle/Models/CourseModels/courseModel.dart';
import 'package:chronicle/Models/modalOptionModel.dart';
import 'package:chronicle/Models/CourseModels/videoIndexModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/VideoPlayerUtility/videoPlayerPage.dart';
import 'package:chronicle/PdfModule/api/pdfApi.dart';
import 'package:chronicle/PdfModule/api/pdfInvoiceApi.dart';
import 'package:chronicle/PdfModule/model/customer.dart';
import 'package:chronicle/PdfModule/model/invoice.dart';
import 'package:chronicle/PdfModule/model/supplier.dart';
import 'package:chronicle/Widgets/Simmers/loaderWidget.dart';
import 'package:chronicle/Widgets/courseHomePageVideoList.dart';
import 'package:chronicle/Widgets/videoCardWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../customColors.dart';
import '../globalClass.dart';
class CoursePreviewPage extends StatefulWidget {
  final CourseIndexModel course;
  const CoursePreviewPage({ Key key, this.course}) : super(key: key);
  @override
  _CoursePreviewPageState createState() => _CoursePreviewPageState();
}
class _CoursePreviewPageState extends State<CoursePreviewPage> {
  CourseModel courseDetail;
  int _counter=0;
  bool _isLoading;

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey<ScaffoldMessengerState>();
  bool _isSearching=false;

  List<VideoIndexModel> searchResult = [];
  Icon icon = new Icon(
    Icons.search,
  );
  Razorpay razorpay;
  //Controller
  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController textEditingController=new TextEditingController();
  final TextEditingController renameRegisterTextEditingController=new TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  ScrollController scrollController = new ScrollController();
  //Widgets
  Widget appBarTitle;
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
      this.appBarTitle = Text("");
      _isSearching = false;
      _searchController.clear();
    });
  }
  void searchOperation(String searchText)
  {
    searchResult.clear();
    if(_isSearching){
      searchResult=courseDetail.videos.where((VideoIndexModel element) => (element.name.toLowerCase()).contains(searchText.toLowerCase().replaceAll(new RegExp(r"\W+"), ""))).toList();
      setState(() {
      });
    }
  }
  Future<Null> refreshData() async{
    try{
      if(_isSearching)_handleSearchEnd();
      Connectivity connectivity=Connectivity();
      await connectivity.checkConnectivity().then((value)async {
        if(value!=ConnectivityResult.none)
        {
          if(!_isLoading){
            _isLoading=true;
            return getCourse(widget.course).then((courseDetail) {
              if(mounted)this.setState(() {
                this.courseDetail = courseDetail;
                _counter++;
                _isLoading=false;
                this.appBarTitle = Text("");
              });
            });
          }
          else{
            globalShowInSnackBar(scaffoldMessengerKey, "Data is being loaded...");
            return;
          }
        }
        else{
          setState(() {
            _isLoading=false;
          });
          globalShowInSnackBar(scaffoldMessengerKey,"No Internet Connection!!");
          return;
        }
      });
    }
    catch(E)
    {
      setState(() {
        _isLoading=false;
      });
      globalShowInSnackBar(scaffoldMessengerKey,"Something Went Wrong");
      return;
    }
  }

  void getCourseDetails() {
    if(GlobalClass.myPurchasedCourses==null)getAllCourseIndexes("Courses",false).then((courses) => {
      if(mounted)this.setState(() {
        GlobalClass.myPurchasedCourses = courses;
      })
    });
    getCourse(widget.course).then((courseDetail) => {
      if(mounted)this.setState(() {
        this.courseDetail = courseDetail;
        _counter++;
        _isLoading=false;
        this.appBarTitle = Text("");
      })
    });
  }
  @override
  void initState() {
    super.initState();
    getCourseDetails();
    this.appBarTitle = Text("");
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }
  void openCheckout(){
    var options = {
      "key" : "rzp_test_q6cu1m0YjMEw86",
      "amount" : widget.course.sellingPrice*100,
      "name" : widget.course.title,
      "description" : widget.course.description,
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
    PdfApi.openFile(pdfFile);
    widget.course.totalUsers++;
    courseDetail.totalUsers++;
    widget.course.id.update(widget.course.toJson());
    courseDetail.id.update(courseDetail.toJson());
    addCoursesToOwnLists("Courses",widget.course);
  }

  void handlerErrorFailure(PaymentFailureResponse response){
    globalShowInSnackBar(scaffoldMessengerKey,"ERROR: " + response.code.toString() + " - " + response.message);
  }

  void handlerExternalWallet(ExternalWalletResponse response){
    globalShowInSnackBar(scaffoldMessengerKey,"EXTERNAL_WALLET: " + response.walletName);
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        leading: IconButton(onPressed: () { if(!_isSearching)Navigator.of(context).pop(); }, icon: Icon(_isSearching?Icons.search:Icons.arrow_back),),
        actions: [
          new IconButton(icon: icon, onPressed:(){
            setState(() {
              if(this.icon.icon == Icons.search)
              {
                this.icon=new Icon(Icons.close);
                this.appBarTitle=TextFormField(autofocus:true,controller: _searchController,style: TextStyle(fontSize: 15),decoration: InputDecoration(border: const OutlineInputBorder(borderSide: BorderSide.none),hintText: "Search Videos",hintStyle: TextStyle(fontSize: 15)),onChanged: searchOperation,);
                _handleSearchStart();
              }
              else _handleSearchEnd();
            });
          }),
          if(GlobalClass.myPurchasedCourses!=null&&GlobalClass.myPurchasedCourses.where((element) => element.uid==widget.course.uid).length==0)new IconButton(icon: Icon(FontAwesomeIcons.heart), onPressed:(){
            getAllCourseIndexes("Wishlist",false).then((value){
              if(value.where((element) => element.uid==widget.course.uid).length==0){
                addCoursesToOwnLists("Wishlist",widget.course);
                globalShowInSnackBar(scaffoldMessengerKey, "Added to wishlist!!");
              }
              else{
                scaffoldMessengerKey.currentState.hideCurrentSnackBar();
                scaffoldMessengerKey.currentState.showSnackBar(new SnackBar(content: Text("Already in wishlist."),action: SnackBarAction(textColor: CustomColors.snackBarActionTextColor,label: "Remove",onPressed: (){
                  deleteDatabaseNode(widget.course.id);
                  globalShowInSnackBar(scaffoldMessengerKey, "Removed from wishlist!!");
                },),));
              }
            });
          })
          else new IconButton(icon: Icon(Icons.verified_outlined), onPressed:(){
            globalShowInSnackBar(scaffoldMessengerKey, "Already Purchased!!");
          })
        ],),
      body:
      this.courseDetail!=null?RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          displacement: 10,
          key: refreshIndicatorKey,
          onRefresh: (){
            return refreshData();
          },
          child:ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Text(widget.course.title,style: TextStyle(fontSize: 25)),
              SizedBox(height: 8,),
              Text("by "+widget.course.authorName,style: TextStyle(fontSize: 20)),
              SizedBox(height: 8,),
              Text("₹"+widget.course.sellingPrice.toStringAsFixed(2),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                            SizedBox(height: 8,),
              Text("Last Updates at: "+getMonth(this.courseDetail.lastUpdated.month)+this.courseDetail.lastUpdated.day.toString()+","+this.courseDetail.lastUpdated.year.toString(),style: TextStyle(fontWeight: FontWeight.w900),),
              SizedBox(height: 8,),
              Text("Validity:"+this.courseDetail.coursePackageDurationInMonths.toString()+" Month(s)"),
              SizedBox(height: 8,),
              Text(this.courseDetail.totalUsers.toString()+" Subscribers"),
              SizedBox(height: 8,),
              if(this.courseDetail.previewVideo!=null)Text("Preview this course",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              if(this.courseDetail.previewVideo!=null)VideoCardWidget(
                key: ObjectKey(this.courseDetail.previewVideo.id.key),
                item:this.courseDetail.previewVideo,
                index: 0,
                onTapList: (index){
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                      VideoPlayerPage(video:this.courseDetail.previewVideo)));
                },
              ),
              SizedBox(height: 8,),
              Text("Description",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Text(widget.course.description),
              SizedBox(height: 8,),
              Text("What you'll learn",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Text(this.courseDetail.whatWillYouLearn),
              SizedBox(height: 8,),
              if(this.courseDetail.videos!=null&&this.courseDetail.videos.length!=0)Text("Videos",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              this.courseDetail.videos!=null&&this.courseDetail.videos.length==0?Container(height: 0,width: 0,):_isSearching?
              Provider.value(
                  value: _counter,
                  updateShouldNotify: (oldValue, newValue) => true,
                  child: CourseHomePageVideoList(listItems:this.searchResult,
                    scaffoldMessengerKey:scaffoldMessengerKey,
                    onTapList:(index) async {
                      // Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                      //     VideoPlayerPage(video:this.searchResult[index])));
                    },
                  )):
              Provider.value(
                  value: _counter,
                  updateShouldNotify: (oldValue, newValue) => true,
                  child: CourseHomePageVideoList(listItems:this.courseDetail.videos,scaffoldMessengerKey:scaffoldMessengerKey,
                    onTapList:(index) async {
                      // Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>
                      //     VideoPlayerPage(video:this.courseDetail.videos[index])));
                    },
                  )
              )
            ],
          )
      ):LoaderWidget(),
      floatingActionButton:
      (GlobalClass.myPurchasedCourses!=null&&GlobalClass.myPurchasedCourses.where((element) => element.uid==widget.course.uid).length==0)?FloatingActionButton.extended(onPressed:(){
        openCheckout();
    }, label: Text("Purchase Course"),icon: Icon(Icons.payment_outlined),):null
    ),key: scaffoldMessengerKey,);
  }
}