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

  Future<bool> createService({
    required String name,
    required String description,
    required String category,
    required double price,
    String duration = '1.5 hrs',
    required String image,
    bool isFeatured = false,
    bool isPopular = false,
    List<String>? highlights,
    List<String>? availableSlots,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        '/services',
        requireAuth: true,
        body: {
          'name': name,
          'description': description,
          'category': category,
          'price': price,
          'duration': duration,
          'image': image,
          'isFeatured': isFeatured,
          'isPopular': isPopular,
          if (highlights != null) 'highlights': highlights,
          if (availableSlots != null) 'availableSlots': availableSlots,
        },
      );

      if (response['success'] == true) {
        await fetchServices();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to create service';
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

  Future<bool> updateService(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.put(
        '/services/$id',
        requireAuth: true,
        body: data,
      );

      if (response['success'] == true) {
        await fetchServices();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update service';
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

  Future<bool> deleteService(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.delete(
        '/services/$id',
        requireAuth: true,
      );

      if (response['success'] == true) {
        await fetchServices();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to delete service';
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
