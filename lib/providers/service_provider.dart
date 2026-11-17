import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../models/service_model.dart';

class ServiceProvider with ChangeNotifier {
  List<ServiceModel> _services = [];
  List<ServiceModel> _popularServices = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';

  List<ServiceModel> get services => _services;
  List<ServiceModel> get popularServices => _popularServices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    fetchServices(category: category);
  }

  // Fetch all services with optional filters
  Future<void> fetchServices({String? category, String? search}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'All') {
        queryParams['category'] = category;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await ApiService.get('/services', queryParams: queryParams);

      if (response['success'] == true) {
        final List<dynamic> list = response['data'];
        _services = list.map((item) => ServiceModel.fromJson(item)).toList();
        _popularServices = _services.where((s) => s.isPopular || s.isFeatured).toList();
      } else {
        _errorMessage = response['message'] ?? 'Failed to load services';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch slot availability for specific service & date
  Future<List<Map<String, dynamic>>> fetchAvailability(String serviceId, String date) async {
    try {
      final response = await ApiService.get(
        '/services/$serviceId/availability',
        queryParams: {'date': date},
      );

      if (response['success'] == true && response['slots'] != null) {
        final List<dynamic> slots = response['slots'];
        return slots
            .map((s) => {
                  'time': s['time'].toString(),
                  'isAvailable': s['isAvailable'] == true,
                })
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching slot availability: $e');
      return [];
    }
  }
}
