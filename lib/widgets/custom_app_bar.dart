import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  search,
  profile,
  back,
  transparent,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final VoidCallback? onSearchTap;
  final String? searchHint;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.onSearchTap,
    this.searchHint,
    this.searchController,
    this.onSearchChanged,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ??
          (variant == CustomAppBarVariant.transparent
              ? Colors.transparent
              : colorScheme.surface),
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: variant == CustomAppBarVariant.transparent ? 0 : elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: foregroundColor ?? colorScheme.onSurface,
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.search:
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outline),
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: searchHint ?? 'Search jobs...',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
        );
      case CustomAppBarVariant.profile:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor ?? colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
            ],
            GestureDetector(
              onTap: onProfileTap ??
                  () => Navigator.pushNamed(context, '/student-job-feed'),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: colorScheme.onPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        );
      default:
        return title != null ? Text(title!) : null;
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (variant == CustomAppBarVariant.back) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<Widget> defaultActions = [];

    switch (variant) {
      case CustomAppBarVariant.standard:
        defaultActions = [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchTap ??
                () => Navigator.pushNamed(context, '/student-job-feed'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/messages-screen'),
          ),
        ];
        break;
      case CustomAppBarVariant.search:
        defaultActions = [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality
            },
          ),
        ];
        break;
      case CustomAppBarVariant.profile:
        defaultActions = [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Settings functionality
            },
          ),
        ];
        break;
      case CustomAppBarVariant.back:
        defaultActions = [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
          ),
        ];
        break;
      case CustomAppBarVariant.transparent:
        defaultActions = [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ];
        break;
    }

    return actions ?? defaultActions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
