import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/screens/chat_screen.dart';

class Chat {
  final String senderName;
  final String senderAvatarUrl;
  String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isArchived;
  final bool isLocked;
  final bool isGroup;
  List<Message> messages;
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

//  simple Message model
class Message {
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  Message({
    required this.senderName,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}

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
  String _filter = 'all';

  List<Chat> get _filteredChats {
    List<Chat> chats = sampleChats;
    if (_filter == 'unread') {
      chats = chats.where((chat) => chat.unreadCount > 0).toList();
    } else if (_filter == 'groups') {
      chats = chats.where((chat) => chat.isGroup).toList();
    } else if (_filter == 'favorites') {
      chats =
          chats
              .where(
                (chat) =>
                    chat.unreadCount == 0 && !chat.isGroup && chat.isLocked,
              )
              .toList();
    }

    return chats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('All', 'all'),
                _buildFilterButton('Unread', 'unread'),
                _buildFilterButton('Starred', 'starred'),
                _buildFilterButton('Archived', 'archived'),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Colors.grey),
          Expanded(child: ListView.builder(
              itemCount: _filteredChats.length,
              itemBuilder: (context, index){
            final chat = _filteredChats[index];
            return _buildChatItem(chat, context);
          }))
        ],
      ),
    );
  }

  // Filter button widget
  Widget _buildFilterButton(String label, String filterValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filter = filterValue;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          label,
          style: TextStyle(
            color: _filter == filterValue ? Colors.green : Colors.grey,
            fontWeight:
                _filter == filterValue ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Chat item widget
  Widget _buildChatItem(Chat chat, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatScreen(
                  // Use the ChatScreen widget
                  chatName: chat.senderName,
                  chatAvatarUrl: chat.senderAvatarUrl,
                  messages: chat.messages, // Pass the messages to the ChatScreen
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
            // Chat details (name, last message, time)
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
                            fontWeight:
                                chat.unreadCount > 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      // Time
                      Text(
                        _formatTimestamp(chat.timestamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      //Show lock
                      if (chat.isLocked)
                        const Icon(Icons.lock, color: Colors.grey, size: 12),
                      // Last message and ticks
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                chat.unreadCount > 0
                                    ? Colors.black
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      // Unread count badge
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
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

  // Function to format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 1) {
      return DateFormat('dd/MM/yyyy').format(timestamp); // e.g., 01/01/2023
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('h:mm a').format(timestamp); // e.g., 10:30 AM
    }
  }
}
