import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    context.read<ChatProvider>().sendMessage(
      widget.chat.id,
      _textController.text.trim(),
    );

    _textController.clear();
    setState(() => _isTyping = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.avatarUrl),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (widget.chat.isOnline)
                    const Text(
                      'online',
                      style: TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.getMessages(widget.chat.id);
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  itemCount: messages.length + (chatProvider.isTyping(widget.chat.id) ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (chatProvider.isTyping(widget.chat.id) && index == 0) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 64),
                          child: Card(
                            color: Theme.of(context).colorScheme.surface,
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: TypingIndicator(),
                            ),
                          ),
                        ),
                      );
                    }

                    final messageIndex = chatProvider.isTyping(widget.chat.id)
                        ? index - 1
                        : index;
                    final message = messages[messages.length - 1 - messageIndex];

                    return MessageBubble(
                      message: message,
                      isMe: message.senderId == 'Ramy888',
                    );
                  },
                );
              },
            ),
          ),
          if (_isTyping) const TypingIndicator(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _isTyping = value.isNotEmpty);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                ),
                IconButton(
                  icon: _textController.text.isEmpty
                      ? const Icon(Icons.mic)
                      : const Icon(Icons.send),
                  onPressed: _textController.text.isEmpty ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}