import 'package:flutter/material.dart';
import 'package:radhika/core/theme/app_tokens.dart';
import 'package:radhika/widgets/core/app_card.dart';

/// A unified loading overlay that replaces the various loading patterns.
/// Provides consistent styling, messaging, and accessibility.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.progress,
    this.color,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final double? progress; // 0.0 to 1.0 for determinate progress
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final overlayColor = color ?? Colors.black26;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Semantics(
              label: message ?? 'Loading',
              liveRegion: true,
              child: Container(
                color: overlayColor,
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(AppTokens.spaceLg),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTokens.space3xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          progress != null
                              ? SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 4,
                                  ),
                                )
                              : const CircularProgressIndicator(),
                          if (message != null) ...[
                            const SizedBox(height: AppTokens.spaceLg),
                            Text(
                              message!,
                              style: AppTypography.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A unified empty state widget.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionTooltip,
    this.padding = const EdgeInsets.all(AppTokens.space3xl),
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final String? actionTooltip;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = context.theme;

    return Semantics(
      label: '$title. ${subtitle ?? ""}',
      child: Center(
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppTokens.avatarXl,
                color: colors.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppTokens.spaceLg),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppTokens.spaceMd),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppTokens.spaceXl),
                actionTooltip != null
                    ? Tooltip(message: actionTooltip!, child: action!)
                    : action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A unified error state widget.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon = Icons.error_outline,
    this.padding = const EdgeInsets.all(AppTokens.space3xl),
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = context.theme;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: colors.error,
            ),
            const SizedBox(height: AppTokens.spaceLg),
            Text(
              'Unable to load',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTokens.spaceXl),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A skeleton loading placeholder for content that loads asynchronously.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppTokens.radiusMd,
    this.color,
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final skeletonColor = color ?? colors.surfaceContainerHighest.withValues(alpha: 0.5);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A skeleton loader for list items.
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 72,
    this.showAvatar = true,
    this.showSubtitle = true,
  });

  final int itemCount;
  final double itemHeight;
  final bool showAvatar;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.screenPadding,
            vertical: AppTokens.spaceXs,
          ),
          child: AppCard(
            padding: const EdgeInsets.all(AppTokens.cardPadding),
            elevation: AppTokens.elevationNone,
            child: Row(
              children: [
                if (showAvatar) ...[
                  const AppSkeleton(
                    width: AppTokens.avatarMd,
                    height: AppTokens.avatarMd,
                    borderRadius: AppTokens.radiusFull,
                  ),
                  const SizedBox(width: AppTokens.spaceMd),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppSkeleton(
                        width: double.infinity,
                        height: 16,
                        borderRadius: AppTokens.radiusSm,
                      ),
                      if (showSubtitle) ...[
                        const SizedBox(height: AppTokens.spaceXs),
                        const AppSkeleton(
                          width: 120,
                          height: 12,
                          borderRadius: AppTokens.radiusSm,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A shimmer effect for skeleton loading (optional enhancement).
class AppShimmer extends StatefulWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = widget.baseColor ?? colors.surfaceContainerHighest.withValues(alpha: 0.5);
    final highlight = widget.highlightColor ?? colors.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, highlight, base],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}