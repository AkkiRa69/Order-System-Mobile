// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/banner.dart';
import 'package:grocery_store/components/per_category.dart';
import 'package:grocery_store/components/product.dart';
import 'package:grocery_store/components/search_bar.dart';
import 'package:grocery_store/helper/catalog_dialogs.dart';
import 'package:grocery_store/model/category_model.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/category_page.dart';
import 'package:grocery_store/pages/filter_page.dart';
import 'package:grocery_store/pages/product_page.dart';
import 'package:grocery_store/pages/search_tap_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final List<Color> colors = [
    Color(0xFFE6F2EA),
    Color(0xFFFFE9E5),
    Color(0xFFFFF6E3),
    Color(0xFFF3EFFA),
    Color(0xFFDCF4F5),
    Color(0xFFFFE8F2),
    Color(0xFFD2EFFF),
  ];

  void navigateToProductDetail(BuildContext context, FruitModel fruits) {
    CatalogDialogs.showProductUpsertDialog(context, product: fruits);
  }

  Future<void> _showProductActions(FruitModel fruit, Offset position) async {
    final action = await _showProductContextMenu(position);

    if (!mounted || action == null) return;
    if (action == 'edit') {
      navigateToProductDetail(context, fruit);
      return;
    }

    if (action == 'delete') {
      final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Product'),
              content: Text('Are you sure you want to delete "${fruit.name}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ) ??
          false;

      if (!shouldDelete || fruit.id == null || !mounted) return;
      final ok = await context.read<FruitProvider>().deleteProduct(fruit.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Product deleted' : 'Failed to delete product'),
        ),
      );
    }
  }

  Future<void> _showCategoryActions(
      CategoryModel category, Offset position) async {
    final action = await _showCategoryContextMenu(position);
    if (!mounted || action == null) return;

    if (action == 'edit') {
      CatalogDialogs.showCategoryUpsertDialog(context, category: category);
      return;
    }

    if (action == 'delete') {
      if (category.id == null) return;
      final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Category'),
              content:
                  Text('Are you sure you want to delete "${category.name}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ) ??
          false;

      if (!shouldDelete || !mounted) return;
      final ok =
          await context.read<FruitProvider>().deleteCategory(category.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Category deleted' : 'Failed to delete category'),
        ),
      );
    }
  }

  Future<String?> _showCategoryContextMenu(Offset position) {
    return showGeneralDialog<String>(
      context: context,
      barrierLabel: 'Dismiss',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.08),
      transitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (context, animation, secondaryAnimation) {
        final size = MediaQuery.of(context).size;
        const menuWidth = 188.0;
        const rowHeight = 52.0;
        const menuHeight = rowHeight * 2 + 1;
        final left = (position.dx - (menuWidth / 2))
            .clamp(12.0, size.width - menuWidth - 12);
        final top = (position.dy - menuHeight - 12)
            .clamp(12.0, size.height - menuHeight - 12);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: menuWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xF022242A),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2A000000),
                        blurRadius: 22,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuAction(
                        label: 'Edit',
                        icon: Icons.edit_outlined,
                        color: Colors.white,
                        onTap: () => Navigator.pop(context, 'edit'),
                      ),
                      Container(height: 1, color: Colors.white10),
                      _menuAction(
                        label: 'Delete',
                        icon: Icons.delete_outline,
                        color: const Color(0xFFFF4D4D),
                        onTap: () => Navigator.pop(context, 'delete'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showProductContextMenu(Offset position) {
    return showGeneralDialog<String>(
      context: context,
      barrierLabel: 'Dismiss',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.08),
      transitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (context, animation, secondaryAnimation) {
        final size = MediaQuery.of(context).size;
        const menuWidth = 188.0;
        const rowHeight = 52.0;
        const menuHeight = rowHeight * 2 + 1;
        final left = (position.dx - (menuWidth / 2))
            .clamp(12.0, size.width - menuWidth - 12);
        final top = (position.dy - menuHeight - 12)
            .clamp(12.0, size.height - menuHeight - 12);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: menuWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xF022242A),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2A000000),
                        blurRadius: 22,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuAction(
                        label: 'Edit',
                        icon: Icons.edit_outlined,
                        color: Colors.white,
                        onTap: () => Navigator.pop(context, 'edit'),
                      ),
                      Container(height: 1, color: Colors.white10),
                      _menuAction(
                        label: 'Delete',
                        icon: Icons.delete_outline,
                        color: const Color(0xFFFF4D4D),
                        onTap: () => Navigator.pop(context, 'delete'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _menuAction({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final fruitProvider = context.watch<FruitProvider>();
    List<FruitModel> fruits = fruitProvider.fruitList;
    final categories = fruitProvider.categories;
    List cates = fruitProvider.cates;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFF4F5F9),
              ],
            ),
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              //search bar
              MySearchBar(
                searchTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: SearchTapPage(),
                        type: PageTransitionType.leftToRight),
                  );
                },
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: FilterPage(),
                      type: PageTransitionType.bottomToTop,
                      duration: Duration(
                          milliseconds: 300), // Adjust duration as needed
                      reverseDuration: Duration(
                          milliseconds:
                              300), // Adjust reverse duration as needed
                      curve:
                          Curves.easeInOut, // Add a curve for smooth animation
                    ),
                  );
                },
              ),

              //banner
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: MyBanner(),
              ),

              //Categories
              Padding(
                padding: const EdgeInsets.only(left: 17, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: CategoryPage(
                                  fruits: fruits,
                                  cates: cates,
                                  colors: colors,
                                ),
                                type: PageTransitionType.bottomToTop));
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              Container(
                height: 90,
                padding: const EdgeInsets.only(left: 17),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < categories.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: PerCategory(
                          backColor: Colors.transparent,
                          cates: [categories[i].name, categories[i].icon],
                          colors: colors[i % colors.length],
                          onTap: () {
                            final productsByCategory = context
                                .read<FruitProvider>()
                                .productsByCategoryName(categories[i].name);
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: ProductPage(
                                        fruits: productsByCategory,
                                        title: categories[i].name),
                                    type: PageTransitionType.bottomToTop));
                          },
                          onLongPress: (position) =>
                              _showCategoryActions(categories[i], position),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildAddCategoryCard(),
                    ),
                  ],
                ),
              ),

              //features product
              Padding(
                padding: const EdgeInsets.only(left: 17, top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Features Product",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ProductPage(
                                    fruits: fruits, title: "Vegetables"),
                                type: PageTransitionType.bottomToTop));
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              if (fruitProvider.isLoading && fruits.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (fruitProvider.errorMessage != null && fruits.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        fruitProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<FruitProvider>().fetchInitialData(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (fruits.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('No products available')),
                )
              else
                ListView.builder(
                  // Append an Add Product card at the end.
                  padding: EdgeInsets.symmetric(horizontal: 17),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ((fruits.length + 1) / 2).ceil(),
                  itemBuilder: (context, index) {
                    final List<Widget> cards = [
                      for (final fruit in fruits) buildProduct(fruit),
                      _buildAddProductCard(),
                    ];
                    int firstIndex = index * 2;
                    int secondIndex = firstIndex + 1;
                    double height = 280;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: height,
                              child: cards[firstIndex],
                            ),
                          ),
                          SizedBox(
                              width: 17), // Horizontal spacing between columns
                          if (secondIndex < fruits.length)
                            Expanded(
                              child: SizedBox(
                                height: height,
                                child: cards[secondIndex],
                              ),
                            )
                          else if (secondIndex < cards.length)
                            Expanded(
                              child: SizedBox(
                                height: height,
                                child: cards[secondIndex],
                              ),
                            )
                          else
                            Expanded(
                              child: SizedBox(height: height),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProduct(FruitModel fruits) {
    return Product(
      onPressed: () {
        final provider = context.read<FruitProvider>();
        if (fruits.isFav) {
          provider.removeProductFavorite(fruits);
        } else {
          provider.addProductToFavorites(fruits);
        }
      },
      isFav: fruits.isFav,
      fruits: fruits,
      onTap: () {
        navigateToProductDetail(context, fruits);
      },
      onLongPress: (position) => _showProductActions(fruits, position),
    );
  }

  Widget _buildAddCategoryCard() {
    return GestureDetector(
      onTap: () => CatalogDialogs.showCreateCategoryDialog(context),
      child: Container(
        width: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF6CC51D)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Color(0xFF6CC51D)),
            SizedBox(height: 6),
            Text('Add More'),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductCard() {
    return GestureDetector(
      onTap: () => CatalogDialogs.showProductUpsertDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF6CC51D)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_box_outlined, size: 36, color: Color(0xFF6CC51D)),
            SizedBox(height: 8),
            Text(
              'Add More Product',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
