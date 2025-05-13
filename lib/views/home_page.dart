import 'package:flutter/material.dart';
import 'package:proyek/routes/app_routes.dart'; // Update import path

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showWelcome = false;
  bool showQuote = false;
  bool showTitle = false;
  bool showButton = false;
  bool showCards = false;

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => showWelcome = true);

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => showQuote = true);

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => showTitle = true);

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => showButton = true);

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => showCards = true);
  }

  Widget _buildAnimatedItem(bool visible, Widget child) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.2),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Tulisan sambutan
              _buildAnimatedItem(
                showWelcome,
                const Center(
                  child: Text(
                    'Selamat datang di One Gym',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Kutipan
              _buildAnimatedItem(
                showQuote,
                const Center(
                  child: Text(
                    '"Semua orang ingin sehat, tetapi tidak semua orang menjaga kesehatannya"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Judul "One GYM"
              _buildAnimatedItem(
                showTitle,
                Center(
                  child: Image.asset(
                    'images/gym5.png', // Ganti dengan path gambarmu
                    height: 250, // Atur sesuai ukuran yang diinginkan
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tombol Login
              _buildAnimatedItem(
                showButton,
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 237, 241, 247),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // InfoCards
              _buildAnimatedItem(
                showCards,
                Center(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: const [
                      InfoCard(
                        title: 'Tentang Gym',
                        content:
                            'One Gym adalah tempat di mana terdapat alat-alat olahraga yang digunakan untuk membantu meningkatkan kebugaran dan membentuk otot tubuh.\n\nBlok Bojong Sari RT 15/RW 01, Desa Lelea, Kecamatan Lelea, Kabupaten Indramayu',
                      ),
                      InfoCard(
                        title: 'Kontak',
                        content:
                            'WA: 0819-4505-5702\nEmail: wriswandi82@gmail.com',
                      ),
                      InfoCard(
                        title: 'Produk',
                        content: '- Member\n- Harian',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 230, // tambahkan height agar semua card sama tinggi
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                 textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
