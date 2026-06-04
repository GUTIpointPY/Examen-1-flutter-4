import 'package:flutter/material.dart';
// ─── Importar cuando existan las otras páginas ───
// import 'detail.dart';  // Para navegar al detalle del producto
// import 'carr.dart';     // Para navegar al carrito
// import 'login.dart';    // Para navegar al login/perfil

// ══════════════════════════════════════════════════════════════════
// MODELO DE PRODUCTO (mover a models/ si se desea)
// ══════════════════════════════════════════════════════════════════
class Product {
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final bool isSale;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.isFavorite = false,
    this.isSale = false,
  });
}

// ══════════════════════════════════════════════════════════════════
// DATOS DE EJEMPLO
// ══════════════════════════════════════════════════════════════════
final List<Product> _allProducts = [
  const Product(
    name: 'Velvet Touch Wand',
    category: 'TOYS',
    price: 49.99,
    imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=300&fit=crop',
    isFavorite: false,
  ),
  const Product(
    name: 'Midnight Lace Bodysuit',
    category: 'LINGERIE',
    price: 34.50,
    imageUrl: 'https://images.unsplash.com/photo-1617331140180-e8262094733a?w=300&h=300&fit=crop',
    isFavorite: true,
  ),
  const Product(
    name: 'Santal Warming Oil',
    category: 'WELLNESS',
    price: 18.00,
    imageUrl: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=300&h=300&fit=crop',
  ),
  const Product(
    name: 'Silky Rabbit 2.0',
    category: 'TOYS',
    price: 55.00,
    oldPrice: 75.00,
    imageUrl: 'https://images.unsplash.com/photo-1559715541-5daf8a0296d0?w=300&h=300&fit=crop',
    isSale: true,
  ),
  const Product(
    name: 'Rose Quartz Roller',
    category: 'WELLNESS',
    price: 22.00,
    imageUrl: 'https://images.unsplash.com/photo-1590439471364-192aa70c0b53?w=300&h=300&fit=crop',
  ),
  const Product(
    name: 'Silk Chemise',
    category: 'LINGERIE',
    price: 42.00,
    imageUrl: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=300&h=300&fit=crop',
  ),
];

// ══════════════════════════════════════════════════════════════════
// CONSTANTES DE DISEÑO
// ══════════════════════════════════════════════════════════════════
const Color _kPink = Color(0xFFE91E63);
const Color _kDarkPink = Color(0xFFC2185B);
const Color _kLightPink = Color(0xFFFCE4EC);
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
  final List<String> _categories = ['All', 'Toys', 'Lingerie', 'Wellness'];

  // Productos favoritos (estado local)
  late List<bool> _favorites;

  // ── Carrito simple (cantidad de items) ──
  int _cartCount = 2;

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

  // ── Acción al pulsar un producto ──
  void _onProductTap(Product product) {
    // TODO: Navegar a la página de detalle cuando esté lista
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => DetailPage(product: product),
    //   ),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Detalle de ${product.name} (pendiente)'),
        backgroundColor: _kPink,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ── Acción al pulsar el carrito ──
  void _onCartTap() {
    // TODO: Navegar a la página del carrito cuando esté lista
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => const CartPage()),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Carrito (pendiente)'),
        backgroundColor: _kPink,
        duration: Duration(seconds: 1),
      ),
    );
  }

  // ── Agregar al carrito ──
  void _addToCart(Product product) {
    setState(() {
      _cartCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
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
    setState(() {
      _currentNavIndex = index;
    });
    // TODO: Navegar según el índice
    // if (index == 2) {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
    // } else if (index == 3) {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    // }
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Logo + Nombre
          const Icon(Icons.favorite, color: _kPink, size: 28),
          const SizedBox(width: 8),
          const Text(
            "L'Amour",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _kTextDark,
            ),
          ),
          const Spacer(),

          // Buscar
          IconButton(
            icon: const Icon(Icons.search, color: _kTextDark, size: 26),
            onPressed: () {
              // TODO: Implementar búsqueda
            },
          ),

          // Carrito con badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: _kTextDark, size: 26),
                onPressed: _onCartTap,
              ),
              if (_cartCount > 0)
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
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TABS DE CATEGORÍA
  // ─────────────────────────────────────────────
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : _kTextDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: isSelected,
              selectedColor: _kPink,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? _kPink : Colors.grey.shade300,
                ),
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
  // ENCABEZADO "Featured Products" + Filtros
  // ─────────────────────────────────────────────
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _kTextDark,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {
              // TODO: Mostrar filtros
            },
            icon: const Icon(Icons.tune, size: 18, color: _kPink),
            label: const Text(
              'Filters',
              style: TextStyle(color: _kPink, fontWeight: FontWeight.w600),
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
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        // Encontrar el índice global para manejar favoritos
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
              color: Colors.black.withOpacity(0.05),
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
                  // Imagen
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFF5E6D0),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Badge de SALE
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

                  // Botón de favorito
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? _kPink : _kTextGrey,
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
                      maxLines: 1,
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
                      child: OutlinedButton(
                        onPressed: onAddToCart,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _kPink,
                          side: const BorderSide(color: _kPink),
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