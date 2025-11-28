import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Écran de gestion des données administratives vendeur
class SellerCompanyInfoScreen extends ConsumerStatefulWidget {
  const SellerCompanyInfoScreen({super.key});

  @override
  ConsumerState<SellerCompanyInfoScreen> createState() =>
      _SellerCompanyInfoScreenState();
}

class _SellerCompanyInfoScreenState
    extends ConsumerState<SellerCompanyInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _termsController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyDescriptionController.dispose();
    _companyAddressController.dispose();
    _companyEmailController.dispose();
    _companyPhoneController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  void _loadData() {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _companyNameController.text = user.companyName ?? '';
      _companyDescriptionController.text = user.companyDescription ?? '';
      _companyAddressController.text = user.companyAddress ?? '';
      _companyEmailController.text = user.companyEmail ?? '';
      _companyPhoneController.text = user.companyPhone ?? '';
      _termsController.text = user.termsAndConditions ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Sauvegarder les données administratives
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informations enregistrées avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Informations entreprise'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ces informations seront visibles par tous les clients',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.success,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Nom de l'entreprise
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'entreprise *',
                  hintText: 'Ex: Traoré & Fils SARL',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'entreprise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _companyDescriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Présentation de la société *',
                  hintText: 'Décrivez votre entreprise, son histoire, ses valeurs...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une présentation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Adresse
              TextFormField(
                controller: _companyAddressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Coordonnées géographiques *',
                  hintText: 'Adresse complète (quartier, ville, etc.)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Email entreprise
              TextFormField(
                controller: _companyEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email de l\'entreprise *',
                  hintText: 'contact@entreprise.bf',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'email';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Téléphone entreprise
              TextFormField(
                controller: _companyPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Contact téléphonique entreprise *',
                  hintText: '+226 XX XX XX XX',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le numéro de téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Conditions générales de vente
              TextFormField(
                controller: _termsController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Conditions générales de vente *',
                  hintText: 'Décrivez vos conditions de vente, livraison, retour...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.gavel),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer les conditions générales';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Bouton sauvegarder
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
                    'Enregistrer les informations',
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

