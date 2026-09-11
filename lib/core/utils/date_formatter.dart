/// Lightweight, dependency-free date and time formatting utilities.
abstract final class DateFormatter {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Formats a [DateTime] into a friendly relative or formatted string.
  /// Example: "Today, 10:30 AM", "Yesterday, 3:15 PM", or "Oct 12, 2026"
  static String format(DateTime date) {
    final localDate = date.toLocal();
    final now = DateTime.now();

    final isToday = localDate.year == now.year &&
        localDate.month == now.month &&
        localDate.day == now.day;

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = localDate.year == yesterday.year &&
        localDate.month == yesterday.month &&
        localDate.day == yesterday.day;

    final hour = localDate.hour == 0
        ? 12
        : (localDate.hour > 12 ? localDate.hour - 12 : localDate.hour);
    final minute = localDate.minute.toString().padLeft(2, '0');
    final period = localDate.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $period';

    if (isToday) {
      return 'Today, $timeStr';
    } else if (isYesterday) {
      return 'Yesterday, $timeStr';
    } else {
      final month = _months[localDate.month - 1];
      return '$month ${localDate.day}, ${localDate.year}';
    }
  }
}
