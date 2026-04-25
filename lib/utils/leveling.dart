// lib/utils/leveling.dart

// Calculates the level based on total XP.
int calculateLevel(int totalXp) {
  if (totalXp < 100) return 1;
  if (totalXp < 300) return 2;
  if (totalXp < 600) return 3;
  if (totalXp < 1000) return 4;
  if (totalXp < 1500) return 5;
  // Add more levels as needed
  return 6;
}

// Calculates the XP required for a given level.
int xpForLevel(int level) {
  switch (level) {
    case 1: return 0;
    case 2: return 100;
    case 3: return 300;
    case 4: return 600;
    case 5: return 1000;
    case 6: return 1500;
    default: return 999999999; // A large number for "max level"
  }
}
