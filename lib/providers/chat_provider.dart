import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../utils/auto_reply_generator.dart';

class ChatProvider with ChangeNotifier {
  final List<Chat> _chats = [];
  final Map<String, List<Message>> _messages = {};
  final Map<String, bool> _typingStatus = {};

  List<Chat> get chats => _chats;
  List<Message> getMessages(String chatId) => _messages[chatId] ?? [];
  bool isTyping(String chatId) => _typingStatus[chatId] ?? false;

  ChatProvider() {
    _initDummyData();
  }

  void _initDummyData() {
    // Add dummy chats
    _chats.addAll([
      Chat(
        id: '1',
        name: 'John Doe',
        lastMessage: 'Hey, how are you?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        isOnline: true,
        unreadCount: 2, avatarUrl: '',
      ),
      Chat(
        id: '2',
        name: 'Jane Smith',
        lastMessage: 'See you tomorrow!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        isOnline: false, avatarUrl: '',
      ),
    ]);

    // Add dummy messages for each chat
    for (var chat in _chats) {
      _messages[chat.id] = _generateDummyMessages(chat.id);
    }
  }

  List<Message> _generateDummyMessages(String chatId) {
    return [
      Message(
        id: DateTime.now().toString(),
        senderId: 'user',
        receiverId: chatId,
        content: 'Hello!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: MessageStatus.read,
      ),
      Message(
        id: DateTime.now().toString(),
        senderId: chatId,
        receiverId: 'user',
        content: 'Hi! How are you?',
        timestamp: DateTime.now().subtract(const Duration(hours: 23)),
      ),
    ];
  }

  void sendMessage(String chatId, String content) {
    final message = Message(
      id: DateTime.now().toString(),
      senderId: 'Ramy888',
      receiverId: chatId,
      content: content,
      timestamp: DateTime.now(),
    );

    _messages[chatId] = [...getMessages(chatId), message];
    _updateLastMessage(chatId, content);
    notifyListeners();

    // Simulate three replies
    _simulateReplies(chatId);
  }

  void _simulateReplies(String chatId) {
    // First reply
    _simulateTyping(chatId, () {
      _addReply(chatId, 1);

      // Second reply
      Future.delayed(const Duration(seconds: 4), () {
        _simulateTyping(chatId, () {
          _addReply(chatId, 2);

          // Third reply
          Future.delayed(const Duration(seconds: 5), () {
            _simulateTyping(chatId, () {
              _addReply(chatId, 3);
            });
          });
        });
      });
    });
  }

  void _simulateTyping(String chatId, VoidCallback onComplete) {
    _typingStatus[chatId] = true;
    notifyListeners();

    Future.delayed(AutoReplyGenerator.getRandomDelay(), () {
      _typingStatus[chatId] = false;
      onComplete();
      notifyListeners();
    });
  }

  void _addReply(String chatId, int replyNumber) {
    final chat = _chats.firstWhere((chat) => chat.id == chatId);
    final content = AutoReplyGenerator.getRandomReply();

    final message = Message(
      id: DateTime.now().toString(),
      senderId: chatId,
      receiverId: 'Ramy888',
      content: content,
      timestamp: DateTime.now(),
    );

    _messages[chatId] = [...getMessages(chatId), message];
    _updateLastMessage(chatId, content);
    notifyListeners();
  }

  void _updateLastMessage(String chatId, String content) {
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final updatedChat = Chat(
        id: _chats[chatIndex].id,
        name: _chats[chatIndex].name,
        lastMessage: content,
        lastMessageTime: DateTime.now(),
        isOnline: _chats[chatIndex].isOnline,
        avatarUrl: '',
      );
      _chats[chatIndex] = updatedChat;
    }
  }
}