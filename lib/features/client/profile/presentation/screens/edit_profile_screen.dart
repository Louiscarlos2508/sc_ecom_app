import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';

/// Écran de modification du profil
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({
    super.key,
    this.field,
  });

  final String? field; // 'phone', 'email', 'name'

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  late String _label;
  late String _hint;
  late IconData _icon;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    
    switch (widget.field) {
      case 'phone':
        _label = 'Téléphone';
        _hint = '+226 XX XX XX XX';
        _icon = Icons.phone;
        _controller = TextEditingController(text: user?.phone ?? '');
        break;
      case 'email':
        _label = 'Email';
        _hint = 'exemple@email.com';
        _icon = Icons.email;
        _controller = TextEditingController(text: user?.email ?? '');
        break;
      case 'city':
        _label = 'Ville';
        _hint = 'Votre ville';
        _icon = Icons.location_city;
        _controller = TextEditingController(text: user?.city ?? '');
        break;
      case 'name':
      default:
        _label = 'Nom complet';
        _hint = 'Votre nom complet';
        _icon = Icons.person;
        _controller = TextEditingController(text: user?.name ?? '');
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    // Simuler la sauvegarde
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modification enregistrée avec succès'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text('Modifier $_label'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: _label,
                hintText: _hint,
                prefixIcon: Icon(_icon),
              ),
              keyboardType: widget.field == 'email'
                  ? TextInputType.emailAddress
                  : widget.field == 'phone'
                      ? TextInputType.phone
                      : TextInputType.text,
              inputFormatters: widget.field == 'phone'
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer $_label';
                }
                if (widget.field == 'email' && !value.contains('@')) {
                  return 'Email invalide';
                }
                if (widget.field == 'phone' && value.length < 8) {
                  return 'Numéro de téléphone invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Enregistrer',
                style: TextStyle(
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

