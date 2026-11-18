import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service_model.dart';
import '../../providers/ai_assistant_provider.dart';
import '../booking/booking_screen.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    'Best cleaning package?',
    'Available slots today',
    'Compare repair plans',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? text]) {
    final query = text ?? _messageController.text;
    if (query.trim().isEmpty) return;

    final provider = Provider.of<AIAssistantProvider>(context, listen: false);
    provider.sendMessage(query);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIAssistantProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header matching media_1794987683573_11b1d3df.jpg
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE8EEE4), width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Green Circle Robot Icon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Color(0xFF427E2B),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.smart_toy_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title & Online Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ServiceHub AI Assistant',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF142E18),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF55A630),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Online • Powered by Gemini AI',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4C8C32),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right Close / Reset Button
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        aiProvider.clearChat();
                      }
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF4A5D4B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chat Messages Stream
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: aiProvider.messages.length,
                itemBuilder: (context, index) {
                  final msg = aiProvider.messages[index];
                  return _buildMessageItem(msg);
                },
              ),
            ),

            if (aiProvider.isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE6ECE2)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF285428),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Thinking...',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF5A6D5B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom Composer Area (Quick Chips + Rounded Input Bar)
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAF6),
                border: Border(
                  top: BorderSide(color: Color(0xFFE8EEE4), width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quick Prompt Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickPrompts.map((prompt) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => _sendMessage(prompt),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F1E1),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: const Color(0xFFCDE1C4)),
                              ),
                              child: Text(
                                prompt,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E4620),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Input Pill with embedded green send circle
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 18, right: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFDCE4D8)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF142E18),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Ask about services or prices...',
                              hintStyle: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF7A8B7B),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _sendMessage(),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFF285428),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage msg) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 48),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: const BoxDecoration(
              color: Color(0xFF285428),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    // Bot Response Bubble + Recommended Service Card
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Small Bot Avatar Circle
              Container(
                width: 34,
                height: 34,
                margin: const EdgeInsets.only(right: 10, top: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3E8),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD5E4CF)),
                ),
                child: const Center(
                  child: Text('🤖', style: TextStyle(fontSize: 16)),
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE6ECE2)),
                  ),
                  child: _buildFormattedBotText(msg.text),
                ),
              ),
            ],
          ),
          if (msg.recommendedServices.isNotEmpty)
            ...msg.recommendedServices
                .map((s) => _buildRecommendedServiceCard(s)),
        ],
      ),
    );
  }

  Widget _buildFormattedBotText(String text) {
    const highlight = 'AC Repair & Diagnostics';
    if (text.contains(highlight)) {
      final parts = text.split(highlight);
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2E21),
            height: 1.45,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(text: parts[0]),
            const TextSpan(
              text: highlight,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF142E18),
              ),
            ),
            if (parts.length > 1)
              TextSpan(text: parts.sublist(1).join(highlight)),
          ],
        ),
      );
    }

    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1F2E21),
        height: 1.45,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildRecommendedServiceCard(ServiceModel service) {
    final reviewsLabel = service.reviewsCount >= 1000
        ? '${(service.reviewsCount / 1000).toStringAsFixed(1)}k'
        : '${service.reviewsCount}';

    return Container(
      margin: const EdgeInsets.only(left: 44, top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC5DFBC), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: RECOMMENDED SERVICE + Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECOMMENDED SERVICE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4C8C32),
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                '${service.rating} ★ ($reviewsLabel)',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD98218),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Service Title
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF142E18),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE0EDE0)),
          const SizedBox(height: 10),
          // Bottom Row: Price • Duration + Quick Book Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${service.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E4620),
                      ),
                    ),
                    TextSpan(
                      text: ' • ${service.duration}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A6D5B),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(service: service),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF285428),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Quick Book →',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
