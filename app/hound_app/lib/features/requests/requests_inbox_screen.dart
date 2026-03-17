import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/status_badge.dart';

enum _RequestStatus { pending, accepted, rejected }

class _MockRequest {
  final String id;
  final String dogName;
  final String breed;
  final _RequestStatus status;
  final String timeAgo;
  final String message;
  final String threadId;

  const _MockRequest({
    required this.id,
    required this.dogName,
    required this.breed,
    required this.status,
    required this.timeAgo,
    required this.message,
    required this.threadId,
  });
}

const _mockIncomingRequests = [
  _MockRequest(
    id: 'req-1',
    dogName: 'Bella',
    breed: 'Labrador Retriever',
    status: _RequestStatus.pending,
    timeAgo: '2 sa. önce',
    message: 'Bella ile Hyde Park\'ta yürüyüş yapmak ister misiniz?',
    threadId: 'mock-thread-1',
  ),
  _MockRequest(
    id: 'req-2',
    dogName: 'Charlie',
    breed: 'French Bulldog',
    status: _RequestStatus.accepted,
    timeAgo: '1 gün önce',
    message: 'Charlie çok arkadaş canlısı, tanışmak isteriz!',
    threadId: 'mock-thread-2',
  ),
  _MockRequest(
    id: 'req-3',
    dogName: 'Luna',
    breed: 'Border Collie',
    status: _RequestStatus.rejected,
    timeAgo: '3 gün önce',
    message: 'Luna bu hafta sonu müsait, buluşalım mı?',
    threadId: 'mock-thread-3',
  ),
];

const _mockOutgoingRequests = [
  _MockRequest(
    id: 'req-4',
    dogName: 'Max',
    breed: 'German Shepherd',
    status: _RequestStatus.pending,
    timeAgo: '5 sa. önce',
    message: 'Jasper ile tanışmak ister misiniz?',
    threadId: 'mock-thread-4',
  ),
];

class RequestsInboxScreen extends ConsumerStatefulWidget {
  const RequestsInboxScreen({super.key});

  @override
  ConsumerState<RequestsInboxScreen> createState() =>
      _RequestsInboxScreenState();
}

class _RequestsInboxScreenState extends ConsumerState<RequestsInboxScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    'HOUND',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Segmented tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.backgroundAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: AppTextStyles.labelMedium.copyWith(
                    letterSpacing: 1,
                  ),
                  unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
                    letterSpacing: 1,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Gelen'),
                    Tab(text: 'Giden'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Request list
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRequestList(_mockIncomingRequests),
                  _buildRequestList(_mockOutgoingRequests),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList(List<_MockRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 56,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz istek yok',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildRequestCard(requests[index]);
      },
    );
  }

  Widget _buildRequestCard(_MockRequest request) {
    final isRejected = request.status == _RequestStatus.rejected;

    return Opacity(
      opacity: isRejected ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: photo, name, status, time
            Row(
              children: [
                // Dog thumbnail
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.champagne,
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 28,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                // Name + breed
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.dogName,
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        request.breed,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Status + time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStatusBadge(request.status),
                    const SizedBox(height: 4),
                    Text(
                      request.timeAgo,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                request.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            // Action buttons
            if (!isRejected) ...[
              const SizedBox(height: 16),
              _buildActionButtons(request),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(_RequestStatus status) {
    switch (status) {
      case _RequestStatus.pending:
        return const StatusBadge(
          text: 'BEKLEMEDE',
          type: StatusBadgeType.pending,
          showDot: true,
        );
      case _RequestStatus.accepted:
        return const StatusBadge(
          text: 'ONAYLANDI',
          type: StatusBadgeType.approved,
          showDot: true,
        );
      case _RequestStatus.rejected:
        return const StatusBadge(
          text: 'REDDEDİLDİ',
          type: StatusBadgeType.rejected,
          showDot: true,
        );
    }
  }

  Widget _buildActionButtons(_MockRequest request) {
    switch (request.status) {
      case _RequestStatus.pending:
        return Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'KABUL ET',
                icon: Icons.check,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'REDDET',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      case _RequestStatus.accepted:
        return Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'MESAJ GÖNDER',
                icon: Icons.chat_bubble_outline,
                onPressed: () {
                  // Business rule: navigate to real chat screen
                  context.push('/chat/${request.threadId}');
                },
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.archive_outlined,
                size: 20,
              ),
            ),
          ],
        );
      case _RequestStatus.rejected:
        return const SizedBox.shrink();
    }
  }
}
