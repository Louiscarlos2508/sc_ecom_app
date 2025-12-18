# ECONOMAX

**E-commerce 100% burkinabe** - Plateforme de vente en ligne pour Ouagadougou, Bobo, Koudougou & partout

## Description

ECONOMAX est une application mobile e-commerce developpee avec Flutter, concue specifiquement pour le marche burkinabe. La plateforme permet aux utilisateurs d'acheter et de vendre des produits, avec un systeme de troc integre et des fonctionnalites adaptees aux besoins locaux.

## Architecture

Le projet suit une architecture **User-Type-First** organisee par role d'utilisateur avec separation Clean Architecture (data/domain/presentation).

### Structure principale

- **`features/client/`** : Module client (panier, commandes, profil, etc.)
- **`features/seller/`** : Module vendeur (dashboard, produits, ventes, etc.)
- **`features/admin/`** : Module admin (gestion plateforme)
- **`features/auth/`** : Authentification (partagee)
- **`shared/core/`** : Composants de base partages (models, widgets, utils, theme)
- **`shared/features/`** : Features completes partagees (product, troc)

Voir [ARCHITECTURE.md](./ARCHITECTURE.md) pour plus de details.

## Demarrage

### Pre-requis

- Flutter SDK (derniere version stable)
- Dart SDK
- Android Studio / VS Code avec extensions Flutter
- Android SDK (pour developpement Android)
- Xcode (pour developpement iOS - macOS uniquement)

### Installation

1. **Cloner le repository**
   ```bash
   git clone <repository-url>
   cd sc_ecom_app
   ```

2. **Installer les dependances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## Technologies utilisees

- **Flutter** : Framework de developpement cross-platform
- **Dart** : Langage de programmation
- **Riverpod 2.x** : Gestion d'etat reactive
- **Material Design 3** : Design system

## Structure des modules

Chaque module suit la structure Clean Architecture :

```
module_name/
├── data/              # Sources de donnees (API, repositories implementations)
├── domain/            # Logique metier (entities, use cases, repository interfaces)
└── presentation/      # UI (screens, widgets, providers)
    ├── screens/
    ├── widgets/
    └── providers/
```

## Regles de developpement

### Imports
- Utiliser des imports de package : `package:economax/...`
- Eviter les imports relatifs pour les imports cross-module

### Code Style
- Respecter les conventions Dart/Flutter
- Utiliser `const` partout ou c'est possible
- Limiter la taille des fichiers (max 200 lignes pour les screens, 150 pour les widgets)

### Couleurs & Theme
- Utiliser `AppColors` pour toutes les couleurs (pas de couleurs en dur)
- Suivre le theme Material Design 3

### Formatage des prix
- Format : `1 500 FCFA` (avec espacement et " FCFA" a la fin)
- Utiliser `PriceFormatter` pour le formatage

Voir [ARCHITECTURE.md](./ARCHITECTURE.md) pour les regles completes.

## Contribution

1. Creer une branche pour votre fonctionnalite (`git checkout -b feature/ma-fonctionnalite`)
2. Committer vos changements (`git commit -m 'Ajout de ma fonctionnalite'`)
3. Pousser vers la branche (`git push origin feature/ma-fonctionnalite`)
4. Ouvrir une Pull Request

## Licence

Ce projet est prive et proprietaire d'ECONOMAX.

## Developpement

Developpe par **Carlos Simpore** de **Scalario** pour **ECONOMAX**.

---

**ECONOMAX** - E-commerce 100% burkinabe
