import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/task_entity.dart';
import '../common/confirmation_dialog.dart';
import 'task_status_badge.dart';

/// Elevated, interactive task card with individual self-contained entrance & exit
/// animations, swipe gestures, status accent strip, and smooth micro-interactions.
class TaskCard extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Future<bool?> Function(DismissDirection)? onConfirmDismiss;
  final void Function(DismissDirection)? onDismissed;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
    this.onConfirmDismiss,
    this.onDismissed,
  });

  /// Tracks tasks that have already been presented so they don't re-animate on rebuilds.
  static final Set<String> _seenTaskIds = {};

  /// Clears seen task IDs (useful in tests or fresh resets).
  static void clearSeen() => _seenTaskIds.clear();

  /// Removes a task from seen so it can smoothly animate back in on Undo.
  static void removeSeen(String id) => _seenTaskIds.remove(id);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    final isNew = !TaskCard._seenTaskIds.contains(widget.task.id);
    TaskCard._seenTaskIds.add(widget.task.id);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 340),
      value: isNew ? 0.0 : 1.0,
    );

    _sizeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.25, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    ));

    if (isNew) {
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleDeletePress() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: AppStrings.deleteDialogTitle,
      message: 'Are you sure you want to delete "${widget.task.title}"?',
    );

    if (!confirmed || !mounted) return;

    // Small delay so the modal dialog completes its pop transition,
    // allowing the user to clearly and smoothly see this card slide away and cards below glide up!
    await Future.delayed(const Duration(milliseconds: 140));
    if (!mounted) return;

    // Smoothly animate only this specific card out (collapsing height, sliding left, and fading out)
    // The cards below it will naturally and smoothly slide up into place!
    await _animController.reverse();

    TaskCard.removeSeen(widget.task.id);

    if (mounted) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    final statusColor =
        widget.task.isCompleted ? AppColors.success : AppColors.warning;

    final cardContent = Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppDimensions.borderRadiusLarge,
        border: Border.all(
          color: widget.task.isCompleted
              ? cardBorder.withValues(alpha: 0.6)
              : cardBorder,
          width: 1.2,
        ),
        boxShadow: isDark
            ? [
                const BoxShadow(
                  color: Color(0x22000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ]
            : AppDimensions.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: AppDimensions.borderRadiusLarge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vertical Left Status Accent Stripe (4.5px)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 4.5,
                color: statusColor,
              ),

              // Card Inner Content
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Circular Animated Status Toggle Checkbox
                          GestureDetector(
                            onTap: widget.onToggle,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, right: 12.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutBack,
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.task.isCompleted
                                      ? AppColors.success
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: widget.task.isCompleted
                                        ? AppColors.success
                                        : (isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.textMuted),
                                    width: 1.8,
                                  ),
                                ),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 180),
                                  scale: widget.task.isCompleted ? 1.0 : 0.0,
                                  curve: Curves.easeOutBack,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: AppColors.surface,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Center Content (Title, Description, Footer)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Animated Title with Strikethrough
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    color: widget.task.isCompleted
                                        ? textMuted
                                        : textPrimary,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.2,
                                    decoration: widget.task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: textMuted,
                                    decorationThickness: 1.8,
                                  ),
                                  child: Text(
                                    widget.task.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Optional Description
                                if (widget.task.description != null &&
                                    widget.task.description!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.task.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: widget.task.isCompleted
                                          ? textMuted.withValues(alpha: 0.8)
                                          : textSecondary,
                                      fontSize: 13.5,
                                      height: 1.4,
                                    ),
                                  ),
                                ],

                                const SizedBox(height: AppDimensions.spaceSM + 2),

                                // Footer: Status Badge & Creation Date
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: AppDimensions.spaceSM,
                                  runSpacing: 4,
                                  children: [
                                    TaskStatusBadge(isCompleted: widget.task.isCompleted),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 13,
                                          color: textMuted,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormatter.format(widget.task.createdAt),
                                          style: TextStyle(
                                            color: textMuted,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Delete Action Button (Solid red in both modes)
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.error,
                              size: AppDimensions.iconMD + 2,
                            ),
                            splashRadius: 20,
                            tooltip: 'Delete Task',
                            onPressed: _handleDeletePress,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final Widget innerCard;
    if (widget.onConfirmDismiss == null) {
      innerCard = cardContent;
    } else {
      innerCard = Dismissible(
        key: ValueKey(widget.task.id),
        confirmDismiss: widget.onConfirmDismiss,
        onDismissed: widget.onDismissed,
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.85),
            borderRadius: AppDimensions.borderRadiusLarge,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Toggle Status',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.85),
            borderRadius: AppDimensions.borderRadiusLarge,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 8),
              Icon(Icons.delete_outline_rounded, color: Colors.white),
            ],
          ),
        ),
        child: cardContent,
      );
    }

    // Individual size & slide transitions:
    // When this card exits, it smoothly collapses its height to 0.
    // The cards below it in the ListView naturally glide upward without rebuilding.
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.spaceSM + 2,
            ),
            child: innerCard,
          ),
        ),
      ),
    );
  }
}
