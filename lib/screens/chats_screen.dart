import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/screens/chat_screen.dart';

// Chat model representing a single chat
class Chat {
  final String senderName; // Name of the sender
  final String senderAvatarUrl; // Avatar URL of the sender
  String lastMessage; // Last message in the chat
  final DateTime timestamp; // Timestamp of the last message
  final int unreadCount; // Number of unread messages
  final bool isArchived; // Whether the chat is archived
  final bool isLocked; // Whether the chat is locked
  final bool isGroup; // Whether the chat is a group chat
  List<Message> messages; // List of messages in the chat

  Chat({
    required this.senderName,
    required this.senderAvatarUrl,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isArchived = false,
    this.isGroup = false,
    this.isLocked = false,
    this.messages = const [],
  });
}

// Message model representing a single message
class Message {
  final String senderName; // Name of the sender
  final String text; // Text content of the message
  final DateTime timestamp; // Timestamp of the message
  final bool isMe; // Whether the message was sent by the user

  Message({
    required this.senderName,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}

// Sample chat data for demonstration
final List<Chat> sampleChats = [
  Chat(
    senderName: 'Eric',
    senderAvatarUrl: 'https://i.pravatar.cc/300',
    lastMessage: 'Hey, how are you?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    unreadCount: 2,
    messages: [
      Message(
        senderName: 'Eric',
        text: 'Hello',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 11)),
      ),
      Message(
        senderName: 'You',
        text: 'Hey, how are you?',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ],
  ),
  Chat(
    senderName: 'Tabby',
    senderAvatarUrl: 'https://i.pravatar.cc/300',
    lastMessage: 'Let\'s meet tommorow',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    unreadCount: 0,
    messages: [
      Message(
        senderName: 'You',
        text: 'Hello',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 11)),
      ),
      Message(
        senderName: 'You',
        text: 'Let\'s meet tommorow',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ],
  ),
  Chat(
    senderName: 'Victor',
    senderAvatarUrl: 'https://i.pravatar.cc/300',
    lastMessage: 'Hey, how are you?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    unreadCount: 2,
    messages: [
      Message(
        senderName: 'You',
        text: 'Hello',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 11)),
      ),
      Message(
        senderName: 'Victor',
        text: 'Hey, how are you?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ],
  ),
  Chat(
    senderName: 'Locked Chat',
    senderAvatarUrl: 'https://i.pravatar.cc/300',
    lastMessage: 'Important message',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    isLocked: true,
    messages: [
      Message(
        senderName: 'Locked Chat',
        text: 'Important message',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
      ),
    ],
  ),
  Chat(
    senderName: 'My Favorite Contact',
    senderAvatarUrl: 'https://i.pravatar.cc/300',
    lastMessage: 'Lets go for lunch',
    timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    unreadCount: 0,
    messages: [
      Message(
        senderName: 'My Favorite Contact',
        text: 'Lets go for lunch',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isMe: false,
      ),
    ],
  ),
];

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  String _filter = 'all'; // Current filter applied to the chat list

  // Getter to filter chats based on the selected filter
  List<Chat> get _filteredChats {
    List<Chat> chats = sampleChats;
    if (_filter == 'unread') {
      chats = chats.where((chat) => chat.unreadCount > 0).toList(); // Filter unread chats
    } else if (_filter == 'groups') {
      chats = chats.where((chat) => chat.isGroup).toList(); // Filter group chats
    } else if (_filter == 'favorites') {
      chats = chats.where((chat) => chat.unreadCount == 0 && !chat.isGroup && chat.isLocked).toList(); // Filter favorite chats
    }
    return chats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('All', 'all'), // Button for "All" filter
                _buildFilterButton('Unread', 'unread'), // Button for "Unread" filter
                _buildFilterButton('Starred', 'starred'), // Button for "Starred" filter
                _buildFilterButton('Archived', 'archived'), // Button for "Archived" filter
              ],
            ),
          ),
          const Divider(height: 1.0, color: Colors.grey), // Divider line
          // List of chats
          Expanded(
            child: ListView.builder(
              itemCount: _filteredChats.length, // Number of filtered chats
              itemBuilder: (context, index) {
                final chat = _filteredChats[index];
                return _buildChatItem(chat, context); // Build each chat item
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build a filter button
  Widget _buildFilterButton(String label, String filterValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filter = filterValue; // Update the filter when button is tapped
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          label,
          style: TextStyle(
            color: _filter == filterValue ? Colors.green : Colors.grey, // Highlight selected filter
            fontWeight: _filter == filterValue ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Widget to build a chat item
  Widget _buildChatItem(Chat chat, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatName: chat.senderName, // Pass chat name to ChatScreen
              chatAvatarUrl: chat.senderAvatarUrl, // Pass avatar URL to ChatScreen
              messages: chat.messages, // Pass messages to ChatScreen
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(backgroundImage: NetworkImage(chat.senderAvatarUrl)),
            const SizedBox(width: 12.0),
            // Chat details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.senderName,
                          style: TextStyle(
                            fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal, // Bold if unread
                          ),
                        ),
                      ),
                      // Timestamp
                      Text(
                        _formatTimestamp(chat.timestamp),
                        style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      if (chat.isLocked) const Icon(Icons.lock, color: Colors.grey, size: 12), // Lock icon if chat is locked
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          overflow: TextOverflow.ellipsis, // Ellipsis for long messages
                          style: TextStyle(color: chat.unreadCount > 0 ? Colors.black : Colors.grey),
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
}
