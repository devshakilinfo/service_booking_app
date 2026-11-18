class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String duration;
  final String image;
  final double rating;
  final int reviewsCount;
  final bool isFeatured;
  final bool isPopular;
  final bool isActive;
  final List<String> highlights;
  final List<String> availableSlots;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.duration,
    required this.image,
    this.rating = 4.8,
    this.reviewsCount = 100,
    this.isFeatured = false,
    this.isPopular = false,
    this.isActive = true,
    this.highlights = const [],
    this.availableSlots = const [],
  });

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    String? duration,
    String? image,
    double? rating,
    int? reviewsCount,
    bool? isFeatured,
    bool? isPopular,
    bool? isActive,
    List<String>? highlights,
    List<String>? availableSlots,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isPopular: isPopular ?? this.isPopular,
      isActive: isActive ?? this.isActive,
      highlights: highlights ?? this.highlights,
      availableSlots: availableSlots ?? this.availableSlots,
    );
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : 0.0,
      duration: json['duration'] ?? '1 hr',
      image: json['image'] ?? 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 4.8,
      reviewsCount: json['reviewsCount'] ?? json['reviews_count'] ?? 120,
      isFeatured: json['isFeatured'] ?? json['is_featured'] ?? false,
      isPopular: json['isPopular'] ?? json['is_popular'] ?? false,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      availableSlots: (json['availableSlots'] ?? json['available_slots'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [
            '09:00 AM',
            '10:00 AM',
            '11:00 AM',
            '02:00 PM',
            '03:00 PM',
            '04:00 PM',
          ],
    );
  }
}
