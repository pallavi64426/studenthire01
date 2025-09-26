import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsHeaderWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userType;
  final String? profileImageUrl;

  const SettingsHeaderWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userType,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: profileImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: profileImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.person,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 32,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.person,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 32,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.white.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.person,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 32,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userType,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit Profile Button
          IconButton(
            onPressed: () {
              // Navigate to profile edit screen
            },
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.white.withValues(alpha: 0.9),
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
