import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cart_item.dart';
import '../bloc/cart_provider.dart';
import 'carr.dart';
import 'detail.dart';

// ══════════════════════════════════════════════════════════════════
// MODELO DE PRODUCTO (adaptador local sobre CartItem)
// ══════════════════════════════════════════════════════════════════
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imagePath; // ruta de asset
  final bool isFavorite;
  final bool isSale;
  final Color imageBgColor;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imagePath,
    this.isFavorite = false,
    this.isSale = false,
    required this.imageBgColor,
  });

  /// Convierte a CartItem para compatibilidad con CartProvider y DetailPage
  CartItem toCartItem() => CartItem(
        id: id,
        name: name,
        variant: category,
        price: price,
        imagePath: imagePath,
      );
}

// ══════════════════════════════════════════════════════════════════
// DATOS DE PRODUCTOS (usan las imágenes de assets del proyecto)
// ══════════════════════════════════════════════════════════════════
final List<Product> _allProducts = [
  const Product(
    id: '1',
    name: 'Velvet Touch Wand',
    category: 'TOYS',
    price: 49.99,
    imagePath: 'assets/images/rose_blindfold.png',
    imageBgColor: Color(0xFFCBE2D7), // soft light green/teal
  ),
  const Product(
    id: '2',
    name: 'Midnight Lace Bodysuit',
    category: 'LINGERIE',
    price: 34.50,
    imagePath: 'assets/images/rose_blindfold.png',
    imageBgColor: Color(0xFFFFFFFF), // pure white background
    isFavorite: true,
  ),
  const Product(
    id: '3',
    name: 'Santal Warming Oil',
    category: 'WELLNESS',
    price: 18.00,
    imagePath: 'assets/images/soy_candle.png',
    imageBgColor: Color(0xFFFDE8C4), // warm yellow background
  ),
  const Product(
    id: '4',
    name: 'Silky Rabbit 2.0',
    category: 'TOYS',
    price: 55.00,
    oldPrice: 75.00,
    imagePath: 'assets/images/soy_candle.png',
    imageBgColor: Color(0xFF1E1E1E), // black/dark background
    isSale: true,
  ),
  const Product(
    id: '5',
    name: 'Silk Eye Mask',
    category: 'LINGERIE',
    price: 19.99,
    imagePath: 'assets/images/rose_blindfold.png',
    imageBgColor: Color(0xFFF3F3F5),
  ),
  const Product(
    id: '6',
    name: 'Massage Candle',
    category: 'WELLNESS',
    price: 29.99,
    imagePath: 'assets/images/soy_candle.png',
    imageBgColor: Color(0xFFF9F1E6),
  ),
];

// ══════════════════════════════════════════════════════════════════
// CONSTANTES DE DISEÑO
// ══════════════════════════════════════════════════════════════════
const Color _kPink = Color(0xFFE91E63);
const Color _kBackground = Color(0xFFF5F5F5);
const Color _kCardBg = Colors.white;
const Color _kTextDark = Color(0xFF212121);
const Color _kTextGrey = Color(0xFF757575);

// ══════════════════════════════════════════════════════════════════
// PÁGINA PRINCIPAL – SHOP
// ══════════════════════════════════════════════════════════════════
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedCategory = 0;
  int _currentNavIndex = 0;

  final List<String> _categories = [
    'All',
    'Toys',
    'Lingerie',
    'Wellness',
  ];

  late List<bool> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = _allProducts.map((p) => p.isFavorite).toList();
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == 0) return _allProducts;
    final cat = _categories[_selectedCategory].toUpperCase();
    return _allProducts.where((p) => p.category == cat).toList();
  }

  // ── Navegar al detalle del producto ──
  void _onProductTap(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product.toCartItem()),
      ),
    );
  }

  // ── Navegar al carrito ──
  void _onCartTap() {
    Navigator.of(context).push(_createCartRoute());
  }

  // ── Agregar al carrito usando CartProvider ──
  void _addToCart(Product product) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(product.toCartItem());

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: _kPink,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ── Toggle favorito ──
  void _toggleFavorite(int globalIndex) {
    setState(() {
      _favorites[globalIndex] = !_favorites[globalIndex];
    });
  }

  // ── Bottom nav ──
  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
    if (index == 2) {
      Navigator.of(context).push(_createCartRoute());
    }
  }

  // ── Transición animada al carrito ──
  Route _createCartRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CartScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(Tween<double>(begin: 0.0, end: 1.0)),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildCategoryTabs(),
            _buildSectionHeader(),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // APP BAR personalizado
  // ─────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Logo + Nombre
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: _kPink,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "L'Amour",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _kTextDark,
            ),
          ),
          const Spacer(),

          // Buscar
          IconButton(
            icon: const Icon(Icons.search, color: _kTextDark, size: 24),
            onPressed: () {},
          ),

          // Carrito con badge reactivo al CartProvider
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final count = cartProvider.items.fold<int>(
                0,
                (sum, i) => sum + i.quantity,
              );
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: _kTextDark,
                      size: 24,
                    ),
                    onPressed: _onCartTap,
                  ),
                  if (count > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: _kPink,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TABS DE CATEGORÍA
  // ─────────────────────────────────────────────
  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.transparent,
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : _kTextDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              selectedColor: _kPink,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? _kPink : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onSelected: (_) {
                setState(() => _selectedCategory = index);
              },
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ENCABEZADO "Featured Products"
  // ─────────────────────────────────────────────
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _kTextDark,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.tune, size: 16, color: _kPink),
            label: const Text(
              'Filters',
              style: TextStyle(
                color: _kPink,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GRID DE PRODUCTOS
  // ─────────────────────────────────────────────
  Widget _buildProductGrid() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products in this category',
          style: TextStyle(color: _kTextGrey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final globalIndex = _allProducts.indexOf(product);
        return _ProductCard(
          product: product,
          isFavorite: _favorites[globalIndex],
          onTap: () => _onProductTap(product),
          onFavoriteTap: () => _toggleFavorite(globalIndex),
          onAddToCart: () => _addToCart(product),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAVIGATION BAR
  // ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: _onNavTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _kPink,
      unselectedItemColor: _kTextGrey,
      backgroundColor: Colors.white,
      elevation: 8,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Catalog',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// TARJETA DE PRODUCTO
// ══════════════════════════════════════════════════════════════════
class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddToCart;

  const _ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen + badges ──
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Imagen del producto (asset)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Hero(
                      tag: 'product-image-${product.id}',
                      child: Container(
                        width: double.infinity,
                        color: product.imageBgColor,
                        child: Image.asset(
                          product.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Badge SALE
                  if (product.isSale)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _kPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Botón favorito
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? _kPink : Colors.grey.shade400,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info del producto ──
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categoría
                    Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _kTextGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Nombre
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _kTextDark,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Precio
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _kPink,
                          ),
                        ),
                        if (product.oldPrice != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${product.oldPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: _kTextGrey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Spacer(),

                    // Botón ADD TO CART
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: _AddToCartButton(onPressed: onAddToCart),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// BOTÓN ADD TO CART con animación de escala
// ══════════════════════════════════════════════════════════════════
class _AddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _AddToCartButton({required this.onPressed});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
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
      child: TextButton(
        onPressed: () {
          _controller.forward().then((_) => _controller.reverse());
          widget.onPressed();
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFCE4EC), // light pink background
          foregroundColor: _kPink, // deep pink text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'ADD TO CART',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
