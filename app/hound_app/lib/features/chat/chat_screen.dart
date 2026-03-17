import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

enum _MessageType { sent, received }

class _MockMessage {
  final String text;
  final _MessageType type;
  final String time;

  const _MockMessage({
    required this.text,
    required this.type,
    required this.time,
  });
}

const _mockMessages = [
  _MockMessage(
    text: 'Merhaba! Jasper ile Hyde Park\'ta bir yürüyüş planlamak ister misiniz?',
    type: _MessageType.received,
    time: '10:30',
  ),
  _MockMessage(
    text: 'Harika fikir! Bu hafta sonu uygun musunuz?',
    type: _MessageType.sent,
    time: '10:32',
  ),
  _MockMessage(
    text: 'Cumartesi sabah 10\'da buluşalım mı?',
    type: _MessageType.received,
    time: '10:35',
  ),
];

class ChatScreen extends ConsumerStatefulWidget {
  final String threadId;

  const ChatScreen({super.key, required this.threadId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: Column(
          children: [
            // Glass-morphism header
            _buildHeader(context),

            // Chat messages
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                children: [
                  // Date divider
                  _buildDateDivider('BUGÜN'),
                  const SizedBox(height: 16),

                  // Messages
                  ..._mockMessages.map((msg) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildMessageBubble(msg),
                      )),
                ],
              ),
            ),

            // Bottom message input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.navy,
              size: 22,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jasper & Alex',
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ÇEVRİMİÇİ',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.push('/walk-plan/${widget.threadId}');
            },
            child: Text(
              'Yürüyüş Planla',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              letterSpacing: 2,
              color: AppColors.textLight,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _buildMessageBubble(_MockMessage message) {
    final isSent = message.type == _MessageType.sent;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSent
                ? const Color(0xFF1A2332)
                : const Color(0xFFE5E1D8),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isSent ? 18 : 4),
              bottomRight: Radius.circular(isSent ? 4 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: AppTextStyles.chatMessage.copyWith(
                  color: isSent ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.time,
                    style: AppTextStyles.chatTimestamp.copyWith(
                      color: isSent
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.textLight,
                    ),
                  ),
                  if (isSent) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),

          // Text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: AppTextStyles.chatMessage.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Mesajınızı yazın...',
                  hintStyle: AppTextStyles.chatMessage.copyWith(
                    color: AppColors.textLight,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: _hasText
                ? () {
                    _messageController.clear();
                  }
                : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _hasText ? AppColors.primary : AppColors.backgroundAlt,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                size: 18,
                color: _hasText ? Colors.white : AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
