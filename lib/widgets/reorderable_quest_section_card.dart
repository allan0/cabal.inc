// lib/widgets/reorderable_quest_section_card.dart
import 'package:cabal/models/quest_section_model.dart';
import 'package:flutter/material.dart';
import 'package:cabal/models/quest_model.dart'; // <-- CORRECTED IMPORT
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReorderableQuestSectionCard extends StatelessWidget {
  final QuestSection section;
  final int questCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddQuest;

  const ReorderableQuestSectionCard({
    Key? key,
    required this.section,
    required this.questCount,
    required this.onEdit,
    required this.onDelete,
    required this.onAddQuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            key: key, // Key for ReorderableListView
            title: Text(section.title, style: theme.textTheme.titleMedium),
            subtitle: Text(section.description ?? 'No description'),
            leading: ReorderableDragStartListener(
              index: section.order, // The index is crucial for reordering
              child: const Icon(Icons.drag_handle_rounded),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit Section')),
                const PopupMenuItem(value: 'delete', child: Text('Delete Section', style: TextStyle(color: Colors.red))),
              ],
            ),
          ),
          const Divider(height: 1),
          // Placeholder for listing quests within the section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$questCount Quests in this section'),
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                  label: const Text('Add Quest'),
                  onPressed: onAddQuest,
                  style: ElevatedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
