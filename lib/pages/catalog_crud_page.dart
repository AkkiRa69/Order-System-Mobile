import 'package:flutter/material.dart';
import 'package:grocery_store/helper/catalog_dialogs.dart';
import 'package:grocery_store/model/category_model.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:provider/provider.dart';

class CatalogCrudPage extends StatefulWidget {
  const CatalogCrudPage({super.key});

  @override
  State<CatalogCrudPage> createState() => _CatalogCrudPageState();
}

class _CatalogCrudPageState extends State<CatalogCrudPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _activeQuery = '';
  List<CategoryModel> _searchedCategories = const [];
  List<FruitModel> _searchedProducts = const [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FruitProvider>();
    final categoriesToShow =
        _activeQuery.isEmpty ? provider.categories : _searchedCategories;
    final productsToShow =
        _activeQuery.isEmpty ? provider.fruitList : _searchedProducts;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catalog CRUD'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Products'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => context.read<FruitProvider>().fetchInitialData(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _isSearching ? null : (_) => _performSearch(),
                decoration: InputDecoration(
                  hintText: 'Search categories and products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : (_activeQuery.isEmpty
                          ? IconButton(
                              onPressed: _performSearch,
                              icon: const Icon(Icons.arrow_forward),
                            )
                          : IconButton(
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close),
                            )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_activeQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Results for "$_activeQuery": ${_searchedCategories.length} categories, ${_searchedProducts.length} products',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            if (provider.errorMessage != null)
              Container(
                width: double.infinity,
                color: Colors.red.shade50,
                padding: const EdgeInsets.all(12),
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
            Expanded(
              child: provider.isLoading &&
                      provider.categories.isEmpty &&
                      provider.fruitList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      children: [
                        _buildCategoriesTab(context, categoriesToShow),
                        _buildProductsTab(context, provider, productsToShow),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab(
      BuildContext context, List<CategoryModel> categories) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => CatalogDialogs.showCategoryUpsertDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
            ),
          ),
        ),
        Expanded(
          child: categories.isEmpty
              ? const Center(child: Text('No categories found'))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onLongPressStart: (details) => _showCategoryActions(
                          category, details.globalPosition),
                      child: ListTile(
                        title: Text(category.name),
                        subtitle: Text('ID: ${category.id ?? '-'}'),
                        trailing: const Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.black45,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductsTab(
      BuildContext context, FruitProvider provider, List<FruitModel> products) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: provider.categories.isEmpty
                  ? null
                  : () => CatalogDialogs.showProductUpsertDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ),
        ),
        Expanded(
          child: products.isEmpty
              ? const Center(child: Text('No products found'))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                        'ID: ${product.id ?? '-'} | ${product.categoryName ?? 'No category'} | \$${product.price.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                CatalogDialogs.showProductUpsertDialog(
                              context,
                              product: product,
                            ),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: product.id == null
                                ? null
                                : () => _confirmDeleteProduct(context, product),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty || _isSearching) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final result = await context.read<FruitProvider>().searchCatalog(query);
      if (!mounted) return;
      setState(() {
        _activeQuery = result.query;
        _searchedCategories = result.categories;
        _searchedProducts = result.products;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Search failed')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _activeQuery = '';
      _searchedCategories = const [];
      _searchedProducts = const [];
    });
  }

  Future<void> _confirmDeleteCategory(
      BuildContext context, CategoryModel category) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete Category'),
            content: Text('Delete "${category.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete || category.id == null) return;
    if (!context.mounted) return;

    final success =
        await context.read<FruitProvider>().deleteCategory(category.id!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(success ? 'Category deleted' : 'Failed to delete category')),
    );
  }

  Future<void> _showCategoryActions(
      CategoryModel category, Offset position) async {
    final action = await showGeneralDialog<String>(
      context: context,
      barrierLabel: 'Category actions',
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

    if (!mounted || action == null) return;
    if (action == 'edit') {
      CatalogDialogs.showCategoryUpsertDialog(context, category: category);
      return;
    }
    if (action == 'delete') {
      _confirmDeleteCategory(context, category);
    }
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

  Future<void> _confirmDeleteProduct(
      BuildContext context, FruitModel product) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text('Delete "${product.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete || product.id == null) return;
    if (!context.mounted) return;

    final success =
        await context.read<FruitProvider>().deleteProduct(product.id!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(success ? 'Product deleted' : 'Failed to delete product')),
    );
  }
}
