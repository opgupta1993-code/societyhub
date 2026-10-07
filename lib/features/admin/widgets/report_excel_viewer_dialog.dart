import 'package:flutter/material.dart';

class ExcelRowData {
  final int rowNumber;
  final String colA; // Flat / Voucher
  final String colB; // Name / Description
  final String colC; // Category / Status
  final String colD; // Amount / Dues
  final String colE; // Date / Phone

  ExcelRowData({
    required this.rowNumber,
    required this.colA,
    required this.colB,
    required this.colC,
    required this.colD,
    required this.colE,
  });
}

class ReportExcelViewerDialog extends StatefulWidget {
  final String reportTitle;
  final String reportDescription;

  const ReportExcelViewerDialog({
    super.key,
    required this.reportTitle,
    required this.reportDescription,
  });

  static void show(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportExcelViewerDialog(
        reportTitle: title,
        reportDescription: description,
      ),
    );
  }

  @override
  State<ReportExcelViewerDialog> createState() => _ReportExcelViewerDialogState();
}

class _ReportExcelViewerDialogState extends State<ReportExcelViewerDialog> {
  String _searchQuery = '';
  int _selectedSheetTab = 0;

  late final List<ExcelRowData> _allRows;

  @override
  void initState() {
    super.initState();
    _allRows = _generateMockExcelData(widget.reportTitle);
  }

  List<ExcelRowData> _generateMockExcelData(String title) {
    if (title.contains('Defaulter')) {
      return [
        ExcelRowData(rowNumber: 2, colA: 'A-102', colB: 'Amit Verma', colC: '3 Months Overdue', colD: '₹7,500', colE: '9876543201'),
        ExcelRowData(rowNumber: 3, colA: 'B-304', colB: 'Suresh Gupta', colC: '2 Months Overdue', colD: '₹4,900', colE: '9876543202'),
        ExcelRowData(rowNumber: 4, colA: 'C-401', colB: 'Priya Nair', colC: '5 Months Overdue', colD: '₹12,250', colE: '9876543203'),
        ExcelRowData(rowNumber: 5, colA: 'B-202', colB: 'Vikas Patel', colC: '1 Month Overdue', colD: '₹2,450', colE: '9876543204'),
        ExcelRowData(rowNumber: 6, colA: 'A-405', colB: 'Rohan Deshmukh', colC: '4 Months Overdue', colD: '₹9,800', colE: '9876543205'),
        ExcelRowData(rowNumber: 7, colA: 'C-102', colB: 'Kiran Kulkarni', colC: '2 Months Overdue', colD: '₹4,900', colE: '9876543206'),
      ];
    } else if (title.contains('Expense')) {
      return [
        ExcelRowData(rowNumber: 2, colA: 'V-101', colB: 'Security Guard Payroll', colC: 'Staff Pay', colD: '₹1,20,000', colE: '01-Oct-2026'),
        ExcelRowData(rowNumber: 3, colA: 'V-102', colB: 'MSEDCL Elevator Power', colC: 'Electricity', colD: '₹45,300', colE: '03-Oct-2026'),
        ExcelRowData(rowNumber: 4, colA: 'V-103', colB: 'Submersible Pump Repair', colC: 'Plumbing', colD: '₹18,500', colE: '04-Oct-2026'),
        ExcelRowData(rowNumber: 5, colA: 'V-104', colB: 'CCTV Maintenance & Cables', colC: 'Security', colD: '₹12,800', colE: '05-Oct-2026'),
        ExcelRowData(rowNumber: 6, colA: 'V-105', colB: 'Garden Maintenance Supplies', colC: 'Horticulture', colD: '₹8,500', colE: '06-Oct-2026'),
      ];
    } else {
      // Default: Monthly Collection Summary
      return [
        ExcelRowData(rowNumber: 2, colA: 'A-101', colB: 'Rajesh Mehta', colC: 'Maintenance', colD: '₹2,450', colE: 'PAID (UPI)'),
        ExcelRowData(rowNumber: 3, colA: 'A-102', colB: 'Amit Verma', colC: 'Maintenance', colD: '₹2,450', colE: 'PENDING'),
        ExcelRowData(rowNumber: 4, colA: 'B-201', colB: 'Sunita Rao', colC: 'Maintenance', colD: '₹2,450', colE: 'PAID (CARD)'),
        ExcelRowData(rowNumber: 5, colA: 'B-202', colB: 'Rahul Sharma', colC: 'Maintenance', colD: '₹2,450', colE: 'PAID (UPI)'),
        ExcelRowData(rowNumber: 6, colA: 'C-301', colB: 'Deepak Shah', colC: 'Maintenance', colD: '₹2,450', colE: 'PAID (NETBANK)'),
        ExcelRowData(rowNumber: 7, colA: 'C-302', colB: 'Sneha Kulkarni', colC: 'Maintenance', colD: '₹2,450', colE: 'PAID (UPI)'),
      ];
    }
  }

