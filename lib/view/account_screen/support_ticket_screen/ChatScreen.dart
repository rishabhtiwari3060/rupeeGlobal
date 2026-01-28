import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }


  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;


    setState(() {
      _messages.add(
        _ChatMessage(
          message: text,
          isMe: true,
          time: TimeOfDay.now().format(context),
        ),
      );
    });


    _messageController.clear();


// Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }
  Widget _buildInputArea() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 22,
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ChatBubble extends StatelessWidget {
  final _ChatMessage message;


  const ChatBubble({Key? key, required this.message}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final alignment = message.isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.isMe ? Colors.blue : Colors.grey.shade300;
    final textColor = message.isMe ? Colors.white : Colors.black87;


    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: message.isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}


class _ChatMessage {
  final String message;
  final bool isMe;
  final String time;


  _ChatMessage({
    required this.message,
    required this.isMe,
    required this.time,
  });
}
