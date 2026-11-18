import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../models/service_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<ServiceModel> recommendedServices;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.recommendedServices = const [],
  });
}

class AIAssistantProvider with ChangeNotifier {
  // Pre-populate with exact conversation from media_1794987683573_11b1d3df.jpg
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi Shakil! I'm your ServiceHub AI Assistant. Need help finding the right service or checking prices?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: 'My AC is blowing warm air and making noise. What should I book?',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    ChatMessage(
      text: 'Based on those symptoms, I recommend our AC Repair & Diagnostics service. A certified technician can inspect refrigerant levels and fan bearings today.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      recommendedServices: [
        ServiceModel(
          id: '2',
          name: 'AC Repair & Diagnostics',
          description: 'Full AC gas recharge, refrigerant inspection and fan bearing diagnostics',
          price: 40.0,
          duration: '1.5 hrs',
          category: 'Repair',
          rating: 4.7,
          reviewsCount: 1200,
          image: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800',
        ),
      ],
    ),
  ];

  bool _isTyping = false;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(
      ChatMessage(
        text: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    _isTyping = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/ai/ask', body: {'message': text.trim()});

      if (response['success'] == true && response['data'] != null) {
        final replyText = response['data']['reply'] ?? 'Here are my recommendations for you:';
        List<ServiceModel> services = [];

        if (response['data']['recommendedServices'] != null) {
          final List<dynamic> sList = response['data']['recommendedServices'];
          services = sList.map((item) => ServiceModel.fromJson(item)).toList();
        }

        _messages.add(
          ChatMessage(
            text: replyText,
            isUser: false,
            timestamp: DateTime.now(),
            recommendedServices: services,
          ),
        );
      } else {
        _messages.add(
          ChatMessage(
            text: 'Based on your request, I recommend our Deep Home Cleaning package. Would you like to check available slots today?',
            isUser: false,
            timestamp: DateTime.now(),
            recommendedServices: [
              ServiceModel(
                id: '1',
                name: 'Deep Home Cleaning',
                description: 'Complete top-to-bottom eco-friendly residential cleaning',
                price: 25.0,
                duration: '2 hrs',
                category: 'Cleaning',
                rating: 4.8,
                reviewsCount: 2540,
                image: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
              ),
            ],
          ),
        );
      }
    } catch (e) {
      final lower = text.toLowerCase();
      if (lower.contains('clean')) {
        _messages.add(
          ChatMessage(
            text: 'For home cleaning, I recommend our Deep Home Cleaning service. It includes eco-friendly supplies and full room sanitization.',
            isUser: false,
            timestamp: DateTime.now(),
            recommendedServices: [
              ServiceModel(
                id: '1',
                name: 'Deep Home Cleaning',
                description: 'Complete top-to-bottom eco-friendly residential cleaning',
                price: 25.0,
                duration: '2 hrs',
                category: 'Cleaning',
                rating: 4.8,
                reviewsCount: 2540,
                image: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
              ),
            ],
          ),
        );
      } else {
        _messages.add(
          ChatMessage(
            text: 'Based on those symptoms, I recommend our AC Repair & Diagnostics service. A certified technician can inspect refrigerant levels and fan bearings today.',
            isUser: false,
            timestamp: DateTime.now(),
            recommendedServices: [
              ServiceModel(
                id: '2',
                name: 'AC Repair & Diagnostics',
                description: 'Full AC diagnostics and repair',
                price: 40.0,
                duration: '1.5 hrs',
                category: 'Repair',
                rating: 4.7,
                reviewsCount: 1200,
                image: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800',
              ),
            ],
          ),
        );
      }
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _messages.add(
      ChatMessage(
        text: "Hi Shakil! I'm your ServiceHub AI Assistant. Need help finding the right service or checking prices?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
