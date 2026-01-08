import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> _cartItems = [
    CartItem(
      name: 'Premium Smart Watch Series X',
      price: 2499000,
      quantity: 1,
      image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      variant: 'Hitam, 45mm',
    ),
    CartItem(
      name: 'Smart Watch Pro',
      price: 1899000,
      quantity: 1,
      image: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400',
      variant: 'Silver, 42mm',
    ),
  ];

  bool _selectAll = true;

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final shipping = 25000;
    final total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text('Keranjang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showDeleteDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Select All
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Checkbox(
                  value: _selectAll,
                  onChanged: (value) {
                    setState(() {
                      _selectAll = value!;
                      for (var item in _cartItems) {
                        item.isSelected = value;
                      }
                    });
                  },
                  activeColor: Colors.indigo,
                ),
                const Text(
                  'Pilih Semua',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Cart Items
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(_cartItems[index]);
              },
            ),
          ),
          // Summary
          _buildSummary(subtotal, shipping, total),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: item.isSelected,
            onChanged: (value) {
              setState(() {
                item.isSelected = value!;
                _updateSelectAll();
              });
            },
            activeColor: Colors.indigo,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.variant,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (item.quantity > 1) {
                                item.quantity--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 24,
                          color: Colors.indigo,
                        ),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 24,
                          color: Colors.indigo,
                        ),
                      ],
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

  Widget _buildSummary(int subtotal, int shipping, int total) {
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(color: Colors.grey[600])),
              Text('Rp ${_formatPrice(subtotal)}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ongkir', style: TextStyle(color: Colors.grey[600])),
              Text('Rp ${_formatPrice(shipping)}'),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final selectedItems = _cartItems.where((item) => item.isSelected).toList();
                if (selectedItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih item terlebih dahulu')),
                  );
                  return;
                }
                Navigator.pushNamed(
                  context,
                  '/checkout',
                  arguments: selectedItems,
                );
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
                'Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSubtotal() {
    int total = 0;
    for (var item in _cartItems) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  void _updateSelectAll() {
    _selectAll = _cartItems.every((item) => item.isSelected);
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _showDeleteDialog() {
    final selectedItems = _cartItems.where((item) => item.isSelected).toList();
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih item yang ingin dihapus')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text('Hapus ${selectedItems.length} item dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _cartItems.removeWhere((item) => item.isSelected);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final int price;
  int quantity;
  final String image;
  final String variant;
  bool isSelected;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.variant,
    this.isSelected = true,
  });
}