  List<ExcelRowData> get _filteredRows {
    if (_searchQuery.trim().isEmpty) return _allRows;
    final q = _searchQuery.toLowerCase();
    return _allRows.where((r) {
      return r.colA.toLowerCase().contains(q) ||
          r.colB.toLowerCase().contains(q) ||
          r.colC.toLowerCase().contains(q) ||
          r.colD.toLowerCase().contains(q) ||
          r.colE.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final List<String> headers = widget.reportTitle.contains('Defaulter')
        ? ['Flat No', 'Resident Name', 'Overdue Period', 'Total Dues', 'Mobile No']
        : widget.reportTitle.contains('Expense')
            ? ['Voucher #', 'Description', 'Expense Category', 'Amount (₹)', 'Paid Date']
            : ['Flat No', 'Resident / Owner', 'Fee Category', 'Amount (₹)', 'Payment Status'];

    return Container(
      height: mediaQuery.size.height * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F3F3), // Light grey Excel grid background
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Excel Green Header Toolbar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            decoration: const BoxDecoration(
              color: Color(0xFF107C41), // Microsoft Excel Green
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.table_chart_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.reportTitle}.xlsx',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Excel Spreadsheet Data Grid • Auto-formatted',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download_rounded, color: Colors.white, size: 22),
                      tooltip: 'Export .XLSX',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Exported "${widget.reportTitle}.xlsx" to device!'),
                            backgroundColor: const Color(0xFF107C41),
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
                const SizedBox(height: 10),

                // Instant Search input bar inside toolbar
                Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Search cell data (Flat, Name, Status...)...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black45),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: Color(0xFF107C41)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Formula Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('fx', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '=SUM(D2:D${_allRows.length + 1}) • Showing ${_filteredRows.length} rows',
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // Interactive Data Table View
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFE1DFDD)),
                  dataRowColor: WidgetStateProperty.resolveWith((states) => Colors.white),
                  headingRowHeight: 38,
                  dataRowMinHeight: 42,
                  dataRowMaxHeight: 42,
                  columnSpacing: 24,
                  horizontalMargin: 12,
                  columns: [
                    const DataColumn(
                      label: Text('#', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                    ),
                    DataColumn(
                      label: Text('A: ${headers[0]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('B: ${headers[1]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('C: ${headers[2]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('D: ${headers[3]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    DataColumn(
                      label: Text('E: ${headers[4]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                  rows: _filteredRows.map((row) {
                    final isPending = row.colE.contains('PENDING') || row.colC.contains('Overdue');

                    return DataRow(
                      cells: [
                        DataCell(Text(row.rowNumber.toString(), style: const TextStyle(color: Colors.black45, fontSize: 11))),
                        DataCell(Text(row.colA, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        DataCell(Text(row.colB, style: const TextStyle(fontSize: 12))),
                        DataCell(Text(row.colC, style: const TextStyle(fontSize: 12))),
                        DataCell(Text(row.colD, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF107C41)))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isPending ? Colors.red.shade50 : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: isPending ? Colors.red.shade300 : Colors.green.shade300),
                            ),
                            child: Text(
                              row.colE,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isPending ? Colors.red.shade700 : Colors.green.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Bottom Sheet Tabs Footer (Sheet1, Summary, Sheet3)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFE1DFDD),
            child: Row(
              children: [
                _buildSheetTab(0, 'Sheet1 (Active)'),
                const SizedBox(width: 8),
                _buildSheetTab(1, 'Summary Pivot'),
                const SizedBox(width: 8),
                _buildSheetTab(2, 'Audit Log'),
                const Spacer(),
                const Text('READY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetTab(int index, String label) {
    final isSelected = _selectedSheetTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedSheetTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isSelected ? const Border(bottom: BorderSide(color: Color(0xFF107C41), width: 2.5)) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF107C41) : Colors.black54,
          ),
        ),
      ),
    );
  }
}
