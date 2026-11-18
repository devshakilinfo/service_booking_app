import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/service_provider.dart';
import 'widgets/admin_form_widgets.dart';
import 'widgets/admin_image_picker_sheet.dart';

class AdminAddServiceScreen extends StatefulWidget {
  const AdminAddServiceScreen({super.key});

  @override
  State<AdminAddServiceScreen> createState() => _AdminAddServiceScreenState();
}

class _AdminAddServiceScreenState extends State<AdminAddServiceScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController(text: '1.5 hrs');
  final _descController = TextEditingController();
  final _tagsController = TextEditingController(text: 'Popular, Eco-Friendly, Certified');

  String _selectedCategory = 'Cleaning';
  bool _isVisibleToCustomers = true;
  bool _isLoading = false;
  String _imageUrl = 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800';

  final List<String> _categories = [
    'Cleaning',
    'Repair',
    'Beauty',
    'Health',
    'Electric',
    'Painting',
  ];

  final Map<String, String> _categoryDefaultImages = {
    'Cleaning': 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
    'Repair': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800',
    'Beauty': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800',
    'Health': 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800',
    'Electric': 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
    'Painting': 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=800',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _descController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String? val) {
    if (val != null) {
      setState(() {
        _selectedCategory = val;
        if (_categoryDefaultImages.containsKey(val)) {
          _imageUrl = _categoryDefaultImages[val]!;
        }
      });
    }
  }

  Future<void> _showImagePickerDialog() async {
    final newUrl = await AdminImagePickerSheet.show(context, currentUrl: _imageUrl);
    if (newUrl != null && mounted) {
      setState(() => _imageUrl = newUrl);
    }
  }

  void _submitService() async {
    final title = _titleController.text.trim();
    final priceStr = _priceController.text.trim();

    if (title.isEmpty || priceStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in service title and price')),
      );
      return;
    }

    final price = double.tryParse(priceStr);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid numeric price')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final List<String> tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    final success = await serviceProvider.createService(
      name: title,
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : 'Professional ${_selectedCategory.toLowerCase()} service by background-checked certified specialists.',
      category: _selectedCategory,
      price: price,
      duration: _durationController.text.trim().isNotEmpty
          ? _durationController.text.trim()
          : '1.5 hrs',
      image: _imageUrl,
      isFeatured: tags.any((t) => t.toLowerCase().contains('feature')),
      isPopular: tags.any((t) => t.toLowerCase().contains('popular')),
      highlights: tags.isNotEmpty ? tags : ['Certified Staff', 'Quality Guaranteed', 'Eco-Friendly'],
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Service "$title" created in database successfully!'),
            ],
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(serviceProvider.errorMessage ?? 'Failed to create service'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Service',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _showImagePickerDialog,
                child: Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFEAF5E5),
                            child: const Icon(Icons.handyman_rounded, color: AppColors.primary, size: 40),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.65),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 14,
                          right: 14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.photo_camera_rounded, color: Colors.white, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Cover Photo Selected',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Change Photo',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAdminLabel('SERVICE TITLE *'),
                    buildAdminInputField(
                      controller: _titleController,
                      hint: 'e.g., Deep Kitchen & Appliance Cleaning',
                      icon: Icons.title_rounded,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAdminLabel('CATEGORY *'),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCategory,
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    items: _categories.map((cat) {
                                      return DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      );
                                    }).toList(),
                                    onChanged: _onCategoryChanged,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAdminLabel('BASE PRICE (\$) *'),
                              buildAdminInputField(
                                controller: _priceController,
                                hint: '35',
                                icon: Icons.attach_money_rounded,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    buildAdminLabel('ESTIMATED DURATION'),
                    buildAdminInputField(
                      controller: _durationController,
                      hint: 'e.g., 2 Hours',
                      icon: Icons.access_time_rounded,
                    ),
                    const SizedBox(height: 16),

                    buildAdminLabel('DESCRIPTION'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _descController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'Describe inclusions, equipment provided, and service steps...',
                          hintStyle: TextStyle(fontSize: 13, color: AppColors.textLight),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    buildAdminLabel('TAGS & HIGHLIGHTS (COMMA SEPARATED)'),
                    buildAdminInputField(
                      controller: _tagsController,
                      hint: 'Popular, Eco-Friendly, Certified Specialists',
                      icon: Icons.label_outline_rounded,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Make visible to customers',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Publish directly to app search catalog',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isVisibleToCustomers,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) => setState(() => _isVisibleToCustomers = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Publish Service to Catalog',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
