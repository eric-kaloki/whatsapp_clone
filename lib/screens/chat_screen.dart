import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/screens/chats_screen.dart'; // Import the intl package for date formatting

// ChatScreen widget to display chat messages and input area
class ChatScreen extends StatefulWidget {
  final String chatName; // Name of the chat
  final String chatAvatarUrl; // Avatar URL of the chat
  final List<Message> messages; // List of messages in the chat

  const ChatScreen({
    super.key,
    required this.chatName,
    required this.chatAvatarUrl,
    this.messages = const [], // Default to an empty list if no messages are provided
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController(); // Controller for the message input field
  final ScrollController _scrollController = ScrollController(); // Controller for scrolling the message list
  List<Message> _messages = []; // Local state variable to store messages

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.messages); // Initialize with messages passed to the widget
    // Scroll to the bottom of the list after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // Scroll to the bottom of the message list
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Send a message and add it to the message list
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            senderName: 'You', // The current user is the sender
            text: _messageController.text, // Message text from the input field
            timestamp: DateTime.now(), // Current timestamp
            isMe: true, // Indicates the message is sent by the user
          ),
        );
        _messageController.clear(); // Clear the input field
        _scrollToBottom(); // Scroll to the bottom after sending the message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.chatAvatarUrl)), // Chat avatar
            const SizedBox(width: 12.0),
            Text(widget.chatName), // Chat name
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call), // Video call button
            onPressed: () {
              // Handle video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call), // Audio call button
            onPressed: () {
              // Handle audio call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert), // More options button
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Message list view
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach scroll controller
              itemCount: _messages.length, // Number of messages
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message); // Build each message item
              },
            ),
          ),
          // Message input area
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  // Widget to build a single message item
  Widget _buildMessageItem(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft, // Align based on sender
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: message.isMe ? Colors.green[200] : Colors.grey[300], // Different background color for sent/received messages
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit message width
          ),
          child: Column(
            crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, // Align text based on sender
            children: [
              Text(
                message.senderName, // Sender's name
                style: TextStyle(
                  fontWeight: message.isMe ? FontWeight.bold : FontWeight.normal, // Bold for user's messages
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(message.text), // Message text
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(message.timestamp), // Formatted timestamp
                style: const TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 1) {
      return DateFormat('dd/MM/yyyy').format(timestamp); // Format as date if older than a day
    } else if (difference.inDays == 1) {
      return 'Yesterday'; // Show "Yesterday" if one day old
    } else {
      return DateFormat('h:mm a').format(timestamp); // Format as time for today
    }
  }

  // Widget to build the message input area
  Widget _buildMessageInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController, // Attach controller
              decoration: const InputDecoration(
                hintText: 'Type your message...', // Placeholder text
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                _sendMessage(); // Send message on pressing "Enter"
              },
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send), // Send button
            onPressed: _sendMessage, // Send message on button press
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose(); // Dispose the message controller
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }
}
