// ==================== ENUMS ====================

enum TodoPriority {
  low('low'),
  medium('medium'),
  high('high');

  final String value;
  const TodoPriority(this.value);

  static TodoPriority? fromString(String? value) {
    if (value == null) return null;
    try {
      return TodoPriority.values.firstWhere(
            (e) => e.value == value.toLowerCase(),
      );
    } catch (e) {
      return null; // hoặc TodoPriority.medium làm default
    }
  }
}

enum TodoSortBy {
  createdAt('createdAt'),
  updatedAt('updatedAt'),
  title('title'),
  priority('priority'),
  dueDate('dueDate');

  final String value;
  const TodoSortBy(this.value);
}

enum SortOrder {
  asc('asc'),
  desc('desc');

  final String value;
  const SortOrder(this.value);
}