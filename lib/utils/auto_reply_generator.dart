import 'dart:math';

class AutoReplyGenerator {
  static final List<String> _replies = [
    "That's interesting! Tell me more.",
    "I see what you mean.",
    "Thanks for sharing!",
    "Got it! I'll get back to you soon.",
    "Sounds good to me!",
    "Really? That's fascinating!",
    "I understand completely.",
    "Let me think about that.",
    "Great point!",
    "I appreciate your message.",
  ];

  static String getRandomReply() {
    final random = Random();
    return _replies[random.nextInt(_replies.length)];
  }

  static Duration getRandomDelay() {
    final random = Random();
    // Random delay between 1 and 3 seconds
    return Duration(milliseconds: 1000 + random.nextInt(2000));
  }
}