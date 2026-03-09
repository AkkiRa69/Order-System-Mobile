import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_image.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:provider/provider.dart';

class SearchTapPage extends StatefulWidget {
  const SearchTapPage({super.key});

  @override
  State<SearchTapPage> createState() => _SearchTapPageState();
}

class _SearchTapPageState extends State<SearchTapPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;
  List<FruitModel> _searchResults = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FruitProvider>();
    final query = _searchController.text.trim();
    final products = query.isEmpty ? provider.fruitList : _searchResults;

    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      body: _buildBody(context, products),
    );
  }

  Widget _buildBody(BuildContext context, List<FruitModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColor.appBarColor,
          padding: const EdgeInsets.only(bottom: 17),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: AppColor.bodyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(3),
                    margin: const EdgeInsets.symmetric(horizontal: 17),
                    child: TextFormField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 18),
                      focusNode: _focusNode,
                      onChanged: _onQueryChanged,
                      decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          "assets/icons/search.png",
                          color: const Color(0xFF868889),
                        ),
                        hintText: "Search keywords...",
                        suffixIcon: Image.asset(
                          "assets/icons/filter.png",
                          color: const Color(0xFF868889),
                        ),
                        hintStyle: const TextStyle(color: Color(0xFF868889)),
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: (value) {
                        _onQueryChanged(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isSearching) const LinearProgressIndicator(minHeight: 2),
        Padding(
          padding: const EdgeInsets.fromLTRB(17, 14, 17, 8),
          child: Text(
            'Products (${products.length})',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: products.isEmpty
              ? const Center(child: Text('No products found'))
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: AppImage(
                              path: product.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          product.categoryName ?? 'No category',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = const [];
      });
      return;
    }

    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final result = await context.read<FruitProvider>().searchCatalog(query);
        if (!mounted || _searchController.text.trim() != query) return;
        setState(() {
          _searchResults = result.products;
          _isSearching = false;
        });
      } catch (_) {
        if (!mounted || _searchController.text.trim() != query) return;
        setState(() {
          _searchResults = const [];
          _isSearching = false;
        });
      }
    });
  }
}
