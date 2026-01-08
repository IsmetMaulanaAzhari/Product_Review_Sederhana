import 'package:flutter/material.dart';
import 'cart_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem>? cartItems;

  const CheckoutPage({super.key, this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPayment = 'Transfer Bank';
  String _selectedShipping = 'JNE Regular';

  final List<String> _paymentMethods = [
    'Transfer Bank',
    'E-Wallet (GoPay, OVO, Dana)',
    'Kartu Kredit/Debit',
    'COD (Bayar di Tempat)',
  ];

  final List<Map<String, dynamic>> _shippingOptions = [
    {'name': 'JNE Regular', 'price': 25000, 'estimate': '3-4 hari'},
    {'name': 'JNE YES', 'price': 45000, 'estimate': '1-2 hari'},
    {'name': 'SiCepat Regular', 'price': 20000, 'estimate': '3-5 hari'},
    {'name': 'Instant Courier', 'price': 75000, 'estimate': 'Hari ini'},
  ];

  @override
  Widget build(BuildContext context) {
    final items = widget.cartItems ?? [];
    final subtotal = _calculateSubtotal(items);
    final shipping = _getShippingPrice();
    final total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            _buildSection(
              'Alamat Pengiriman',
              Icons.location_on,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ismet Maulana Azhari',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Ubah'),
                      ),
                    ],
                  ),
                  Text(
                    '+62 812 3456 7890',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jl. Raya Cipadung No. 123\nBandung, Jawa Barat 40614',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Order Items
            _buildSection(
              'Pesanan (${items.length} item)',
              Icons.shopping_bag,
              child: Column(
                children: items.map((item) => _buildOrderItem(item)).toList(),
              ),
            ),
            // Shipping Method
            _buildSection(
              'Metode Pengiriman',
              Icons.local_shipping,
              child: Column(
                children: _shippingOptions.map((option) {
                  return RadioListTile<String>(
                    value: option['name'],
                    groupValue: _selectedShipping,
                    onChanged: (value) {
                      setState(() {
                        _selectedShipping = value!;
                      });
                    },
                    title: Text(option['name']),
                    subtitle: Text(
                      'Estimasi: ${option['estimate']} • Rp ${_formatPrice(option['price'])}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    activeColor: Colors.indigo,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ),
            // Payment Method
            _buildSection(
              'Metode Pembayaran',
              Icons.payment,
              child: Column(
                children: _paymentMethods.map((method) {
                  return RadioListTile<String>(
                    value: method,
                    groupValue: _selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        _selectedPayment = value!;
                      });
                    },
                    title: Text(method),
                    activeColor: Colors.indigo,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ),
            // Price Summary
            _buildSection(
              'Ringkasan Pembayaran',
              Icons.receipt,
              child: Column(
                children: [
                  _buildPriceRow('Subtotal Produk', subtotal),
                  _buildPriceRow('Ongkos Kirim', shipping),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${_formatPrice(total)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(total),
    );
  }

  Widget _buildSection(String title, IconData icon, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.variant,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${_formatPrice(item.price)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[700],
                      ),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text('Rp ${_formatPrice(price)}'),
        ],
      ),
    );
  }

  Widget _buildBottomBar(int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pembayaran',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  'Rp ${_formatPrice(total)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[700],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showSuccessDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Bayar Sekarang',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSubtotal(List<CartItem> items) {
    int total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int _getShippingPrice() {
    final option = _shippingOptions.firstWhere(
      (opt) => opt['name'] == _selectedShipping,
    );
    return option['price'];
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 64,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pesanan Anda sedang diproses.\nSilakan cek email untuk detail pembayaran.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Kembali ke Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
