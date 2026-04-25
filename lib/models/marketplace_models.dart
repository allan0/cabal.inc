// lib/models/marketplace_models.dart

class ProjectListing {
  final String id;
  final String projectName;
  final String projectDescription;
  final String creatorName;
  final String creatorAvatarUrl;
  final String budget;
  final String timeline;
  final List<String> requiredSkills;
  final bool isFullProject;
  final bool isOpen;

  ProjectListing({
    required this.id,
    required this.projectName,
    required this.projectDescription,
    required this.creatorName,
    required this.creatorAvatarUrl,
    required this.budget,
    required this.timeline,
    required this.requiredSkills,
    this.isFullProject = false,
    this.isOpen = true,
  });

  factory ProjectListing.fromSupabase(Map<String, dynamic> data) {
    final creatorProfile = data['creator_profile'] as Map<String, dynamic>? ?? {};
    final creatorName = creatorProfile['display_name'] as String? ?? 'Anonymous';
    final creatorAvatarUrl = creatorProfile['profile_image_url'] as String? ?? 'https://i.pravatar.cc/150?u=anonymous';

    return ProjectListing(
      id: data['id'] as String,
      projectName: data['project_name'] as String? ?? 'Untitled Project',
      projectDescription: data['project_description'] as String? ?? 'No description provided.',
      creatorName: creatorName,
      creatorAvatarUrl: creatorAvatarUrl,
      budget: data['budget'] as String? ?? 'Not specified',
      timeline: data['timeline'] as String? ?? 'Not specified',
      requiredSkills: data['required_skills'] != null
          ? List<String>.from(data['required_skills'])
          : [],
      isFullProject: (data['is_full_project'] ?? false) as bool,
      isOpen: (data['is_open'] ?? true) as bool,
    );
  }
}

class DeveloperProfile {
  final String id;
  final String userId; // <-- ADDED THIS FIELD
  final String developerName;
  final String developerAvatarUrl;
  final String tagline;
  final String rate;
  final List<String> skills;
  final bool isAvailable;

  DeveloperProfile({
    required this.id,
    required this.userId, // <-- ADDED THIS FIELD
    required this.developerName,
    required this.developerAvatarUrl,
    required this.tagline,
    required this.rate,
    required this.skills,
    this.isAvailable = true,
  });

  factory DeveloperProfile.fromSupabase(Map<String, dynamic> data) {
    final userProfile = data['creator_profile'] as Map<String, dynamic>? ?? {};
    final developerName = userProfile['display_name'] as String? ?? 'Anonymous Developer';
    final developerAvatarUrl = userProfile['profile_image_url'] as String? ?? 'https://i.pravatar.cc/150?u=${data['id']}';
    
    return DeveloperProfile(
      id: data['id'] as String,
      userId: data['user_id'] as String? ?? '', // <-- ADDED THIS FIELD
      developerName: developerName,
      developerAvatarUrl: developerAvatarUrl,
      tagline: data['tagline'] as String? ?? 'Expert available for hire.',
      rate: data['rate'] as String? ?? 'Not specified',
      skills: data['skills'] != null
          ? List<String>.from(data['skills'])
          : [],
      isAvailable: (data['is_available'] ?? true) as bool,
    );
  }
}
