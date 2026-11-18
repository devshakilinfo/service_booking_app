import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String displayName;
  final String displayEmail;
  final String displayPhone;
  final String initials;
  final int bookingsCount;
  final int favoritesCount;
  final double totalSpent;

  const ProfileHeaderCard({
    super.key,
    required this.displayName,
    required this.displayEmail,
    required this.displayPhone,
    required this.initials,
    required this.bookingsCount,
    required this.favoritesCount,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E4620),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E4620).withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7BC64D),
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF142E18),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6BB33B),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            '✓ Verified',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF142E18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      displayEmail,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBCD4BA),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayPhone,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9AB898),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(
            height: 1,
            color: Colors.white.withValues(alpha: 0.14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCol('$bookingsCount', 'Bookings', Colors.white),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.14),
              ),
              Expanded(
                child: _buildStatCol('$favoritesCount', 'Favorites', Colors.white),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.14),
              ),
              Expanded(
                child: _buildStatCol(
                  '\$${totalSpent.toStringAsFixed(0)}',
                  'Total Spent',
                  const Color(0xFFA3E66A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: valueColor,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFBCD4BA),
          ),
        ),
      ],
    );
  }
}
