import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/models/role_enum.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_card.dart';

class PollOption {
  final String text;
  int votes;

  PollOption({required this.text, required this.votes});
}

class PollItem {
  final String id;
  final String question;
  final String expiresOn;
  final List<PollOption> options;
  int? userVotedOptionIndex;

  PollItem({
    required this.id,
    required this.question,
    required this.expiresOn,
    required this.options,
    this.userVotedOptionIndex,
  });

  int get totalVotes => options.fold(0, (sum, opt) => sum + opt.votes);
}

/// Module 8: Notices & Polls - Society Polls & Democratic Voting
class PollsScreen extends ConsumerStatefulWidget {
  const PollsScreen({super.key});

  @override
  ConsumerState<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends ConsumerState<PollsScreen> {
  final List<PollItem> _polls = [
    PollItem(
      id: '1',
      question: 'Should the society install Rooftop Solar Panels in the Clubhouse to reduce electricity bills?',
      expiresOn: 'Ends in 3 days',
      options: [
        PollOption(text: 'Yes, full solar transition', votes: 48),
        PollOption(text: 'No, initial capital too high', votes: 12),
        PollOption(text: 'Need committee quote comparison first', votes: 20),
      ],
      userVotedOptionIndex: 0,
    ),
    PollItem(
      id: '2',
      question: 'Proposed Gym Timing Revision: Keep gym open between 5:30 AM to 10:30 PM continuously?',
      expiresOn: 'Ends in 5 days',
      options: [
        PollOption(text: 'Agree with continuous timing', votes: 64),
        PollOption(text: 'Keep afternoon closing for maintenance', votes: 28),
      ],
      userVotedOptionIndex: null,
    ),
    PollItem(
      id: '3',
      question: 'Diwali Celebration Contribution: ₹1,500 per flat special budget allocation?',
      expiresOn: 'Closed on 05 Oct',
      options: [
        PollOption(text: 'Approved (₹1,500 contribution)', votes: 98),
        PollOption(text: 'Limit to ₹1,000 per flat', votes: 34),
        PollOption(text: 'Use existing cultural reserve fund', votes: 16),
      ],
      userVotedOptionIndex: 0,
    ),
  ];

  void _showCreatePollModal() {
    final questionCtrl = TextEditingController();
    final opt1Ctrl = TextEditingController(text: 'Yes, agree');
    final opt2Ctrl = TextEditingController(text: 'No, disagree');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Committee Poll',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: questionCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Poll Question',
                  hintText: 'e.g. Should society allow pet walking in central lawn?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: opt1Ctrl,
                decoration: InputDecoration(
                  labelText: 'Option 1',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: opt2Ctrl,
                decoration: InputDecoration(
                  labelText: 'Option 2',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5C4D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (questionCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        _polls.insert(
                          0,
                          PollItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            question: questionCtrl.text.trim(),
                            expiresOn: 'Ends in 7 days',
                            options: [
                              PollOption(text: opt1Ctrl.text.trim(), votes: 0),
                              PollOption(text: opt2Ctrl.text.trim(), votes: 0),
                            ],
                            userVotedOptionIndex: null,
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Poll published! Residents can now vote.'),
                          backgroundColor: Color(0xFF0F5C4D),
                        ),
                      );
                    }
                  },
                  child: const Text('Publish Poll', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
    final user = ref.watch(authProvider).user;
    final isPrivileged = user?.activeRole == UserRole.committee ||
        user?.activeRole == UserRole.admin ||
        user?.activeRole == UserRole.superAdmin;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Polls & Voting', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isPrivileged)
            IconButton(
              icon: const Icon(Icons.add_chart_rounded, color: Color(0xFF0F5C4D)),
              onPressed: _showCreatePollModal,
            ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF0F5C4D),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) setState(() {});
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            // Democratic Voting Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4F1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0F5C4D).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.how_to_vote_rounded, color: Color(0xFF0F5C4D), size: 30),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Your vote matters! 1 Vote allowed per flat for society decisions and major resolutions.',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F5C4D), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ..._polls.map((poll) => _buildPollCard(poll)),
          ],
        ),
      ),
    );
  }

  Widget _buildPollCard(PollItem poll) {
    final total = poll.totalVotes;
    final hasVoted = poll.userVotedOptionIndex != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (poll.expiresOn.contains('Closed') ? Colors.grey : const Color(0xFF0F5C4D)).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    poll.expiresOn,
                    style: TextStyle(
                      color: poll.expiresOn.contains('Closed') ? Colors.grey.shade700 : const Color(0xFF0F5C4D),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '$total Votes Cast',
                  style: const TextStyle(color: AppColors.mute, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              poll.question,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink, height: 1.3),
            ),
            const SizedBox(height: 16),

            // Options List
            ...List.generate(poll.options.length, (idx) {
              final opt = poll.options[idx];
              final percent = total > 0 ? (opt.votes / total) : 0.0;
              final isSelected = poll.userVotedOptionIndex == idx;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    if (!poll.expiresOn.contains('Closed')) {
                      setState(() {
                        if (poll.userVotedOptionIndex != null) {
                          poll.options[poll.userVotedOptionIndex!].votes--;
                        }
                        poll.userVotedOptionIndex = idx;
                        opt.votes++;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0F5C4D).withValues(alpha: 0.06) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0F5C4D) : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                              color: isSelected ? const Color(0xFF0F5C4D) : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                opt.text,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? const Color(0xFF0F5C4D) : AppColors.ink,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (hasVoted)
                              Text(
                                '${(percent * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? const Color(0xFF0F5C4D) : AppColors.mute,
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                        if (hasVoted) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percent,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isSelected ? const Color(0xFF0F5C4D) : Colors.grey.shade400,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
