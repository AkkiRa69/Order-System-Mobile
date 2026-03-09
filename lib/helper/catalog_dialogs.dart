import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_image.dart';
import 'package:grocery_store/model/category_model.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CatalogDialogs {
  static Future<void> showCreateCategoryDialog(BuildContext context) {
    return showCategoryUpsertDialog(context);
  }

  static Future<void> showCategoryUpsertDialog(
    BuildContext context, {
    CategoryModel? category,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _CategoryUpsertScreen(category: category),
      ),
    );
  }

  static Future<void> showProductUpsertDialog(
    BuildContext context, {
    FruitModel? product,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _ProductUpsertScreen(product: product),
      ),
    );
  }
}

class _CategoryUpsertScreen extends StatefulWidget {
  const _CategoryUpsertScreen({this.category});

  final CategoryModel? category;

  @override
  State<_CategoryUpsertScreen> createState() => _CategoryUpsertScreenState();
}

class _CategoryUpsertScreenState extends State<_CategoryUpsertScreen> {
  final _picker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _saving = false;

  bool get _isUpdate => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.category?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selectedImage = image;
      _selectedImageBytes = bytes;
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    if (!_isUpdate && _selectedImage == null) return;

    setState(() => _saving = true);
    final provider = context.read<FruitProvider>();
    final success = _isUpdate
        ? await provider.updateCategory(
            id: widget.category!.id!,
            name: name,
            description: _descriptionController.text.trim(),
            imageFile: _selectedImage,
          )
        : await provider.createCategory(
            name: name,
            description: _descriptionController.text.trim(),
            imageFile: _selectedImage,
          );

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(success ? 'Category saved' : 'Failed to save category')),
    );
    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accent = Color(0xFF1F7A6B);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(_isUpdate ? 'Update Category' : 'Add Category'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.close),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
              ),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF2EF), Color(0xFFF8FAFB)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              _isUpdate
                  ? 'Refresh your category details'
                  : 'Create a new category',
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF28343F),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Give it a clear name, short description, and a standout image.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF657484),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(label: 'Category name'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: _inputDecoration(label: 'Description'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.image_outlined,
                          color: Color(0xFF465461)),
                      const SizedBox(width: 8),
                      const Text(
                        'Category image',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF273341),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload_rounded),
                        label: Text(
                          _selectedImage == null ? 'Choose' : 'Change',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedImage?.name ?? 'No image selected',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF6A7785)),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedImageBytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(
                        _selectedImageBytes!,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (_selectedImageBytes == null)
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F5F8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFD3DBE3)),
                      ),
                      child: const Center(
                        child: Text(
                          'Upload a category banner',
                          style: TextStyle(color: Color(0xFF728192)),
                        ),
                      ),
                    ),
                  if (_isUpdate &&
                      widget.category!.icon.isNotEmpty &&
                      _selectedImageBytes == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current image',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF778393),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 140,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AppImage(
                                path: widget.category!.icon,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD7DFE8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD7DFE8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1F7A6B), width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class _ProductUpsertScreen extends StatefulWidget {
  const _ProductUpsertScreen({this.product});

  final FruitModel? product;

  @override
  State<_ProductUpsertScreen> createState() => _ProductUpsertScreenState();
}

class _ProductUpsertScreenState extends State<_ProductUpsertScreen> {
  final _picker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _saving = false;
  String? _selectedCategory;

  bool get _isUpdate => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selectedImage = image;
      _selectedImageBytes = bytes;
    });
  }

  Future<void> _save(List<CategoryModel> categories) async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final categoryName = _selectedCategory ??
        widget.product?.categoryName ??
        categories.first.name;

    if (name.isEmpty || price == null) return;
    if (!_isUpdate && _selectedImage == null) return;

    final payload = FruitModel(
      id: widget.product?.id,
      name: name,
      description: _descriptionController.text.trim(),
      image: widget.product?.image ?? 'assets/icons/grocery.png',
      price: price,
      stock: stock,
      categoryName: categoryName,
    );

    setState(() => _saving = true);
    final provider = context.read<FruitProvider>();
    final success = _isUpdate
        ? await provider.updateProduct(payload, imageFile: _selectedImage)
        : await provider.createProduct(payload, imageFile: _selectedImage);

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(success ? 'Product saved' : 'Failed to save product')),
    );
    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<FruitProvider>().categories;
    if (categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Product')),
        body: const Center(child: Text('Add a category first')),
      );
    }

    _selectedCategory ??= widget.product?.categoryName ?? categories.first.name;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F9),
        elevation: 0,
        title: Text(_isUpdate ? 'Update Product' : 'Add Product'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      size: 20,
                      color: Color(0xFF6CC51D),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Product Image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload_outlined),
                      label: const Text('Choose'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: _buildImagePreview(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedImage?.name ??
                      (_isUpdate
                          ? 'Current product image'
                          : 'No image selected'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildSectionCard(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration(
                    label: 'Name',
                    icon: Icons.shopping_bag_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  minLines: 2,
                  decoration: _fieldDecoration(
                    label: 'Description',
                    icon: Icons.notes_outlined,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildSectionCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _fieldDecoration(
                          label: 'Price',
                          icon: Icons.attach_money_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration(
                          label: 'Stock',
                          icon: Icons.inventory_2_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showCategoryPicker(categories),
                  child: InputDecorator(
                    decoration: _fieldDecoration(
                      label: 'Category',
                      icon: Icons.category_outlined,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedCategory ?? 'Select category',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _saving ? null : () => _save(categories),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6CC51D),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(_isUpdate ? Icons.check_rounded : Icons.add_rounded),
            label: Text(
              _saving
                  ? 'Saving...'
                  : (_isUpdate ? 'Update Product' : 'Create Product'),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F8FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF6CC51D),
          width: 1.3,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        fit: BoxFit.cover,
      );
    }

    if (_isUpdate && (widget.product?.image.isNotEmpty ?? false)) {
      return AppImage(path: widget.product!.image, fit: BoxFit.cover);
    }

    return Container(
      color: const Color(0xFFF7F8FB),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.image_not_supported_outlined,
            size: 34,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'No image selected',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryPicker(List<CategoryModel> categories) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 420),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 4,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.category_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Choose Category',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category.name == _selectedCategory;
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        leading: Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: isSelected
                              ? const Color(0xFF6CC51D)
                              : Colors.grey.shade500,
                          size: 20,
                        ),
                        title: Text(
                          category.name,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, category.name),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    setState(() => _selectedCategory = selected);
  }
}
