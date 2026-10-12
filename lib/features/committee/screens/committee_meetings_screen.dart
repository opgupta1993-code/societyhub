import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';

class MeetingItem {
  final String id;
  final String title;
  final String date;
  final String time;
  final String venue;
  final String type; // 'AGM', 'EGM', 'Monthly'
  final List<String> agenda;
  String rsvpStatus; // 'attending', 'tentative', 'declined'
  final int attendingCount;
  final int totalInvited;
  final String? momPdfUrl;

  MeetingItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    required this.type,
    required this.agenda,
    required this.rsvpStatus,
    required this.attendingCount,
    required this.totalInvited,
    this.momPdfUrl,
  });
}

/// Screen G4: Committee Meetings & MoM
/// PRD: Schedule, RSVP, minutes
class CommitteeMeetingsScreen extends StatefulWidget {
  const CommitteeMeetingsScreen({super.key});

  @override
  State<CommitteeMeetingsScreen> createState() => _CommitteeMeetingsScreenState();
}

class _CommitteeMeetingsScreenState extends State<CommitteeMeetingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MeetingItem> _upcomingMeetings = [
    MeetingItem(
      id: 'MTG-101',
      title: 'Annual General Meeting (AGM 2026)',
      date: 'Sunday, 18 Oct 2026',
      time: '10:00 AM - 01:00 PM',
      venue: 'Clubhouse Banquet Hall & Hybrid Zoom',
      type: 'AGM',
      agenda: [
        'Annual financial audit review & FY26 budget approval',
        'Electric Vehicle (EV) charging station policy',
        'Lift AMC vendor renewal & solar panel installation proposal',
      ],
      rsvpStatus: 'attending',
      attendingCount: 38,
      totalInvited: 50,
    ),
    MeetingItem(
      id: 'MTG-102',
      title: 'Monthly Managing Committee Review',
      date: 'Saturday, 24 Oct 2026',
      time: '06:00 PM - 07:30 PM',
      venue: 'Society Office Conference Room',
      type: 'Monthly',
      agenda: [
        'Security guard agency performance audit',
        'Festival Diwali celebration budget sanction',
        'Review open resident complaints over 7 days old',
      ],
      rsvpStatus: 'tentative',
      attendingCount: 7,
      totalInvited: 11,
    ),
  ];

  final List<MeetingItem> _pastMeetings = [
    MeetingItem(
      id: 'MTG-098',
      title: 'Monsoon Preparedness & Drainage Audit',
      date: '15 Jul 2026',
      time: '05:00 PM',
      venue: 'Society Office Room',
      type: 'Executive',
      agenda: ['Drainage desilting, basement sump pump backup checks'],
      rsvpStatus: 'attending',
      attendingCount: 10,
      totalInvited: 11,
      momPdfUrl: 'MoM_Monsoon_Audit_Jul2026.pdf',
    ),
    MeetingItem(
      id: 'MTG-095',
      title: 'FY25 Accounts & Auditor Sign-off',
      date: '28 Mar 2026',
      time: '11:00 AM',
      venue: 'Clubhouse Hall',
      type: 'AGM',
      agenda: ['Statutory auditor report sign-off, tax returns filing'],
      rsvpStatus: 'attending',
      attendingCount: 42,
      totalInvited: 50,
      momPdfUrl: 'MoM_AGM_Accounts_Mar2026.pdf',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meetings & MoM records updated'),
          backgroundColor: Color(0xFF0F5C4D),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showScheduleMeetingDialog() {
    final titleController = TextEditingController();
    final venueController = TextEditingController(text: 'Clubhouse Hall');
    final agendaController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Schedule Meeting (G4)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Meeting Title',
                  hintText: 'e.g. Special General Body Meeting',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: venueController,
                decoration: InputDecoration(
                  labelText: 'Venue / Link',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: agendaController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Agenda Items (Comma separated)',
                  hintText: 'e.g. Budget approval, Security tender, Pool maintenance',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) return;
                    setState(() {
                      _upcomingMeetings.insert(
                        0,
                        MeetingItem(
                          id: 'MTG-${DateTime.now().millisecondsSinceEpoch % 1000}',
                          title: title,
                          date: 'Upcoming, Saturday',
                          time: '05:00 PM',
                          venue: venueController.text,
                          type: 'Committee',
                          agenda: agendaController.text.isNotEmpty
                              ? agendaController.text.split(',').map((s) => s.trim()).toList()
                              : ['General committee discussion'],
                          rsvpStatus: 'attending',
                          attendingCount: 1,
                          totalInvited: 11,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Meeting scheduled: $title'),
                        backgroundColor: const Color(0xFF0F5C4D),
                      ),
                    );
                  },
                  child: const Text('Publish & Notify Members', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      appBar: AppBar(
        title: const Text(
          'Meetings & MoM (G4)',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0F5C4D),
          labelColor: const Color(0xFF0F5C4D),
          unselectedLabelColor: AppColors.mute,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          tabs: [
            Tab(text: 'Upcoming (${_upcomingMeetings.length})'),
            Tab(text: 'Past & Minutes (${_pastMeetings.length})'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F5C4D),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Schedule Meeting', style: TextStyle(fontWeight: FontWeight.w800)),
        onPressed: _showScheduleMeetingDialog,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: _handleRefresh,
        child: TabBarView(
          controller: _tabController,
          children: [
            // Upcoming Meetings List
            _upcomingMeetings.isEmpty
                ? const Center(child: Text('No upcoming meetings scheduled'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: _upcomingMeetings.length,
                    itemBuilder: (context, index) {
                      final item = _upcomingMeetings[index];
                      return _buildUpcomingCard(item);
                    },
                  ),

            // Past Meetings List with MoM Download
            _pastMeetings.isEmpty
                ? const Center(child: Text('No past meetings'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: _pastMeetings.length,
                    itemBuilder: (context, index) {
                      final item = _pastMeetings[index];
                      return _buildPastCard(item);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(MeetingItem item) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.type,
                  style: const TextStyle(
                    color: Color(0xFF0F5C4D),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.people_alt_outlined, size: 16, color: AppColors.mute),
                  const SizedBox(width: 4),
                  Text(
                    '${item.attendingCount}/${item.totalInvited} Confirmed',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            item.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 6),
              Text(item.date, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
              const SizedBox(width: 12),
              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.mute),
              const SizedBox(width: 6),
              Text(item.time, style: const TextStyle(fontSize: 12, color: AppColors.mute)),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.mute),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.venue,
                  style: const TextStyle(fontSize: 12, color: AppColors.mute),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Agenda Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Agenda Items:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.ink)),
                const SizedBox(height: 6),
                ...item.agenda.map((ag) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5C4D))),
                          Expanded(child: Text(ag, style: const TextStyle(fontSize: 11.5, color: Colors.black87))),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // RSVP Selector Bar
          const Text('Your RSVP Response:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.ink)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRsvpOption(
                label: 'Attending',
                isSelected: item.rsvpStatus == 'attending',
                color: Colors.green,
                onTap: () => setState(() => item.rsvpStatus = 'attending'),
              ),
              const SizedBox(width: 8),
              _buildRsvpOption(
                label: 'Tentative',
                isSelected: item.rsvpStatus == 'tentative',
                color: Colors.amber.shade800,
                onTap: () => setState(() => item.rsvpStatus = 'tentative'),
              ),
              const SizedBox(width: 8),
              _buildRsvpOption(
                label: 'Declined',
                isSelected: item.rsvpStatus == 'declined',
                color: Colors.red,
                onTap: () => setState(() => item.rsvpStatus = 'declined'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRsvpOption({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : AppColors.line,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? color : AppColors.mute,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPastCard(MeetingItem item) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.date, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.mute)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Concluded', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black54)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink),
          ),
          const SizedBox(height: 4),
          Text(
            'Quorum: ${item.attendingCount} members present · Venue: ${item.venue}',
            style: const TextStyle(fontSize: 11.5, color: AppColors.mute),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F5C4D),
                side: const BorderSide(color: Color(0xFF0F5C4D)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloading Minutes of Meeting: ${item.momPdfUrl ?? "MoM.pdf"}'),
                    backgroundColor: const Color(0xFF0F5C4D),
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
              label: const Text('Download Minutes (MoM PDF)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
