import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/models/delivery_address.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import '../providers/address_provider.dart';

/// Écran pour ajouter ou modifier une adresse
class AddEditAddressScreen extends ConsumerStatefulWidget {
  const AddEditAddressScreen({
    super.key,
    this.address,
  });

  final DeliveryAddress? address;

  @override
  ConsumerState<AddEditAddressScreen> createState() =>
      _AddEditAddressScreenState();
}

class _AddEditAddressScreenState
    extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _landmarkController;
  
  String _selectedCity = 'Ouagadougou';
  bool _isDefault = false;
  bool _isEditing = false;

  final List<String> _cities = [
    'Ouagadougou',
    'Bobo-Dioulasso',
    'Koudougou',
    'Ouahigouya',
    'Banfora',
    'Dédougou',
    'Kaya',
    'Tenkodogo',
    'Fada N\'gourma',
    'Dori',
    'Autre',
  ];

  final List<String> _labels = [
    'Maison',
    'Bureau',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.address != null;
    
    _labelController = TextEditingController(
      text: widget.address?.label ?? 'Maison',
    );
    _fullNameController = TextEditingController(
      text: widget.address?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.address?.phone ?? '',
    );
    _addressController = TextEditingController(
      text: widget.address?.address ?? '',
    );
    _landmarkController = TextEditingController(
      text: widget.address?.landmark ?? '',
    );
    _selectedCity = widget.address?.city ?? 'Ouagadougou';
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final address = DeliveryAddress(
      id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      label: _labelController.text,
      fullName: _fullNameController.text,
      phone: _phoneController.text,
      city: _selectedCity,
      address: _addressController.text,
      landmark: _landmarkController.text.isEmpty
          ? null
          : _landmarkController.text,
      isDefault: _isDefault,
    );

    final addressNotifier = ref.read(addressProvider.notifier);
    
    if (_isEditing) {
      addressNotifier.updateAddress(address);
    } else {
      addressNotifier.addAddress(address);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Adresse modifiée avec succès'
              : 'Adresse ajoutée avec succès',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text(_isEditing ? 'Modifier l\'adresse' : 'Nouvelle adresse'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Label
            DropdownButtonFormField<String>(
              value: _labelController.text,
              decoration: const InputDecoration(
                labelText: 'Type d\'adresse',
                prefixIcon: Icon(Icons.label),
              ),
              items: _labels.map((label) {
                return DropdownMenuItem(
                  value: label,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _labelController.text = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Nom complet
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Nom complet *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom complet';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Téléphone
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone *',
                prefixIcon: Icon(Icons.phone),
                hintText: '+226 XX XX XX XX',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre numéro de téléphone';
                }
                if (value.length < 8) {
                  return 'Numéro de téléphone invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Ville
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'Ville *',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCity = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Adresse
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse complète *',
                prefixIcon: Icon(Icons.home),
                hintText: 'Secteur, quartier, rue, numéro',
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre adresse';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Point de repère
            TextFormField(
              controller: _landmarkController,
              decoration: const InputDecoration(
                labelText: 'Point de repère (optionnel)',
                prefixIcon: Icon(Icons.place),
                hintText: 'Ex: Près de la mosquée, derrière le marché',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            // Adresse par défaut
            CheckboxListTile(
              title: const Text('Définir comme adresse par défaut'),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value ?? false;
                });
              },
              activeColor: AppColors.primary,
            ),
            const SizedBox(height: 32),
            // Bouton sauvegarder
            ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isEditing ? 'Modifier l\'adresse' : 'Enregistrer l\'adresse',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

