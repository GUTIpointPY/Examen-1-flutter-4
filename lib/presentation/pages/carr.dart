import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cart_item.dart';
import '../bloc/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<CartItem> _localItems;

  @override
  void initState() {
    super.initState();
    // Pre-populate our local list with current items from Provider
    _localItems = List.from(Provider.of<CartProvider>(context, listen: false).items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
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
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            color: Color(0xFF1E2022),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF1F1F3),
            height: 1.0,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty && _localItems.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              // List of cart items
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: _localItems.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  itemBuilder: (context, index, animation) {
                    // Safe guard for range check during transition
                    if (index >= _localItems.length) return const SizedBox.shrink();
                    final item = _localItems[index];
                    return _buildCartItemCard(item, index, animation, cartProvider);
                  },
                ),
              ),

              // Bottom Section: Summary & Checkout Button
              _buildSummarySection(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  // Build the empty cart state with high visual design
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, val, child) {
          return Transform.scale(
            scale: val,
            child: Opacity(
              opacity: val,
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFD81B60).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: Color(0xFFD81B60),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Cart is Empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2022),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Looks like you haven\'t added anything yet.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD81B60),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Go Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  // Build individual item card
  Widget _buildCartItemCard(
    CartItem item,
    int index,
    Animation<double> animation,
    CartProvider cartProvider,
  ) {
    // Determine the background color of the image container to match the screenshot
    Color imgBgColor = const Color(0xFFF3F3F5); // Gray for blindfold
    if (item.id == '2') {
      imgBgColor = const Color(0xFFFDE8C4); // Warm yellow for candle
    }

    // Combine Scale and Fade animation for smooth entry/exit
    final cardAnimation = animation.drive(
      CurveTween(curve: Curves.easeInOutCubic),
    );

    return SizeTransition(
      sizeFactor: cardAnimation,
      child: FadeTransition(
        opacity: cardAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF1F1F3),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: imgBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Details Column
                Expanded(
                  child: SizedBox(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title and Close Button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2022),
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            // X Close Button
                            GestureDetector(
                              onTap: () => _onRemoveItem(item, index, cartProvider),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Variant
                        Text(
                          item.variant,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),

                        // Price and Quantity Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD81B60),
                              ),
                            ),

                            // Quantity Selector
                            Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFEBEBEB),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  // Minus Button
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      if (item.quantity > 1) {
                                        cartProvider.decrementQuantity(item.id);
                                        // Update local quantity
                                        setState(() {
                                          _localItems[index].quantity--;
                                        });
                                      }
                                    },
                                    child: const SizedBox(
                                      width: 28,
                                      height: double.infinity,
                                      child: Center(
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF1E2022),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Divider
                                  Container(
                                    width: 1.0,
                                    color: const Color(0xFFEBEBEB),
                                  ),
                                  // Quantity Text with AnimatedSwitcher
                                  Container(
                                    width: 32,
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        '${item.quantity}',
                                        key: ValueKey<int>(item.quantity),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E2022),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Divider
                                  Container(
                                    width: 1.0,
                                    color: const Color(0xFFEBEBEB),
                                  ),
                                  // Plus Button
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      cartProvider.incrementQuantity(item.id);
                                      // Update local quantity
                                      setState(() {
                                        _localItems[index].quantity++;
                                      });
                                    },
                                    child: const SizedBox(
                                      width: 28,
                                      height: double.infinity,
                                      child: Center(
                                        child: Text(
                                          '+',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF1E2022),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handles removal of an item from both local state and Provider with animation
  void _onRemoveItem(CartItem item, int index, CartProvider cartProvider) {
    if (index < 0 || index >= _localItems.length) return;

    // Cache the item to animate it as "removed"
    final removedItem = _localItems[index];

    // Remove from local list
    setState(() {
      _localItems.removeAt(index);
    });

    // Animate removal from the list view
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildCartItemCard(removedItem, index, animation, cartProvider),
      duration: const Duration(milliseconds: 300),
    );

    // Remove from CartProvider
    cartProvider.removeItem(item.id);
  }

  // Summary Section containing calculated prices and Checkout Button
  Widget _buildSummarySection(BuildContext context, CartProvider cartProvider) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 20.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal Row
            _buildSummaryRow('Subtotal', '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 12),

            // Shipping Row
            _buildSummaryRow('Shipping', '\$${cartProvider.shipping.toStringAsFixed(2)}'),
            const SizedBox(height: 12),

            // Tax Row
            _buildSummaryRow('Tax', '\$${cartProvider.tax.toStringAsFixed(2)}'),
            const SizedBox(height: 16),

            // Custom Dashed Divider
            const DashedDivider(
              color: Color(0xFFD4D4D8),
              height: 1.0,
              dashWidth: 4.0,
              dashGap: 3.0,
            ),
            const SizedBox(height: 20),

            // Total Row
            _buildSummaryRow(
              'Total',
              '\$${cartProvider.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 24),

            // Animated Scale Checkout Button
            _CheckoutButton(onPressed: () {
              // Perform Checkout Action
              _showCheckoutSuccessDialog(context, cartProvider);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14.5,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF1E2022) : const Color(0xFF8A8E94),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14.5,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF1E2022),
          ),
        ),
      ],
    );
  }

  void _showCheckoutSuccessDialog(BuildContext context, CartProvider cartProvider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Checkout',
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final val = Curves.easeOutBack.transform(anim1.value);
        return Transform.scale(
          scale: val,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFFD81B60),
                  size: 60,
                ),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Order Confirmed!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2022),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Thank you for your purchase. Your premium order is being processed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD81B60),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      cartProvider.clearCart();
                      setState(() {
                        _localItems.clear();
                      });
                      Navigator.of(context).pop(); // Dismiss Dialog
                      Navigator.of(context).pop(); // Back to Shop
                    },
                    child: const Text('Continue Shopping'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Dashed Divider Painter
class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashGap;

  const DashedDivider({
    super.key,
    this.height = 1.0,
    this.color = Colors.grey,
    this.dashWidth = 5.0,
    this.dashGap = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashGap)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

// Checkout Button with micro-animations
class _CheckoutButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _CheckoutButton({required this.onPressed});

  @override
  State<_CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<_CheckoutButton> with SingleTickerProviderStateMixin {
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
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFD81B60), // Vibrant Pink/Magenta
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD81B60).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Proceed to Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
