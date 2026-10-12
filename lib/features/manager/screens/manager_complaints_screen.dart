import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class ManagerComplaintModel {
  final String id;
  final String title;
  final String flat;
  final String residentName;
  final String category;
  final String priority; // 'high', 'medium', 'low'
  final String createdAt;
  String status; // 'open', 'assigned', 'resolved'
  String? assignedStaff;
  String? dueDate;

  ManagerComplaintModel({
    required this.id,
    required this.title,
    required this.flat,
    required this.residentName,
    required this.category,
    required this.priority,
    required this.createdAt,
    required this.status,
    this.assignedStaff,
    this.dueDate,
  });
}

/// Screen E2 & E3: Manager Complaint Queue & Dispatch
/// PRD: E2 - Filter, priority. E3 - Staff, due date, resolve.
class ManagerComplaintsScreen extends StatefulWidget {
  const ManagerComplaintsScreen({super.key});

  @override
  State<ManagerComplaintsScreen> createState() => _ManagerComplaintsScreenState();
}

class _ManagerComplaintsScreenState extends State<ManagerComplaintsScreen> {
  String _selectedPriority = 'All';

  final List<ManagerComplaintModel> _complaints = [
    ManagerComplaintModel(
      id: 'CMP-201',
      title: 'Lift #2 in Tower B making loud grinding noise',
      flat: 'Tower B - 402',
      residentName: 'Rahul S.',
      category: 'Lift & Elevator',
      priority: 'high',
      createdAt: '3 hours ago',
      status: 'open',
    ),
    ManagerComplaintModel(
      id: 'CMP-202',
      title: 'Main water pipe leakage in basement B1',
      flat: 'Common Area B1',
      residentName: 'Estate Security',
      category: 'Plumbing',
      priority: 'high',
      createdAt: '1 day ago',
      status: 'assigned',
      assignedStaff: 'Ramesh (Plumber)',
      dueDate: 'Today, 06:00 PM',
    ),
    ManagerComplaintModel(
      id: 'CMP-203',
      title: 'Intercom dead in flat A-101',
      flat: 'Tower A - 101',
      residentName: 'Sunil Mehta',
      category: 'Electrical / Intercom',
      priority: 'medium',
      createdAt: '2 days ago',
      status: 'open',
    ),
    ManagerComplaintModel(
      id: 'CMP-204',
      title: 'Garbage collection delayed on 3rd floor',
      flat: 'Tower C - 304',
      residentName: 'Priya Nair',
      category: 'Housekeeping',
      priority: 'low',
      createdAt: 'Yesterday',
      status: 'resolved',
      assignedStaff: 'Sunita (Cleanliness)',
      dueDate: 'Completed',
    ),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaints queue refreshed'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showAssignStaffDialog(ManagerComplaintModel complaint) {
    String selectedStaff = complaint.assignedStaff ?? 'Ramesh (Plumber)';
    String selectedDueDate = complaint.dueDate ?? 'Today, 06:00 PM';

    final staffList = [
      'Ramesh (Plumber)',
      'Amit (Electrician)',
      'Suresh (Lift AMC Tech)',
      'Sunita (Housekeeping Supervisor)',
      'External Vendor (Deep Cleaning)',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Assign & Update (E3)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Complaint: ${complaint.title}', style: const TextStyle(fontSize: 12, color: AppColors.mute)),
                  const SizedBox(height: 16),

                  const Text('Select Maintenance Staff', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedStaff,
                        items: staffList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedStaff = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('Target Resolution SLA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedDueDate,
                        items: ['Today, 06:00 PM', 'Tomorrow, 12:00 PM', 'Within 48 Hours', 'Next Monday']
                            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedDueDate = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5C4D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          complaint.assignedStaff = selectedStaff;
                          complaint.dueDate = selectedDueDate;
                          complaint.status = 'assigned';
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dispatched $selectedStaff to ${complaint.flat}'),
                            backgroundColor: const Color(0xFF0F5C4D),
                          ),
                        );
                      },
                      child: const Text('Dispatch Staff to Flat', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredComplaints = _complaints.where((c) {
      if (_selectedPriority == 'High') return c.priority == 'high';
      if (_selectedPriority == 'Medium') return c.priority == 'medium';
      if (_selectedPriority == 'Resolved') return c.status == 'resolved';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Complaints Queue & Dispatch',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: _handleRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Filter Priority Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'High', 'Medium', 'Resolved'].map((p) {
                  final isSelected = _selectedPriority == p;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        p,
                        style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.ink),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0F5C4D),
                      backgroundColor: Colors.white,
                      onSelected: (_) => setState(() => _selectedPriority = p),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            if (filteredComplaints.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: Text('No complaints match this filter')),
              )
            else
              ...filteredComplaints.map((c) => _buildComplaintCard(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintCard(ManagerComplaintModel complaint) {
    final isHigh = complaint.priority == 'high';
    final isResolved = complaint.status == 'resolved';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isHigh ? Colors.red.shade50 : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  complaint.priority.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isHigh ? Colors.red : Colors.amber.shade900,
                  ),
                ),
              ),
              Text(complaint.createdAt, style: const TextStyle(fontSize: 11, color: AppColors.mute)),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            complaint.title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.ink),
          ),
          const SizedBox(height: 4),

          Text(
            '${complaint.flat} · ${complaint.residentName} · Category: ${complaint.category}',
            style: const TextStyle(fontSize: 12, color: AppColors.mute),
          ),
          const SizedBox(height: 10),

          if (complaint.assignedStaff != null)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.engineering_rounded, size: 16, color: Color(0xFF0F5C4D)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Assigned: ${complaint.assignedStaff} · Due: ${complaint.dueDate}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F5C4D)),
                    ),
                  ),
                ],
              ),
            ),

          Row(
            children: [
              if (!isResolved) ...[
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F5C4D),
                      side: const BorderSide(color: Color(0xFF0F5C4D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _showAssignStaffDialog(complaint),
                    child: Text(
                      complaint.assignedStaff == null ? 'Assign Staff (E3)' : 'Re-assign',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() => complaint.status = 'resolved');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Complaint #${complaint.id} marked RESOLVED!'),
                          backgroundColor: Colors.green.shade700,
                        ),
                      );
                    },
                    child: const Text('Mark Resolved', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ),
              ] else
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '✓ RESOLVED & CLOSED',
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green.shade800, fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
