# WhatsApp Clone App - README

## Introduction

This project is a simplified clone of the WhatsApp mobile application, built using Flutter. It's designed to help you understand how a messaging app's basic structure and UI work. This README will guide you through the app's components and how they function.

## App Structure

The app is structured as follows:

* **`main.dart`**: This is the entry point of the application. It sets up the app's theme and launches the main screen.

* **`chats_screen.dart`**: This file contains the code for the main chat screen, displaying a list of recent conversations.

* **`chat_screen.dart`**: This file contains the code for a specific chat screen, displaying the message history and message input area for a selected contact.

* **Data Models**:

    * `Chat`: Represents a single chat item in the chat list (sender, last message, timestamp, etc.).

    * `Message`: Represents a single message within a chat conversation (sender, text, timestamp).

## Key Components and How They Work

### 1\.  `main.dart`

* Sets up the `MaterialApp`, which is the base widget for a Flutter application.

* Defines the app's theme (colors, fonts, etc.).

* Specifies the `WhatsAppHomeScreen` as the home screen, which is the starting point of the app's UI.

### 2\.  `WhatsAppHomeScreen`

* This is the main screen of the app, displaying the bottom navigation bar and the main content.

* It uses a `Scaffold` widget, which provides the basic structure for a screen (app bar, body, bottom navigation).

* It contains a `BottomNavigationBar` (or `NavigationBar` in Material 3) to allow users to switch between different sections of the app:

    * Chats

    * Status

    * Community

    * Calls

* The `_selectedIndex` variable keeps track of the currently selected tab.

* The `_screens` list holds the widgets to display for each tab.

* The `AppBar` displays the title of the app and any action buttons (search, more options).

### 3\.  `ChatsScreen`

* Displays a list of recent chat conversations.

* **Filters**:

    * **All**: Shows all recent chats.

    * **Unread**: Shows chats with unread messages.

    * **Groups**: Shows group chats.

    * **Favorites**: Shows chats marked as favorites (in this case, chats with no unread messages, not groups and not locked).

* **Archived Chats**: Displays a section for archived chats.

* **Chat List**:

    * Uses a `ListView.builder` to efficiently display the list of chats.

    * Each chat item displays the sender's avatar, name, last message, and timestamp.

    * Tapping on a chat item navigates the user to the `ChatScreen` for that conversation.

* **Data Handling**:

    * Uses a list of `Chat` objects (`sampleChats`) to represent the chat data.  In a real app, this data would come from a database or API.

* **Dynamic UI**:

    * The AppBar title and actions change based on the selected screen.

### 4\. `ChatScreen`

* Displays the conversation history for a specific chat.

* **Message List**:

    * Uses a `ListView.builder` to display the list of messages.

    * Each message displays the sender's name, text, and timestamp.

    * Messages are aligned to the left for other users and to the right for the current user.

* **Message Input Area**:

    * A `TextField` allows the user to type a message.

    * A send button sends the message, adds it to the list, and updates the UI.

* **Data Handling**:

    * Uses a list of `Message` objects (`sampleMessages`) to represent the message data for a single chat.

* **Navigation**:

    * The screen receives the chat name and avatar URL from the `ChatsScreen` when the user taps on a chat.

### 5\.  Data Models

* **`Chat`**:

    * Represents a single chat in the chat list.

    * Contains information like sender name, avatar URL, last message, timestamp, unread count, and flags for archived, locked, and group status.

* **`Message`**:

    * Represents a single message within a chat conversation.

    * Contains information like sender name, text, timestamp and a flag to indicate if the message is from the current user.

## How the App Works (User Flow)

1.  The user opens the app, and `main.dart` launches the `WhatsAppHomeScreen`.

2.  The `WhatsAppHomeScreen` displays the bottom navigation bar.

3.  The user sees the list of chats in the `ChatsScreen` by default.

4.  The user can tap on a chat item in the `ChatsScreen` to open the `ChatScreen` for that conversation.

5.  In the `ChatScreen`, the user can see the message history and send new messages.

6.  The user can use the bottom navigation bar to switch to other sections of the app (Status, Community, Calls).

## Further Development

This is a basic implementation of a chat application. Here are some ideas for further development:

* Implement the Status, Community, and Calls screens.

* Connect the app to a backend server to store and retrieve chat data.

* Implement real-time messaging using WebSockets or a similar technology.

* Add more features like sending media messages, voice calls, and video calls.

* Implement user authentication.

* Improve the UI and add more styling.

* Implement message delivery receipts (ticks).

* Implement typing indicators.
