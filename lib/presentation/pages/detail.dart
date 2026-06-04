import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cart_item.dart';
import '../bloc/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final CartItem product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Color imgBgColor = const Color(0xFFF3F3F5); // Gray for blindfold
    if (product.id == '2') {
      imgBgColor = const Color(0xFFFDE8C4); // Warm yellow for candle
    }

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
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 320,
                color: imgBgColor,
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: Image.asset(
                    product.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 64, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Variant Label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD81B60).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.variant,
                      style: const TextStyle(
                        color: Color(0xFFD81B60),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E2022),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD81B60),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  const Divider(color: Color(0xFFF1F1F3), height: 1),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About this Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2022),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Experience ultimate relaxation and comfort with this premium product. Made with high quality materials and designed to suit your modern lifestyle, it delivers an unparalleled sensation of luxury. Ideal for personal use or as a thoughtful gift for someone special.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
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
              // Heart Icon Button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEBEBEB)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Color(0xFF1E2022),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),

              // Add to Cart Button
              Expanded(
                child: _DetailAddToCartButton(product: product),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailAddToCartButton extends StatefulWidget {
  final CartItem product;
  const _DetailAddToCartButton({required this.product});

  @override
  State<_DetailAddToCartButton> createState() => _DetailAddToCartButtonState();
}

class _DetailAddToCartButtonState extends State<_DetailAddToCartButton> with SingleTickerProviderStateMixin {
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
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          final cart = Provider.of<CartProvider>(context, listen: false);
          cart.addItem(widget.product);
          
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.product.name} added to cart!'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xFFD81B60),
            ),
          );
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFD81B60),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD81B60).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Add to Cart',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
