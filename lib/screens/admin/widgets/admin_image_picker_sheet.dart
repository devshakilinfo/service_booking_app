import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class AdminImagePickerSheet extends StatefulWidget {
  final String currentUrl;

  const AdminImagePickerSheet({super.key, required this.currentUrl});

  static Future<String?> show(BuildContext context, {required String currentUrl}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => AdminImagePickerSheet(currentUrl: currentUrl),
    );
  }

  @override
  State<AdminImagePickerSheet> createState() => _AdminImagePickerSheetState();
}

class _AdminImagePickerSheetState extends State<AdminImagePickerSheet> {
  late final TextEditingController _urlCtrl;

  static const List<Map<String, String>> _sampleCovers = [
    {
      'title': 'Deep Cleaning',
      'url': 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
    },
    {
      'title': 'AC Diagnostics',
      'url': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800',
    },
    {
      'title': 'Plumbing Faucet',
      'url': 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=800',
    },
    {
      'title': 'Beauty & Salon',
      'url': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800',
    },
    {
      'title': 'Home Healthcare',
      'url': 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800',
    },
    {
      'title': 'Smart Electrical',
      'url': 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
    },
    {
      'title': 'Wall Painting',
      'url': 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=800',
    },
    {
      'title': 'Sofa Cleaning',
      'url': 'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=800',
    },
  ];

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(text: widget.currentUrl);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Service Cover Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Enter Custom Image URL:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _urlCtrl,
            decoration: InputDecoration(
              hintText: 'https://images.unsplash.com/...',
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.textLight),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Or Choose from Ready Presets:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _sampleCovers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (ctx, i) {
                final item = _sampleCovers[i];
                return GestureDetector(
                  onTap: () => Navigator.pop(context, item['url']),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item['url']!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.primaryUltraLight,
                            child: const Icon(Icons.image_outlined, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title']!,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                final trimmed = _urlCtrl.text.trim();
                Navigator.pop(context, trimmed.isNotEmpty ? trimmed : widget.currentUrl);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Apply Image URL',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
