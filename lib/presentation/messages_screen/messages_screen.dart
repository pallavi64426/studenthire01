import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/chat_message_widget.dart';
import './widgets/conversation_item_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/quick_reply_widget.dart';
import './widgets/search_bar_widget.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _conversationsScrollController = ScrollController();
  final ScrollController _chatScrollController = ScrollController();

  String _searchQuery = '';
  bool _isSearching = false;
  Map<String, dynamic>? _selectedConversation;
  List<Map<String, dynamic>> _messages = [];
  bool _isRefreshing = false;

  // Mock data for conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      "id": 1,
      "name": "Sarah Chen",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage":
          "Thanks for considering my application! I'm really excited about this opportunity.",
      "timestamp": "2 min ago",
      "isUnread": true,
      "unreadCount": 2,
      "isOnline": true,
      "isTyping": false,
      "jobTitle": "Campus Event Assistant",
      "jobStatus": "active",
    },
    {
      "id": 2,
      "name": "TechStart Inc.",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage":
          "We'd like to schedule an interview for next week. Are you available?",
      "timestamp": "15 min ago",
      "isUnread": true,
      "unreadCount": 1,
      "isOnline": false,
      "isTyping": false,
      "jobTitle": "Frontend Developer Intern",
      "jobStatus": "active",
    },
    {
      "id": 3,
      "name": "Mike Rodriguez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage": "Great job on the project! Payment has been processed.",
      "timestamp": "1 hour ago",
      "isUnread": false,
      "unreadCount": 0,
      "isOnline": true,
      "isTyping": false,
      "jobTitle": "Social Media Content Creator",
      "jobStatus": "completed",
    },
    {
      "id": 4,
      "name": "Local Coffee Shop",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage":
          "Unfortunately, we had to cancel the weekend shift due to low customer volume.",
      "timestamp": "3 hours ago",
      "isUnread": false,
      "unreadCount": 0,
      "isOnline": false,
      "isTyping": false,
      "jobTitle": "Weekend Barista",
      "jobStatus": "cancelled",
    },
    {
      "id": 5,
      "name": "Emma Thompson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastMessage":
          "Can you send me your portfolio? I'd love to see your previous work.",
      "timestamp": "Yesterday",
      "isUnread": false,
      "unreadCount": 0,
      "isOnline": false,
      "isTyping": false,
      "jobTitle": "Graphic Design Assistant",
      "jobStatus": "active",
    },
  ];

  // Mock data for chat messages
  final List<Map<String, dynamic>> _allMessages = [
    {
      "id": 1,
      "conversationId": 1,
      "content":
          "Hi Sarah! Thanks for applying to our Campus Event Assistant position.",
      "timestamp": "10:30 AM",
      "dateGroup": "Today",
      "isCurrentUser": false,
      "type": "text",
      "senderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": 2,
      "conversationId": 1,
      "content":
          "Thanks for considering my application! I'm really excited about this opportunity.",
      "timestamp": "10:32 AM",
      "dateGroup": "Today",
      "isCurrentUser": true,
      "type": "text",
      "senderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": 3,
      "conversationId": 1,
      "type": "job_context",
      "timestamp": "10:33 AM",
      "dateGroup": "Today",
      "isCurrentUser": false,
      "senderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "jobData": {
        "title": "Campus Event Assistant",
        "company": "University Events Team",
        "status": "Application Under Review",
        "salary": "\$15/hour",
      },
      "isDelivered": true,
      "isRead": true,
    },
    {
      "id": 4,
      "conversationId": 1,
      "content":
          "I have experience organizing events from my previous role at the student union.",
      "timestamp": "10:35 AM",
      "dateGroup": "Today",
      "isCurrentUser": true,
      "type": "text",
      "senderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isDelivered": true,
      "isRead": false,
    },
  ];

  // Quick reply suggestions
  final List<String> _quickReplies = [
    "Thanks for your interest!",
    "I'm available for an interview",
    "Can we schedule a call?",
    "I'll send my portfolio",
    "When can we start?",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _conversationsScrollController.addListener(_onConversationsScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _conversationsScrollController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _onConversationsScroll() {
    if (_conversationsScrollController.position.pixels == 0) {
      _refreshConversations();
    }
  }

  Future<void> _refreshConversations() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    HapticFeedback.lightImpact();
  }

  List<Map<String, dynamic>> get _filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;

    return _conversations.where((conversation) {
      final name = (conversation['name'] as String).toLowerCase();
      final jobTitle = (conversation['jobTitle'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return name.contains(query) || jobTitle.contains(query);
    }).toList();
  }

  void _openConversation(Map<String, dynamic> conversation) {
    setState(() {
      _selectedConversation = conversation;
      _messages = _allMessages
          .where((message) => message['conversationId'] == conversation['id'])
          .toList();
    });

    // Mark as read
    final index =
        _conversations.indexWhere((c) => c['id'] == conversation['id']);
    if (index != -1) {
      setState(() {
        _conversations[index]['isUnread'] = false;
        _conversations[index]['unreadCount'] = 0;
      });
    }

    // Scroll to bottom of chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _closeConversation() {
    setState(() {
      _selectedConversation = null;
      _messages.clear();
    });
  }

  void _archiveConversation(Map<String, dynamic> conversation) {
    setState(() {
      _conversations.removeWhere((c) => c['id'] == conversation['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation with ${conversation['name']} archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _conversations.add(conversation);
            });
          },
        ),
      ),
    );
  }

  void _deleteConversation(Map<String, dynamic> conversation) {
    setState(() {
      _conversations.removeWhere((c) => c['id'] == conversation['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation with ${conversation['name']} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _conversations.add(conversation);
            });
          },
        ),
      ),
    );
  }

  void _sendMessage(String content) {
    if (_selectedConversation == null) return;

    final newMessage = {
      "id": _messages.length + 1,
      "conversationId": _selectedConversation!['id'],
      "content": content,
      "timestamp": "Now",
      "dateGroup": "Today",
      "isCurrentUser": true,
      "type": "text",
      "senderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isDelivered": true,
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    // Update conversation last message
    final conversationIndex = _conversations.indexWhere(
      (c) => c['id'] == _selectedConversation!['id'],
    );
    if (conversationIndex != -1) {
      setState(() {
        _conversations[conversationIndex]['lastMessage'] = content;
        _conversations[conversationIndex]['timestamp'] = 'Now';
      });
    }

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendImage(XFile image) {
    if (_selectedConversation == null) return;

    final newMessage = {
      "id": _messages.length + 1,
      "conversationId": _selectedConversation!['id'],
      "type": "image",
      "imageUrl": "https://picsum.photos/400/300",
      "timestamp": "Now",
      "dateGroup": "Today",
      "isCurrentUser": true,
      "senderAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "isDelivered": true,
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    // Update conversation last message
    final conversationIndex = _conversations.indexWhere(
      (c) => c['id'] == _selectedConversation!['id'],
    );
    if (conversationIndex != -1) {
      setState(() {
        _conversations[conversationIndex]['lastMessage'] = 'Photo';
        _conversations[conversationIndex]['timestamp'] = 'Now';
      });
    }
  }

  void _scheduleInterview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Interview scheduling feature coming soon!'),
      ),
    );
  }

  void _showImageFullScreen(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: 90.w,
                height: 60.h,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_selectedConversation != null) {
      return _buildChatView(context);
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Messages',
        variant: CustomAppBarVariant.standard,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                }
              });
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            SearchBarWidget(
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              onClear: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
          CustomTabBar(
            tabs: const ['All Messages', 'Unread'],
            variant: CustomTabBarVariant.underline,
            onTap: (index) {
              // Filter conversations based on tab
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshConversations,
              color: colorScheme.primary,
              child: _filteredConversations.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      controller: _conversationsScrollController,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      itemCount: _filteredConversations.length,
                      itemBuilder: (context, index) {
                        final conversation = _filteredConversations[index];
                        return ConversationItemWidget(
                          conversation: conversation,
                          onTap: () => _openConversation(conversation),
                          onArchive: () => _archiveConversation(conversation),
                          onDelete: () => _deleteConversation(conversation),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: _selectedConversation!['name'] as String,
        variant: CustomAppBarVariant.back,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: colorScheme.onSurface,
            size: 24,
          ),
          onPressed: _closeConversation,
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'videocam',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Video call functionality
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'call',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Voice call functionality
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              _showChatOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _chatScrollController,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showTimestamp = index == 0 ||
                    _messages[index - 1]['dateGroup'] != message['dateGroup'];

                return ChatMessageWidget(
                  message: message,
                  isCurrentUser: message['isCurrentUser'] as bool,
                  showTimestamp: showTimestamp,
                  onImageTap: message['type'] == 'image'
                      ? () =>
                          _showImageFullScreen(message['imageUrl'] as String)
                      : null,
                );
              },
            ),
          ),
          QuickReplyWidget(
            suggestions: _quickReplies,
            onReplySelected: _sendMessage,
          ),
          MessageInputWidget(
            onSendMessage: _sendMessage,
            onSendImage: _sendImage,
            onScheduleInterview: _scheduleInterview,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'chat_bubble_outline',
            color: colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'No conversations found'
                : 'No messages yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Start applying to jobs to connect with employers',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/student-job-feed');
              },
              child: const Text('Browse Jobs'),
            ),
          ],
        ],
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildChatOption(
              context,
              icon: 'report',
              label: 'Report User',
              color: colorScheme.error,
              onTap: () {
                Navigator.pop(context);
                // Report functionality
              },
            ),
            _buildChatOption(
              context,
              icon: 'block',
              label: 'Block User',
              color: colorScheme.error,
              onTap: () {
                Navigator.pop(context);
                // Block functionality
              },
            ),
            _buildChatOption(
              context,
              icon: 'delete',
              label: 'Delete Conversation',
              color: colorScheme.error,
              onTap: () {
                Navigator.pop(context);
                _deleteConversation(_selectedConversation!);
                _closeConversation();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildChatOption(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: color,
        size: 24,
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}
