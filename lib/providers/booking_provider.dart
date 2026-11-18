import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../models/booking_model.dart';

class BookingProvider with ChangeNotifier {
  List<BookingModel> _upcomingBookings = [];
  List<BookingModel> _pastBookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  BookingModel? _lastCreatedBooking;

  List<BookingModel> get upcomingBookings => _upcomingBookings;
  List<BookingModel> get pastBookings => _pastBookings;
  List<BookingModel> get bookings => [..._upcomingBookings, ..._pastBookings];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  BookingModel? get lastCreatedBooking => _lastCreatedBooking;

  // Create appointment booking
  Future<bool> createBooking({
    required String serviceId,
    required String date,
    required String timeSlot,
    String notes = '',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        '/bookings',
        requireAuth: true,
        body: {
          'serviceId': serviceId,
          'date': date,
          'timeSlot': timeSlot,
          'notes': notes,
        },
      );

      if (response['success'] == true) {
        _lastCreatedBooking = BookingModel.fromJson(response['data']);
        await fetchMyBookings();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to create booking';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch bookings for current user
  Future<void> fetchMyBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final upcomingRes = await ApiService.get('/bookings/my?type=upcoming', requireAuth: true);
      final pastRes = await ApiService.get('/bookings/my?type=past', requireAuth: true);

      if (upcomingRes['success'] == true) {
        final List<dynamic> list = upcomingRes['data'];
        _upcomingBookings = list.map((item) => BookingModel.fromJson(item)).toList();
      }

      if (pastRes['success'] == true) {
        final List<dynamic> list = pastRes['data'];
        _pastBookings = list.map((item) => BookingModel.fromJson(item)).toList();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId, {String reason = ''}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.put(
        '/bookings/$bookingId/cancel',
        requireAuth: true,
        body: {'cancellationReason': reason},
      );

      if (response['success'] == true) {
        await fetchMyBookings();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to cancel booking';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
