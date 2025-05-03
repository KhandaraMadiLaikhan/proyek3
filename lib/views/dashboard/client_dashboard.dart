import 'package:flutter/material.dart';
import 'package:proyek/models/client.dart';
import 'package:proyek/routes/app_routes.dart';
import 'package:proyek/services/auth_service.dart';

class ClientDashboardPage extends StatefulWidget {
  final Client client;

  const ClientDashboardPage({Key? key, required this.client}) : super(key: key);

  @override
  _ClientDashboardPageState createState() => _ClientDashboardPageState();
}

class _ClientDashboardPageState extends State<ClientDashboardPage> {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Dashboard Container
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Welcome Header
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      widget.client.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF343a40),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // Client Info
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username: ${widget.client.username}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Usia: ${widget.client.age}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jenis Kelamin: ${widget.client.gender == 'male' ? 'Laki-laki' : 'Perempuan'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  
                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFdc3545),
                        ),
                        onPressed: _logout,
                        child: const Text('Keluar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF28a745),
                        ),
                        onPressed: () {
                          // Navigator.pushNamed(context, AppRoutes.products);
                        },
                        child: const Text('Beli Produk'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Info Cards
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildInfoCard(
                    title: 'Metode Pembayaran "DANA"',
                    content: 'Admin\nNo Dana : 08778678531',
                  ),
                  _buildInfoCard(
                    title: 'Instruksi Pembayaran Dana',
                    content: '1. Buka Aplikasi Dana\n'
                             '2. Klik Kirim Uang\n'
                             '3. Masukan No Dana Diatas\n'
                             '4. Masukan Jumlah Pembayaran\n'
                             '5. Masukan No PIN\n'
                             '6. Detail\n'
                             '7. Screenshoot bukti pembayaran\n'
                             '8. Kirim nama lengkap, username beserta bukti screenshoot diatas ke nomor Whatsapp : 081945095702',
                  ),
                  _buildInfoCard(
                    title: 'Konfirmasi Pembelian',
                    content: '1. Klik \'Beli Produk\'\n'
                             '2. Pilih salah satu produk yang tersedia\n'
                             '3. Klik "Beli" produk\n'
                             '4. Setelah pembelian berhasil, lakukan perintah sesuai dengan laman (Intruksi Pembayaran)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFe3e6f0)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF343a40),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6c757d),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await _authService.logout(widget.client.accessToken!);
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }
}