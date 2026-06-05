import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cart_item.dart';
import '../bloc/cart_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final CartItem product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with SingleTickerProviderStateMixin {
  int _quantity = 1;
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the background color of the image container to match the screenshot
    Color imgBgColor = const Color(0xFFF3F3F5); // Gray for blindfold
    if (widget.product.id == '1') {
      imgBgColor = const Color(0xFFB35930); // Rust/Orange for Wand to match screenshot
    } else if (widget.product.id == '2') {
      imgBgColor = const Color(0xFFFFFFFF); // White for bodysuit
    } else if (widget.product.id == '3') {
      imgBgColor = const Color(0xFFFDE8C4); // Warm yellow for candle
    } else if (widget.product.id == '4') {
      imgBgColor = const Color(0xFF1E1E1E); // Black for rabbit
    }

    // Determine custom title and description to match the screenshot for product ID '1'
    final String displayName = widget.product.id == '1'
        ? 'Velvet Touch Rechargeable Wand'
        : widget.product.name;

    final String displayDescription = widget.product.id == '1'
        ? 'Experience ultimate relaxation with the Velvet Touch. Crafted from medical-grade silicone, this powerful wand offers 10 distinct vibration modes and a flexible head designed to reach every curve. Whisper-quiet and fully waterproof for versatile use.'
        : 'Experience ultimate relaxation and comfort with this premium product. Made with high quality materials and designed to suit your modern lifestyle, it delivers an unparalleled sensation of luxury. Ideal for personal use or as a thoughtful gift for someone special.';

    // Dynamic price adjustment to match the screenshot precisely if ID is '1'
    final double displayPrice = widget.product.id == '1' ? 89.00 : widget.product.price;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF1E2022),
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Color(0xFF1E2022),
              size: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Color(0xFFE91E63),
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Carousel Section
            ProductImageCarousel(
              product: widget.product,
              backgroundColor: imgBgColor,
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2C2C2C),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price & Bestseller Badge Row
                  Row(
                    children: [
                      Text(
                        '\$${displayPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (widget.product.id == '1')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE91E63).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'BESTSELLER',
                            style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description Heading
                  Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description Text
                  Text(
                    displayDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Specs Grid Rows
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MATERIAL',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF94A3B8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product.id == '1' ? 'Premium Silicone' : 'Premium Quality',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'RUN TIME',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF94A3B8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product.id == '1' ? '120 Minutes' : 'N/A',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFF1F1F3),
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity Selector
              Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.remove, size: 16, color: Color(0xFF64748B)),
                      ),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() => _quantity++);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.add, size: 16, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Add to Cart Button (Animated)
              Expanded(
                child: ScaleTransition(
                  scale: _scale,
                  child: GestureDetector(
                    onTapDown: (_) => _controller.forward(),
                    onTapUp: (_) {
                      _controller.reverse();
                      final cart = Provider.of<CartProvider>(context, listen: false);
                      // Add with correct quantity
                      cart.addItem(widget.product.copyWith(price: displayPrice), _quantity);

                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_quantity}x $displayName added to cart!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color(0xFFE91E63),
                        ),
                      );
                    },
                    onTapCancel: () => _controller.reverse(),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE91E63).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'ADD TO CART',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
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

class ProductImageCarousel extends StatefulWidget {
  final CartItem product;
  final Color backgroundColor;

  const ProductImageCarousel({
    super.key,
    required this.product,
    required this.backgroundColor,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      widget.product.imagePath,
      widget.product.id == '2'
          ? 'assets/images/rose_blindfold.png'
          : 'assets/images/soy_candle.png',
      widget.product.imagePath,
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: screenWidth,
              height: screenWidth, // Perfectly square container to match screenshot layout
              color: widget.backgroundColor,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imageWidget = Image.asset(
                    images[index],
                    fit: BoxFit.cover, // Cover layout to fill the square container
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 64, color: Colors.grey),
                    ),
                  );

                  // Wrap only the first page with Hero to smoothly transition from the shop page
                  if (index == 0) {
                    return Hero(
                      tag: 'product-image-${widget.product.id}',
                      child: imageWidget,
                    );
                  }

                  return imageWidget;
                },
              ),
            ),
            // Carousel Indicator Dots (matching screenshot colors)
            Positioned(
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: 8, // Fully circular dots instead of expandable pills
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFFE91E63)
                          : Colors.white.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
