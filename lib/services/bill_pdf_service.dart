import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BillPdfService {
  static Future<void> generateAndOpenPdf({
    required String billId,
    required Map<String, dynamic> bill,
    required Map<String, dynamic>? booking,
    required Map<String, dynamic>? service,
    required Map<String, dynamic>? employee,
  }) async {
    // Load custom fonts for better typography
    final regularFont = pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/Roboto/static/Roboto-Regular.ttf",
      ),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load(
        "assets/fonts/Roboto/static/Roboto-Bold.ttf",
      ),
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (_) {
          return pw.Theme(
            data: pw.ThemeData.withFont(
              base: regularFont,
              bold: boldFont,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // PROFESSIONAL HEADER
                _buildHeader(billId, bill),

                pw.SizedBox(height: 24),

                // SERVICE & PROVIDER DETAILS
                _buildDetailsSection(bill, booking, service, employee),

                pw.SizedBox(height: 28),

                // BILLING TABLE
                //_buildBillingTable(bill),
                _buildBillingTable(bill, booking),


                pw.SizedBox(height: 20),

                // PAYMENT STATUS
                //_buildPaymentStatus(bill),

                pw.Spacer(),

                // PROFESSIONAL FOOTER
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );

    // Save and open PDF
    final dir = await getApplicationDocumentsDirectory();
    final fileName = "HomeBuddy_Invoice_${billId.substring(0, 8).toUpperCase()}.pdf";
    final file = File("${dir.path}/$fileName");

    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
  }

  // HEADER SECTION
  static pw.Widget _buildHeader(String billId, Map<String, dynamic> bill) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 20),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.black,
            width: 3,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Company branding
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "HomeBuddy",
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "Home Service",
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                "Email: support@homebuddy.com",
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                "Phone: 1234567890",
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                "Web: www.homebuddy.com",
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          // Invoice details
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.black,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  "SERVICE INVOICE",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                "Invoice #: ${billId.substring(0, 8).toUpperCase()}",
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                "Date: ${_formatDate(bill["paid_at"] ?? bill["created_at"])}",
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // DETAILS SECTION
  static pw.Widget _buildDetailsSection(
      Map<String, dynamic> bill,
      Map<String, dynamic>? booking,
      Map<String, dynamic>? service,
      Map<String, dynamic>? employee,
      ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Service Details Box
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.grey800,
                width: 1.5,
              ),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "SERVICE DETAILS",
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildDetailRow("Service Name:", service?["name"] ?? "--"),
                pw.SizedBox(height: 4),
                _buildDetailRow(
                  "Service Date:",
                  _formatDate(booking?["service_date"]),
                ),
                pw.SizedBox(height: 4),
                _buildDetailRow(
                  "Service Time:",
                  booking?["service_time"] ?? "--",
                ),
                if ((booking?["problem_description"] ?? "").toString().isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  _buildDetailRow(
                    "Description:",
                    booking?["problem_description"] ?? "--",
                  ),
                ],
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 16),
        // Provider Details Box
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.grey800,
                width: 1.5,
              ),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "SERVICE PROVIDER",
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildDetailRow(
                  "Provider:",
                  employee?["name"] ?? "--",
                ),
                pw.SizedBox(height: 4),
                _buildDetailRow(
                  "Contact:",
                  employee?["phone"] ?? "--",
                ),
                pw.SizedBox(height: 4),
                _buildDetailRow(
                  "Service Type:",
                  service?["name"] ?? "--",
                ),
                pw.SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // BILLING TABLE
  static pw.Widget _buildBillingTable(
      Map<String, dynamic> bill,
      Map<String, dynamic>? booking,
      ) {
    final bool hasService = booking?["has_service"] == true;

    final double serviceAmount =
    (booking?["service_amount"] ?? 0).toDouble();

    final double visitCharge =
    (bill["visit_charge"] ?? 0).toDouble();

    final double totalAmount =
    hasService ? serviceAmount : visitCharge;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "BILLING BREAKDOWN",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),

        pw.Table(
          border: pw.TableBorder.all(width: 1),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey800),
              children: [
                _buildTableCell("Description", isHeader: true),
                _buildTableCell(
                  "Amount",
                  isHeader: true,
                  align: pw.Alignment.centerRight,
                ),
              ],
            ),

            /// ✅ SERVICE CHARGE (ONLY if service taken)
            if (hasService)
              pw.TableRow(children: [
                _buildTableCell("Service Charge"),
                _buildTableCell(
                  "₹ $serviceAmount",
                  align: pw.Alignment.centerRight,
                ),
              ]),

            /// ✅ VISIT CHARGE (ONLY if service NOT taken)
            if (!hasService)
              pw.TableRow(children: [
                _buildTableCell("Visit Charge"),
                _buildTableCell(
                  "₹ $visitCharge",
                  align: pw.Alignment.centerRight,
                ),
              ]),
          ],
        ),

        pw.SizedBox(height: 10),

        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            border: pw.Border.all(width: 1),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "TOTAL AMOUNT",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "₹ $totalAmount",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  // PAYMENT STATUS
  static pw.Widget _buildPaymentStatus(Map<String, dynamic> bill) {
    final isCompleted = bill["payment_status"] == "Completed";

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: pw.BoxDecoration(
        color: isCompleted ? PdfColors.grey300 : PdfColors.grey200,
        border: pw.Border.all(
          color: PdfColors.grey800,
          width: 1.5,
        ),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            "Payment Status: ",
            style: const pw.TextStyle(
              fontSize: 11,
              color: PdfColors.grey900,
            ),
          ),
          pw.Text(
            "${bill["payment_status"]}",
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // FOOTER
  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 20),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: PdfColors.grey400,
            width: 1,
          ),
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            "Thank you for choosing HomeBuddy!",
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "We appreciate your business and look forward to serving you again.",
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            "For any queries or support, contact us at support@homebuddy.com or call 1234567890",
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey500,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "Powered by ",
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.Text(
                  "HomeBuddy",
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // HELPER: Detail Row
  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ),
        
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey900,
            ),
          ),
        ),
      ],
    );
  }

  // HELPER: Table Cell
  static pw.Widget _buildTableCell(
      String text, {
        bool isHeader = false,
        pw.Alignment? align,
      }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      alignment: align ?? pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColors.grey900,
        ),
      ),
    );
  }

  // HELPER: Format Date
  static String _formatDate(Timestamp? ts) {
    if (ts == null) return "--";
    return DateFormat("dd MMM yyyy, hh:mm a").format(ts.toDate());
  }
}