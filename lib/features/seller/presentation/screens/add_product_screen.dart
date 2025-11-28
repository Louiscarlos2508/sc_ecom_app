import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/product.dart';

/// Écran d'ajout de produit (vendeur)
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _tradeDescriptionController = TextEditingController();
  final List<String> _imageUrls = [];
  bool _isSecondHand = false;
  bool _isTradable = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tradeDescriptionController.dispose();
    super.dispose();
  }

  void _addImage() {
    // TODO: Implémenter la sélection d'images (image_picker)
    setState(() {
      _imageUrls.add('https://picsum.photos/300/300?random=${_imageUrls.length}');
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_imageUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez ajouter au moins une image'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // TODO: Sauvegarder le produit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produit ajouté avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Ajouter un produit'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images
              Text(
                'Images du produit',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (_imageUrls.isEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.textSecondary),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _addImage,
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter une image'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ..._imageUrls.asMap().entries.map((entry) {
                      final index = entry.key;
                      final url = entry.value;
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.textSecondary),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              color: AppColors.error,
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ],
                      );
                    }),
                    if (_imageUrls.length < 10)
                      GestureDetector(
                        onTap: _addImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.textSecondary,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 32,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 24),
              // Nom
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du produit *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du produit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Prix
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Prix (FCFA) *',
                  border: OutlineInputBorder(),
                  suffixText: 'FCFA',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Prix invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // État du produit
              Text(
                'État du produit',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Produit d\'occasion (Seconde main)'),
                subtitle: const Text(
                  'Cochez si le produit est d\'occasion',
                ),
                value: _isSecondHand,
                onChanged: (value) {
                  setState(() {
                    _isSecondHand = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
              const SizedBox(height: 24),
              // Troc
              SwitchListTile(
                title: const Text('Autoriser le troc'),
                subtitle: const Text(
                  'Permettre aux clients de proposer un troc',
                ),
                value: _isTradable,
                onChanged: (value) {
                  setState(() {
                    _isTradable = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
              if (_isTradable) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tradeDescriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description pour le troc (optionnel)',
                    hintText: 'Ex: Accepte troc contre téléphone iPhone...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Bouton soumettre
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Publier le produit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

