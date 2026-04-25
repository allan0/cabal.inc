// lib/models/quest_section_model.dart

// No Supabase import needed if not using Supabase types directly.
// No other specific imports are needed for this simple model.

class QuestSection {
  final String id; // UUID, Primary Key, final
  // final String cabalId; // FK, Not typically needed in the model if fetched in context of a cabal
  String title;
  String? description; // Nullable, as DB allows NULL for this field
  int order;           // Maps to "order" (or "display_order") column in DB
  String? progressTextFormat; // e.g., "{completed}/{total} Done" - Nullable
  final DateTime? createdAt;    // Timestamp from DB, final after creation
  DateTime? updatedAt;      // Timestamp from DB

  QuestSection({
    required this.id,
    // required this.cabalId, // If you decide to include it
    required this.title,
    this.description,
    required this.order,
    this.progressTextFormat,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestSection.fromSupabase(Map<String, dynamic> data) {
    return QuestSection(
      id: data['id'] as String, // Should always exist (PK)
      // cabalId: data['cabal_id'] as String, // If you include it
      title: data['title'] as String? ?? 'Untitled Section', // Fallback for null title
      description: data['description'] as String?, // Already nullable
      // Handle potential quoted "order" key if SQL uses it, otherwise default to 0
      order: (data['order'] ?? data['"order"'] ?? 0) as int,
      progressTextFormat: data['progress_text_format'] as String?, // Already nullable
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String) // Use tryParse for safety
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'] as String) // Use tryParse for safety
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    // This map is for creating/updating a quest section definition.
    // 'id', 'cabal_id', 'created_at', 'updated_at' are typically handled by DB/service layer.
    return {
      'title': title,
      'description': description, // Can be null
      // Use quoted "order" for JSON key if your DB expects it for columns named 'order'
      // Ensure this matches how your Supabase RPC or direct update expects it.
      // If it's just 'order', then use 'order': order.
      '"order"': order,
      'progress_text_format': progressTextFormat, // Can be null
      // 'cabal_id' would be required for inserts, typically added by the service layer.
    };
  }
}
