import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class ReportPdfViewerDialog extends StatelessWidget {
  final String reportTitle;
  final String reportDescription;

  const ReportPdfViewerDialog({
    super.key,
    required this.reportTitle,
    required this.reportDescription,
  });

  static void show(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportPdfViewerDialog(
        reportTitle: title,
        reportDescription: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF525659), // Standard PDF Viewer dark grey background
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // PDF Toolbar Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF323639), // Darker toolbar color
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$reportTitle.pdf',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Page 1 of 1 • PDF Document (A4)',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.print_rounded, color: Colors.white, size: 20),
                  tooltip: 'Print',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sending document to printer...'),
                        backgroundColor: Color(0xFF0F5C4D),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                  tooltip: 'Download PDF',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloaded "$reportTitle.pdf" to Downloads folder.'),
                        backgroundColor: const Color(0xFF0F5C4D),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                  tooltip: 'Share',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sharing "$reportTitle.pdf"...'),
                        backgroundColor: const Color(0xFF0F5C4D),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Scrollable PDF Paper View
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Letterhead Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'DEMO HOUSING SOCIETY',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F5C4D),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Reg No: MAH/MUM/2020/1402 • Navi Mumbai',
                                style: TextStyle(fontSize: 10, color: Colors.black54),
                              ),
                              Text(
                                'Plot 42, Sector 18, Palm Beach Road',
                                style: TextStyle(fontSize: 10, color: Colors.black54),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F5C4D).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.apartment_rounded,
                              color: Color(0xFF0F5C4D),
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(thickness: 2, color: Color(0xFF0F5C4D)),
                      const SizedBox(height: 14),

                      // Document Metadata Title Block
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E5E0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reportTitle.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reportDescription,
                              style: const TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Date: 07-Oct-2026', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                Text('Generated by: Admin / Accountant', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Report Table Content based on title
                      _buildPdfDataGrid(reportTitle),

                      const SizedBox(height: 30),

                      // Signatures & Official Stamp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF0F5C4D).withValues(alpha: 0.5), width: 2),
                                ),
                                child: const Center(
                                  child: Text(
                                    'SOCIETY\nSEAL',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F5C4D),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('Official Stamp', style: TextStyle(fontSize: 9, color: Colors.black54)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                'Rahul Sharma',
                                style: TextStyle(
                                  fontFamily: 'Caveat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F5C4D),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text('Authorized Signatory', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('Treasurer / Secretary', style: TextStyle(fontSize: 10, color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.black12),
                      const Center(
                        child: Text(
                          'Computer generated official report • SocietyHub ERP System',
                          style: TextStyle(fontSize: 9, color: Colors.black45, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfDataGrid(String title) {
    if (title.contains('Defaulter')) {
      return Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.2),
          3: FlexColumnWidth(1.5),
        },
        children: [
          _buildTableHeader(['Flat No', 'Resident Name', 'Overdue', 'Total Dues']),
          _buildTableRow(['A-102', 'Amit Verma', '3 Months', '₹7,500']),
          _buildTableRow(['B-304', 'Suresh Gupta', '2 Months', '₹4,900']),
          _buildTableRow(['C-401', 'Priya Nair', '5 Months', '₹12,250']),
          _buildTableRow(['B-202', 'Vikas Patel', '1 Month', '₹2,450']),
          _buildTableRow(['Total Outstanding', '', '14 Flats', '₹2,45,000'], isTotal: true),
        ],
      );
    } else if (title.contains('Expense')) {
      return Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        children: [
          _buildTableHeader(['Voucher', 'Description', 'Category', 'Amount']),
          _buildTableRow(['V-101', 'Security Guard Payroll', 'Staff Pay', '₹1,20,000']),
          _buildTableRow(['V-102', 'MSEDCL Elevator Power', 'Electricity', '₹45,300']),
          _buildTableRow(['V-103', 'Submersible Pump Repair', 'Plumbing', '₹18,500']),
          _buildTableRow(['V-104', 'CCTV Maintenance & Cables', 'Security', '₹12,800']),
          _buildTableRow(['Total Monthly Expenses', '', 'Oct 2026', '₹3,15,400'], isTotal: true),
        ],
      );
    } else {
      // Default: Monthly Collection Summary
      return Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        children: [
          _buildTableHeader(['Flat No', 'Owner / Tenant', 'Category', 'Status']),
          _buildTableRow(['A-101', 'Rajesh Mehta', 'Maintenance', 'PAID (₹2,450)']),
          _buildTableRow(['A-102', 'Amit Verma', 'Maintenance', 'OVERDUE']),
          _buildTableRow(['B-201', 'Sunita Rao', 'Maintenance', 'PAID (₹2,450)']),
          _buildTableRow(['B-202', 'Rahul Sharma', 'Maintenance', 'PAID (₹2,450)']),
          _buildTableRow(['Collection Total', '82% Received', '140 / 170 Flats', '₹4,85,000'], isTotal: true),
        ],
      );
    }
  }

  TableRow _buildTableHeader(List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFF0F5C4D)),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            cell,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isTotal = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isTotal ? const Color(0xFFE6F4F1) : Colors.white,
      ),
      children: cells.map((cell) {
        final isOverdue = cell.contains('OVERDUE');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            cell,
            style: TextStyle(
              fontSize: 11,
              fontWeight: (isTotal || isOverdue) ? FontWeight.bold : FontWeight.normal,
              color: isOverdue
                  ? Colors.red.shade700
                  : (isTotal ? const Color(0xFF0F5C4D) : Colors.black87),
            ),
          ),
        );
      }).toList(),
    );
  }
}
