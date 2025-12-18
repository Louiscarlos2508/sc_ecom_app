import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/core/theme/app_colors.dart';
import '../../../../../shared/core/models/product.dart';
import '../../../../../shared/core/utils/validators.dart';
import '../../../../../shared/core/utils/security_utils.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/features/product/presentation/providers/product_provider.dart';

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
  final _minimumQuantityController = TextEditingController(text: '1');
  final _wholesalePriceController = TextEditingController();
  final List<String> _imageUrls = [];
  bool _isSecondHand = false;
  bool _isTradable = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tradeDescriptionController.dispose();
    _minimumQuantityController.dispose();
    _wholesalePriceController.dispose();
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

      final user = ref.read(currentUserProvider);
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vous devez être connecté'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Vérifier que l'utilisateur peut vendre
      if (!SecurityUtils.canSell(user)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              user.isWholesaler && !user.isWholesalerApproved
                  ? 'Votre compte grossiste est en attente d\'approbation'
                  : 'Vous n\'êtes pas autorisé à vendre',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Valider le prix
      final priceError = Validators.validatePrice(_priceController.text);
      if (priceError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(priceError),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final price = int.parse(_priceController.text);

      // Sanitizer les entrées
      final name = SecurityUtils.sanitizeInput(_nameController.text);
      final description = SecurityUtils.sanitizeInput(_descriptionController.text);
      final tradeDescription = _isTradable && _tradeDescriptionController.text.isNotEmpty
          ? SecurityUtils.sanitizeInput(_tradeDescriptionController.text)
          : null;

      final newProduct = Product(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        priceInFcfa: price,
        imageUrl: _imageUrls.isNotEmpty ? _imageUrls[0] : '',
        imageUrls: _imageUrls,
        sellerId: user.id,
        sellerName: user.name,
        city: user.city,
        isSecondHand: _isSecondHand,
        isVerifiedWholesaler: user.isWholesaler && user.isWholesalerApproved,
        isTradable: _isTradable,
        tradeDescription: tradeDescription,
      );

      ref.read(productProvider.notifier).addProduct(newProduct);

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
    final user = ref.watch(currentUserProvider);
    
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
                validator: Validators.validateProductName,
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
                validator: Validators.validateProductDescription,
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
                validator: Validators.validatePrice,
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
              // Options grossiste (si approuvé)
              Consumer(
                builder: (context, ref, _) {
                  final currentUser = ref.watch(currentUserProvider);
                  final isWholesalerApproved = currentUser?.isWholesaler == true && 
                      currentUser?.isWholesalerApproved == true;
                  
                  if (!isWholesalerApproved) {
                    return const SizedBox.shrink();
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Options Grossiste',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _minimumQuantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantité minimale de commande *',
                          hintText: 'Ex: 10 (minimum 10 unités)',
                          border: OutlineInputBorder(),
                          suffixText: 'unités',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Quantité minimale requise';
                          }
                          final qty = int.tryParse(value);
                          if (qty == null || qty < 1) {
                            return 'Quantité minimale doit être au moins 1';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _wholesalePriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Prix de gros (optionnel)',
                          hintText: 'Prix spécial pour commandes en gros',
                          border: OutlineInputBorder(),
                          suffixText: 'FCFA',
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final wholesale = int.tryParse(value);
                            if (wholesale == null || wholesale <= 0) {
                              return 'Prix de gros invalide';
                            }
                            final price = int.tryParse(_priceController.text);
                            if (price != null && wholesale >= price) {
                              return 'Le prix de gros doit être inférieur au prix normal';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
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

