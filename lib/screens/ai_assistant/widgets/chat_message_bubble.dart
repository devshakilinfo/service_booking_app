import 'package:flutter/material.dart';
import '../../../models/service_model.dart';
import '../../../providers/ai_assistant_provider.dart';
import '../../booking/booking_screen.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
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
              message.text,
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE6ECE2)),
                  ),
                  child: _buildFormattedBotText(message.text),
                ),
              ),
            ],
          ),
          if (message.recommendedServices.isNotEmpty)
            ...message.recommendedServices.map((s) => _buildRecommendedServiceCard(context, s)),
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
            if (parts.length > 1) TextSpan(text: parts.sublist(1).join(highlight)),
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

  Widget _buildRecommendedServiceCard(BuildContext context, ServiceModel service) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
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
