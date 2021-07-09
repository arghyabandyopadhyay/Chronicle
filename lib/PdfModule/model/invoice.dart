import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/PdfModule/model/supplier.dart';

class Invoice {
  final String title;
  final InvoiceInfo info;
  final Supplier supplier;
  final ClientModel customer;
  final List<InvoiceItem> items;
  final String modeOfPayment;

  const Invoice({
    this.title,
     this.info,
     this.supplier,
     this.customer,
     this.items,
     this.modeOfPayment
  });
}

class InvoiceInfo {
  final String remarks;
  final String termsAndConditions;
  final String number;
  final DateTime date;

  const InvoiceInfo({
     this.remarks,
     this.termsAndConditions,
     this.number,
     this.date,
  });
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double gst;
  final double unitPrice;

  const InvoiceItem({
     this.description,
     this.quantity,
     this.gst,
     this.unitPrice,
  });
}
