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
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I am your ServiceHub AI Assistant.\nHow can I help you today? Ask me about home cleaning, AC repair, plumbing or pricing recommendations!',
      isUser: false,
      timestamp: DateTime.now(),
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
        final replyText = response['data']['reply'] ?? 'I found the following services for you:';
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
            text: 'I am having trouble answering right now. Please explore services directly on the Home screen.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: 'Unable to connect to the assistant. Please verify your backend server connection.',
          isUser: false,
          timestamp: DateTime.now(),
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
        text: 'Hello! I am your ServiceHub AI Assistant. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
