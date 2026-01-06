import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Review',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const ProductReviewPage(),
    );
  }
}

class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({super.key});

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentImageIndex = 0;
  bool _isWishlisted = false;
  final PageController _pageController = PageController();

  final List<String> productImages = [
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
    'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800',
    'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=800',
    'https://images.unsplash.com/photo-1557438159-51eec7a6c9e8?w=800',
  ];

  final List<Review> reviews = [
    Review(
      userName: 'Ahmad Rizki',
      userAvatar: 'A',
      rating: 5,
      date: '2 hari yang lalu',
      comment:
          'Produk sangat bagus! Kualitas premium dan pengiriman cepat. Sangat recommended!',
      helpful: 24,
      photos: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
      ],
      tags: ['Kualitas Bagus', 'Pengiriman Cepat', 'Sesuai Deskripsi'],
      sellerResponse: 'Terima kasih atas review positifnya! Senang produk kami bisa memenuhi ekspektasi Anda. 😊',
      isVerifiedPurchase: true,
    ),
    Review(
      userName: 'Siti Nurhaliza',
      userAvatar: 'S',
      rating: 4,
      date: '1 minggu yang lalu',
      comment:
          'Barang sesuai deskripsi, packaging rapi. Cuma pengiriman agak lama.',
      helpful: 18,
      photos: [],
      tags: ['Sesuai Deskripsi', 'Packaging Rapi'],
      sellerResponse: 'Mohon maaf atas keterlambatan pengiriman. Kami akan tingkatkan layanan kami. Terima kasih!',
      isVerifiedPurchase: true,
    ),
    Review(
      userName: 'Budi Santoso',
      userAvatar: 'B',
      rating: 5,
      date: '2 minggu yang lalu',
      comment: 'Mantap! Sudah 3x order di sini, tidak pernah mengecewakan.',
      helpful: 32,
      photos: [
        'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400',
      ],
      tags: ['Kualitas Bagus', 'Recommended'],
      sellerResponse: null,
      isVerifiedPurchase: true,
    ),
    Review(
      userName: 'Dewi Lestari',
      userAvatar: 'D',
      rating: 4,
      date: '3 minggu yang lalu',
      comment: 'Kualitas oke untuk harga segini. Worth it!',
      helpful: 15,
      photos: [],
      tags: ['Worth It', 'Harga Terjangkau'],
      sellerResponse: null,
      isVerifiedPurchase: false,
    ),
  ];

  final List<Map<String, String>> specifications = [
    {'key': 'Merek', 'value': 'TechWatch Pro'},
    {'key': 'Model', 'value': 'Series X 2024'},
    {'key': 'Layar', 'value': 'AMOLED 1.9 inch'},
    {'key': 'Resolusi', 'value': '454 x 454 pixels'},
    {'key': 'Baterai', 'value': '450 mAh (7 hari)'},
    {'key': 'Tahan Air', 'value': 'IP68 (5ATM)'},
    {'key': 'Konektivitas', 'value': 'Bluetooth 5.2, WiFi'},
    {'key': 'Sensor', 'value': 'Heart Rate, SpO2, GPS'},
    {'key': 'Kompatibilitas', 'value': 'Android & iOS'},
    {'key': 'Berat', 'value': '45 gram'},
  ];

  final List<Product> similarProducts = [
    Product(
      name: 'Smart Watch Pro',
      price: 'Rp 1.899.000',
      image: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=400',
      rating: 4.3,
      sold: '856',
    ),
    Product(
      name: 'Fitness Band Ultra',
      price: 'Rp 899.000',
      image: 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400',
      rating: 4.5,
      sold: '1.2rb',
    ),
    Product(
      name: 'Sport Watch Lite',
      price: 'Rp 1.299.000',
      image: 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=400',
      rating: 4.1,
      sold: '654',
    ),
    Product(
      name: 'Classic Smart Watch',
      price: 'Rp 2.199.000',
      image: 'https://images.unsplash.com/photo-1617043786394-f977fa12eddf?w=400',
      rating: 4.7,
      sold: '2.1rb',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Image Carousel
          _buildSliverAppBar(),
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProductInfo(),
                const SizedBox(height: 12),
                _buildTabSection(),
                const SizedBox(height: 12),
                _buildSimilarProducts(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: Colors.indigo,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.indigo),
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              _isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: _isWishlisted ? Colors.red : Colors.indigo,
            ),
          ),
          onPressed: () {
            setState(() {
              _isWishlisted = !_isWishlisted;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isWishlisted
                      ? 'Ditambahkan ke Wishlist'
                      : 'Dihapus dari Wishlist',
                ),
                duration: const Duration(seconds: 1),
                backgroundColor: _isWishlisted ? Colors.red : Colors.grey,
              ),
            );
          },
        ),
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.share, color: Colors.indigo),
          ),
          onPressed: () => _shareProduct(),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Image Carousel
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: productImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showImageGallery(index),
                  child: Image.network(
                    productImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 80, color: Colors.grey),
                      );
                    },
                  ),
                );
              },
            ),
            // Image Indicators
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  productImages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.indigo
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Image Counter
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${productImages.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price
          Row(
            children: [
              Text(
                'Rp 2.499.000',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-24%',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Rp 3.299.000',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 12),
          // Product Name
          const Text(
            'Premium Smart Watch Series X - AMOLED Display, GPS, Heart Rate Monitor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          // Rating & Sold
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '4.5',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${reviews.length} reviews)',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.local_shipping_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('1.2rb terjual', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 16),
          // Badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBadge(Icons.verified, 'Original 100%', Colors.green),
              _buildBadge(Icons.local_shipping, 'Free Ongkir', Colors.blue),
              _buildBadge(Icons.security, 'Garansi 1 Tahun', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.indigo,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.indigo,
            tabs: const [
              Tab(text: 'Detail'),
              Tab(text: 'Spesifikasi'),
              Tab(text: 'Review'),
            ],
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailTab(),
                _buildSpecificationTab(),
                _buildReviewTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi Produk',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Premium Smart Watch Series X adalah smartwatch flagship terbaru dengan teknologi canggih dan desain elegan. Dilengkapi dengan layar AMOLED 1.9 inch yang jernih dan tajam, cocok untuk berbagai aktivitas sehari-hari.\n\n'
            '✨ Fitur Unggulan:\n'
            '• Layar AMOLED 1.9" dengan resolusi 454x454 pixels\n'
            '• Baterai tahan hingga 7 hari pemakaian normal\n'
            '• Water resistant IP68 (5ATM)\n'
            '• GPS Built-in untuk tracking aktivitas outdoor\n'
            '• Heart Rate & SpO2 monitoring 24/7\n'
            '• 100+ Sport Modes\n'
            '• Bluetooth 5.2 & WiFi connectivity\n'
            '• Compatible dengan Android & iOS\n\n'
            '📦 Dalam Paket:\n'
            '• 1x Smart Watch Series X\n'
            '• 1x Magnetic Charging Cable\n'
            '• 1x User Manual\n'
            '• 1x Premium Gift Box',
            style: TextStyle(fontSize: 14, height: 1.8),
          ),
          const SizedBox(height: 20),
          // Photo Gallery from Reviews
          const Text(
            'Foto dari Pembeli',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _getAllReviewPhotos().length,
              itemBuilder: (context, index) {
                final photos = _getAllReviewPhotos();
                return GestureDetector(
                  onTap: () => _showPhotoReviewGallery(index),
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(photos[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spesifikasi Produk',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...specifications.map((spec) => _buildSpecRow(spec['key']!, spec['value']!)),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              key,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingSummary(),
          const SizedBox(height: 16),
          // Review Tags Filter
          const Text(
            'Filter by Tags',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterTag('Semua', true),
              _buildFilterTag('Dengan Foto', false),
              _buildFilterTag('Kualitas Bagus', false),
              _buildFilterTag('Pengiriman Cepat', false),
            ],
          ),
          const SizedBox(height: 16),
          // Reviews List
          ...reviews.map((review) => _buildReviewCard(review)),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                side: const BorderSide(color: Colors.indigo),
              ),
              child: const Text('Lihat Semua Review'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTag(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.indigo : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.indigo : Colors.grey[300]!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              const Text(
                '4.5',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              _buildStarRating(4.5),
              const SizedBox(height: 4),
              Text(
                '${reviews.length} reviews',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar('5', 0.7),
                _buildRatingBar('4', 0.2),
                _buildRatingBar('3', 0.05),
                _buildRatingBar('2', 0.03),
                _buildRatingBar('1', 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigo[100],
                child: Text(
                  review.userAvatar,
                  style: TextStyle(
                    color: Colors.indigo[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (review.isVerifiedPurchase) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified, size: 12, color: Colors.green[700]),
                                const SizedBox(width: 2),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStarRating(review.rating.toDouble(), size: 14),
                        const SizedBox(width: 8),
                        Text(
                          review.date,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review Tags
          if (review.tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: review.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
          // Comment
          Text(
            review.comment,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          // Photos
          if (review.photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.photos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showReviewPhoto(review.photos, index),
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(review.photos[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Helpful
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${review.helpful} terbantu',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_outlined, size: 14),
                label: const Text('Helpful', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(foregroundColor: Colors.indigo),
              ),
            ],
          ),
          // Seller Response
          if (review.sellerResponse != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.store, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Balasan Penjual',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.sellerResponse!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[900],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSimilarProducts() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Produk Serupa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: similarProducts.length,
              itemBuilder: (context, index) {
                final product = similarProducts[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.image,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.price,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 12, color: Colors.amber),
                                Text(
                                  ' ${product.rating}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  ' | ${product.sold} terjual',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat_outlined, color: Colors.indigo),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.indigo),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('+ Keranjang'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Beli Sekarang'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: size);
        }
      }),
    );
  }

  List<String> _getAllReviewPhotos() {
    List<String> photos = [];
    for (var review in reviews) {
      photos.addAll(review.photos);
    }
    return photos;
  }

  void _showImageGallery(int initialIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: productImages.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(
                        productImages[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhotoReviewGallery(int initialIndex) {
    final photos = _getAllReviewPhotos();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(photos[index], fit: BoxFit.contain),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReviewPhoto(List<String> photos, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(photos[index], fit: BoxFit.contain),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareProduct() {
    Share.share(
      'Check out this amazing product!\n\n'
      'Premium Smart Watch Series X\n'
      'Only Rp 2.499.000 (24% OFF!)\n\n'
      'https://shop.example.com/product/smart-watch-x',
      subject: 'Premium Smart Watch Series X',
    );
  }
}

class Review {
  final String userName;
  final String userAvatar;
  final int rating;
  final String date;
  final String comment;
  final int helpful;
  final List<String> photos;
  final List<String> tags;
  final String? sellerResponse;
  final bool isVerifiedPurchase;

  Review({
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.date,
    required this.comment,
    required this.helpful,
    required this.photos,
    required this.tags,
    this.sellerResponse,
    this.isVerifiedPurchase = false,
  });
}

class Product {
  final String name;
  final String price;
  final String image;
  final double rating;
  final String sold;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.sold,
  });
}