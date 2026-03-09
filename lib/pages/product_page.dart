// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:grocery_store/components/product.dart';
import 'package:grocery_store/helper/catalog_dialogs.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final List<FruitModel> fruits;
  final String title;
  const ProductPage({super.key, required this.fruits, required this.title});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
              content:
                  Text('Are you sure you want to delete "${fruit.name}"?'),
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

  Future<String?> _showProductContextMenu(Offset position) {
    return showGeneralDialog<String>(
      context: context,
      barrierLabel: 'Dismiss',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.08),
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
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/icons/filter.png",
              color: Colors.black,
            ),
          )
        ],
      ),
      body: widget.fruits.isEmpty
          ? const Center(child: Text('No products found for this category.'))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 17),
              itemCount: ((widget.fruits.length + 1) / 2).ceil(),
              itemBuilder: (context, index) {
                final List<Widget> cards = [
                  for (final fruit in widget.fruits) buildProduct(fruit),
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
                      SizedBox(width: 17), // Horizontal spacing between columns
                      if (secondIndex < cards.length)
                        Expanded(
                          child: SizedBox(
                            height: height,
                            child: cards[secondIndex],
                          ),
                        )
                      else
                        Expanded(
                          child: SizedBox(
                              height:
                                  height), // Placeholder for layout alignment
                        ),
                    ],
                  ),
                );
              },
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
}
