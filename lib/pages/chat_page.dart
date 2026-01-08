import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Halo! Selamat datang di TechWatch Pro. Ada yang bisa saya bantu?',
      isFromSeller: true,
      time: '10:30',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isFromSeller: false,
          time: TimeOfDay.now().format(context),
        ),
      );
      _messageController.clear();

      // Simulate seller response
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Terima kasih atas pertanyaannya! Tim kami akan segera merespons.',
              isFromSeller: true,
              time: TimeOfDay.now().format(context),
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.store, color: Colors.indigo[700]),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TechWatch Pro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Response Suggestions
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickResponse('Apakah ready stock?'),
                  _buildQuickResponse('Berapa lama pengiriman?'),
                  _buildQuickResponse('Ada garansi?'),
                  _buildQuickResponse('Bisa nego?'),
                ],
              ),
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.indigo),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickResponse(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {
          _messageController.text = text;
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.indigo),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isFromSeller ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isFromSeller ? Colors.grey[200] : Colors.indigo,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: message.isFromSeller ? Radius.zero : const Radius.circular(16),
            bottomRight: message.isFromSeller ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isFromSeller ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                color: message.isFromSeller ? Colors.grey[600] : Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isFromSeller;
  final String time;

  ChatMessage({
    required this.text,
    required this.isFromSeller,
    required this.time,
  });
}
