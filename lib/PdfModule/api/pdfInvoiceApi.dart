import 'dart:io';
import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/PdfModule/api/pdfApi.dart';
import 'package:chronicle/PdfModule/model/invoice.dart';
import 'package:chronicle/PdfModule/model/supplier.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../../Modules/utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
        buildPreFooter(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: '${invoice.title}.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildSupplierAddress(invoice.supplier),
          Container(
            height: 50,
            width: 50,
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: invoice.info.number,
            ),
          ),
        ],
      ),
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCustomerAddress(invoice.customer),
          buildInvoiceInfo(invoice.info),
        ],
      ),
    ],
  );

  static Widget buildCustomerAddress(ClientModel customer) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
      Text(customer.mobileNo),
      customer.registrationId!=null&&customer.registrationId!=""?Text('Registration Id:${customer.registrationId}'):Container(height: 0,width: 0),
    ],
  );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildInvoiceDetails(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplier.name, style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a"))),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(supplier.address),
    ],
  );

  static Widget buildTitle(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'INVOICE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: PdfColor.fromHex("003e7a")),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Months',
      'Rate(Rs)',
      'GST %',
      'Total(Rs)'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.gst);

      return [
        item.description,
        '${item.quantity}',
        item.unitPrice.toStringAsFixed(2),
        '${item.gst}',
        total.toStringAsFixed(2),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a")),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.gst;
    final gst = netTotal * vatPercent;
    final total = netTotal + gst;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'GST ${vatPercent * 100} %',
                  value: Utils.formatPrice(gst),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Grand Total',
                  titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a")
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                buildText(title:"Mode of Payment:",value: invoice.modeOfPayment,unite: true),
                SizedBox(height: 0.8 * PdfPageFormat.cm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildPreFooter(Invoice invoice) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          margin: EdgeInsets.symmetric(horizontal: 2  ),
          alignment: Alignment.topLeft,
          width: PdfPageFormat.a4.width*0.5,
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.0,style: BorderStyle.solid),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Terms And Conditions:",style: TextStyle(fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a")),),),
                SizedBox.fromSize(child: Container(height: 10)),
                Expanded(child: Text("${invoice.info.termsAndConditions}\nChronicle Business Solutions is not liable, if a conflict occurs with ${invoice.supplier.name}.",
                  softWrap: true,
                  style: TextStyle(),
                ),)
              ]
          )
      ),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.topLeft,
          width: PdfPageFormat.a4.width*0.3,
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.0,style: BorderStyle.solid),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Remarks:",style: TextStyle(fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a")),),),
                SizedBox.fromSize(child: Container(height: 10)),
                Expanded(child: Text("${invoice.info.remarks}",
                  textScaleFactor: 1,
                  softWrap: true,
                  style: TextStyle(),
                ),)
              ]
          )
      )
    ],
  );

  static Widget buildFooter(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildFooterText(title: 'Powered By', value: "Chronicle Business Solutions",),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text("chroniclebusinesssolutions@gmail.com"),
    ],
  );

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style=TextStyle(fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a"));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }
  static buildFooterText({
    String title,
    String value,
  }) {
    final style = TextStyle(color: PdfColor.fromHex("003e7a"),fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value,style: style),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a"));

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
  static buildInvoiceDetails({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold,color:PdfColor.fromHex("003e7a"));

    return Container(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: style),
          Expanded(child:Text(value, style: unite ? style : null,softWrap: true,textAlign: TextAlign.right),),
        ],
      ),
    );
  }
}
