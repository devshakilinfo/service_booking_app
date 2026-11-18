import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../models/service_model.dart';
import '../../../providers/service_provider.dart';
import '../admin_edit_service_screen.dart';
import 'admin_metric_card.dart';

class AdminServiceTile extends StatelessWidget {
  final ServiceModel service;

  const AdminServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: adminWhiteCardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              service.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: AppColors.primaryUltraLight,
                child: const Icon(Icons.home_repair_service_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  service.category,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${service.price.toStringAsFixed(0)} • ${service.duration}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminEditServiceScreen(service: service),
                        ),
                      );
                    },
                    tooltip: 'Edit Service',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.statusCancelled),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Service'),
                          content: Text('Are you sure you want to delete "${service.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusCancelled),
                              child: const Text('Delete', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        final success = await Provider.of<ServiceProvider>(context, listen: false).deleteService(service.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? 'Service "${service.name}" deleted' : 'Failed to delete service'),
                            backgroundColor: success ? AppColors.primary : AppColors.error,
                          ),
                        );
                      }
                    },
                    tooltip: 'Delete Service',
                  ),
                ],
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: service.isActive,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) async {
                    await Provider.of<ServiceProvider>(context, listen: false).updateService(
                      service.id,
                      {'isActive': val},
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
