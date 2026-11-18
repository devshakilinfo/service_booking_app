import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service_model.dart';
import '../../providers/ai_assistant_provider.dart';
import '../booking/booking_screen.dart';
import 'widgets/chat_message_bubble.dart';

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

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: aiProvider.messages.length,
                itemBuilder: (context, index) {
                  final msg = aiProvider.messages[index];
                  return ChatMessageBubble(message: msg);
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
}
