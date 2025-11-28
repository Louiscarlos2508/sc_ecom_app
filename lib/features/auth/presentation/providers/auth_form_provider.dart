import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier pour l'état du formulaire de connexion
class LoginObscurePasswordNotifier extends Notifier<bool> {
  @override
  bool build() => true;
}

/// Provider pour l'état du formulaire de connexion
final loginObscurePasswordProvider =
    NotifierProvider<LoginObscurePasswordNotifier, bool>(
  () => LoginObscurePasswordNotifier(),
);

/// Notifier pour l'état du formulaire d'inscription - mot de passe
class RegisterObscurePasswordNotifier extends Notifier<bool> {
  @override
  bool build() => true;
}

/// Notifier pour l'état du formulaire d'inscription - confirmation
class RegisterObscureConfirmPasswordNotifier extends Notifier<bool> {
  @override
  bool build() => true;
}

/// Notifier pour la ville sélectionnée
class RegisterSelectedCityNotifier extends Notifier<String?> {
  @override
  String? build() => null;
}

/// Providers pour l'état du formulaire d'inscription
final registerObscurePasswordProvider =
    NotifierProvider<RegisterObscurePasswordNotifier, bool>(
  () => RegisterObscurePasswordNotifier(),
);

final registerObscureConfirmPasswordProvider =
    NotifierProvider<RegisterObscureConfirmPasswordNotifier, bool>(
  () => RegisterObscureConfirmPasswordNotifier(),
);

final registerSelectedCityProvider =
    NotifierProvider<RegisterSelectedCityNotifier, String?>(
  () => RegisterSelectedCityNotifier(),
);
