import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// Duy kiểm tra kỹ đường dẫn này, nếu vẫn đỏ hãy nhấn Ctrl + . để VS Code tự sửa nhé
import 'package:expense_tracker_app/shared/providers/transaction_provider.dart'; 

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Định dạng tiền tệ VND chuẩn
    final currency = NumberFormat.currency(
      locale: 'vi_VN', 
      symbol: '₫', 
      decimalDigits: 0
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B1416), // Nền tối theo demo
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          // Lấy dữ liệu từ Provider
          final totalIncome = provider.totalIncome;
          final totalExpense = provider.totalExpense;
          final totalBalance = provider.totalBalance;

          return RefreshIndicator(
            onRefresh: () async {
              // Thêm logic kéo để làm mới nếu cần (ví dụ gọi lại Firebase)
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // --- THẺ CARD CHÍNH (SỐ DƯ) ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF005E66), Color(0xFF258D99)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF005E66).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Số dư hiện tại", 
                        style: TextStyle(color: Colors.white70, fontSize: 14)
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currency.format(totalBalance),
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 34, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          _StatPill(
                            icon: Icons.arrow_downward_rounded, 
                            label: "Thu nhập", 
                            value: currency.format(totalIncome),
                            iconColor: Colors.greenAccent,
                          ),
                          const SizedBox(width: 12),
                          _StatPill(
                            icon: Icons.arrow_upward_rounded, 
                            label: "Chi tiêu", 
                            value: currency.format(totalExpense),
                            iconColor: Colors.orangeAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),
                const Text(
                  "Tổng quan tháng này", 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5
                  )
                ),
                const SizedBox(height: 16),

                // --- CÁC HÀNG CHI TIẾT ---
                _buildInfoRow("Tổng thu", currency.format(totalIncome), Icons.add_chart_rounded, Colors.blueAccent),
                _buildInfoRow("Tổng chi", currency.format(totalExpense), Icons.pie_chart_outline_rounded, Colors.orange),
                _buildInfoRow("Tiết kiệm", currency.format(totalBalance), Icons.account_balance_wallet_rounded, Colors.tealAccent),
                
                const SizedBox(height: 20),
                // Có thể thêm biểu đồ ở đây trong tương lai
              ],
            ),
          );
        },
      ),
    );
  }

  // Hàm helper xây dựng hàng thông tin
  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2426), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            label, 
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)
          ),
          const Spacer(),
          Text(
            value, 
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }
}

// Widget StatPill nhỏ bên trong Card
class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon, 
    required this.label, 
    required this.value,
    required this.iconColor,
  });

  final IconData icon; 
  final String label; 
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12), 
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label, 
                    style: const TextStyle(color: Colors.white60, fontSize: 11)
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value, 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 13, 
                      fontWeight: FontWeight.bold
                    ), 
                    overflow: TextOverflow.ellipsis
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
