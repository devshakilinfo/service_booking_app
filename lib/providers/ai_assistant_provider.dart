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
  // Pre-populate with conversations matching the mockups
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Which service is best for home cleaning?',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: "For home cleaning, I recommend our Premium Home Cleaning service. It's highly rated and includes deep cleaning.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      recommendedServices: [
        ServiceModel(
          id: '1',
          name: 'Premium Home Cleaning',
          description: 'Deep home cleaning and sanitation',
          price: 25.0,
          duration: '1 hr',
          category: 'Cleaning',
          rating: 4.8,
          reviewsCount: 2500,
          image: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
        ),
      ],
    ),
    ChatMessage(
      text: 'Can you recommend a fast AC repair service? My unit is not cooling properly.',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    ChatMessage(
      text: "I'd be glad to help! Based on your requirement, here is our top-rated cooling specialist team with immediate slot availability:",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      recommendedServices: [
        ServiceModel(
          id: '2',
          name: 'AC Repair & Diagnostics',
          description: 'Full AC gas recharge, filter cleaning and cooling diagnostics',
          price: 40.0,
          duration: '1.5 hrs',
          category: 'Repair',
          rating: 4.8,
          reviewsCount: 1240,
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
            text: 'I can help you choose the best service. You can explore all available services in the search screen.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: 'For your requirement, our verified technicians are ready. Please feel free to check out our top-rated packages!',
          isUser: false,
          timestamp: DateTime.now(),
          recommendedServices: [
            ServiceModel(
              id: '1',
              name: 'Premium Home Cleaning',
              description: 'Deep home cleaning and sanitization',
              price: 25.0,
              duration: '1 hr',
              category: 'Cleaning',
              rating: 4.8,
              reviewsCount: 2500,
              image: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
            ),
          ],
        ),
      );
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _messages.add(
      ChatMessage(
        text: 'Hello Shakil! I am your ServiceHub AI Assistant, powered by Gemini. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
