import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/screens/chats_screen.dart'; // Import the intl package for date formatting

//Chat Screen
class ChatScreen extends StatefulWidget {
  final String chatName;
  final String chatAvatarUrl;
  final List<Message> messages;

  const ChatScreen({
    super.key,
    required this.chatName,
    required this.chatAvatarUrl,
    this.messages = const [], // Receive messages, default to empty list.
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = []; // Use a local state variable for messages

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.messages); // Initialize with widget's messages
    // Scroll to the bottom of the list when the widget is initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            senderName: 'You', // The current user is sending the message.
            text: _messageController.text,
            timestamp: DateTime.now(),
            isMe: true,
          ),
        );
        _messageController.clear();
        _scrollToBottom(); // Scroll to bottom after sending message.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.chatAvatarUrl)),
            const SizedBox(width: 12.0),
            Text(widget.chatName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              // Handle video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Handle audio call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Message List View
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),
          // Message Input Area
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  // Message item widget
  Widget _buildMessageItem(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: message.isMe ? Colors.green[200] : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * 0.7, // Limit message width
          ),
          child: Column(
            crossAxisAlignment:
                message.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Text(
                message.senderName,
                style: TextStyle(
                  fontWeight:
                      message.isMe ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(message.text),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(message.timestamp),
                style: const TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 1) {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('h:mm a').format(timestamp);
    }
  }

  // Message input area widget
  Widget _buildMessageInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                _sendMessage();
              },
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
