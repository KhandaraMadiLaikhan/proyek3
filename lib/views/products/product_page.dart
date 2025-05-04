import 'package:flutter/material.dart';
import 'package:proyek/models/client.dart';
import 'package:proyek/models/product.dart';
import 'package:proyek/services/product_services.dart';

class ProductsPage extends StatefulWidget {
  final Client client;

  const ProductsPage({Key? key, required this.client}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProducts(widget.client.accessToken!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk One Gym'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada produk yang tersedia'));
          }

          return _buildProductList(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    final canPurchase = widget.client.age >= (product.minAge ?? 0) &&
        (product.maxAge == null || widget.client.age <= product.maxAge!);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: product.imageUrl != null
                  ? Image.network(
                      'http://192.168.19.208:8000/storage/${product.imageUrl}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )
                  : const Icon(Icons.image, size: 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description.length > 50
                      ? '${product.description.substring(0, 50)}...'
                      : product.description,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${product.price.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.',
                      )}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                if (product.minAge != null || product.maxAge != null)
                  Text(
                    'Batas Usia: ${product.minAge ?? 'Any'} - ${product.maxAge ?? 'Any'} Tahun',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canPurchase ? Colors.green : Colors.grey,
              ),
              onPressed: canPurchase
                  ? () => _purchaseProduct(context, product)
                  : null,
              child: Text(
                canPurchase ? 'Beli' : 'Usia Tidak Memenuhi',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseProduct(BuildContext context, Product product) async {
    setState(() => _isLoading = true);
    try {
      final purchasedProduct = await _productService.purchaseProduct(
        widget.client.accessToken!,
        product.id,
      );

      if (mounted) {
        _showSuccessDialog(context, purchasedProduct);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembelian Berhasil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Anda telah sukses membeli produk berikut:'),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Klik tombol "kembali"\n'
              'Selanjutnya, konfirmasi pembayaran anda sesuai dengan instruksi pembayaran',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }
}