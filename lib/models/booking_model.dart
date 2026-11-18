import 'service_model.dart';
import 'user_model.dart';

class BookingModel {
  final String id;
  final ServiceModel? service;
  final UserModel? user;
  final String date;
  final String timeSlot;
  final String status;
  final double totalPrice;
  final String notes;
  final DateTime? createdAt;

  BookingModel({
    required this.id,
    this.service,
    this.user,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.totalPrice,
    this.notes = '',
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    ServiceModel? service;
    if (json['service'] is Map<String, dynamic>) {
      service = ServiceModel.fromJson(json['service']);
    }

    UserModel? user;
    if (json['user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(json['user']);
    }

    return BookingModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      service: service,
      user: user,
      date: json['date'] ?? '',
      timeSlot: json['timeSlot'] ?? json['time_slot'] ?? '',
      status: json['status'] ?? 'Pending',
      totalPrice: (json['totalPrice'] != null || json['total_price'] != null)
          ? ((json['totalPrice'] ?? json['total_price']) as num).toDouble()
          : 0.0,
      notes: json['notes'] ?? '',
      createdAt: json['createdAt'] != null || json['created_at'] != null
          ? DateTime.tryParse(json['createdAt'] ?? json['created_at'])
          : null,
    );
  }

  String get serviceName => service?.name ?? 'Deep Home Cleaning';
  String get time => timeSlot.isNotEmpty ? timeSlot : '11:30 AM';
  String get customerName => user?.name ?? 'Shakil Ahamed';
  String get customerPhone => user?.phone ?? '+880 1712-345678';
  String get address => user?.address ?? 'House 14, Road 7, Dhanmondi, Dhaka';
}
