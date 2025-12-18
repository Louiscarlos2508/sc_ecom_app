# Architecture ECONOMAX 🇧🇫

## Structure du projet

Le projet suit une architecture **User-Type-First** organisée par rôle d'utilisateur (client, vendeur, admin) avec séparation des couches (data/domain/presentation).

```
lib/
├── features/                    # Features organisées par type d'utilisateur
│   ├── auth/                   # Authentification (partagé)
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── client/                 # Module client
│   │   ├── address/           # Gestion des adresses
│   │   ├── cart/              # Panier
│   │   ├── coupon/            # Codes promo
│   │   ├── favorite/          # Favoris
│   │   ├── help/              # Aide
│   │   ├── history/           # Historique
│   │   ├── home/              # Accueil
│   │   ├── navigation/        # Navigation principale
│   │   ├── notification/      # Notifications
│   │   ├── orders/            # Commandes
│   │   ├── payment/           # Paiement
│   │   ├── profile/           # Profil
│   │   ├── referral/          # Parrainage
│   │   ├── search/            # Recherche
│   │   └── suggestion/        # Suggestions
│   │       ├── data/          # Sources de données
│   │       ├── domain/        # Logique métier
│   │       └── presentation/  # UI (screens, widgets, providers)
│   │
│   ├── seller/                 # Module vendeur
│   │   ├── company/           # Informations entreprise
│   │   ├── dashboard/         # Tableau de bord
│   │   ├── navigation/        # Navigation vendeur
│   │   ├── orders/            # Commandes vendeur
│   │   ├── products/          # Gestion produits
│   │   └── trades/            # Gestion trocs
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │
│   └── admin/                  # Module admin
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/                      # Code partagé
    ├── core/                   # Composants de base partagés
    │   ├── constants/         # Constantes
    │   ├── data/              # Données mock, services de base
    │   ├── models/            # Modèles partagés (Product, Order, User, etc.)
    │   ├── services/          # Services partagés (API, storage)
    │   ├── theme/             # Thème et couleurs
    │   │   ├── app_colors.dart
    │   │   └── app_theme.dart
    │   ├── utils/             # Utilitaires (validators, formatters, etc.)
    │   └── widgets/           # Widgets réutilisables
    │
    └── features/               # Features complètes partagées
        ├── product/           # Module produit (partagé client/vendeur)
        └── troc/              # Module troc (partagé client/vendeur)
            ├── data/
            ├── domain/
            └── presentation/
```

## Principes d'architecture

### User-Type-First
L'organisation priorise le regroupement par type d'utilisateur :
- **`features/client/`** : Toutes les fonctionnalités client
- **`features/seller/`** : Toutes les fonctionnalités vendeur
- **`features/admin/`** : Fonctionnalités admin
- **`features/auth/`** : Authentification partagée

### Clean Architecture
Chaque module suit la séparation en 3 couches :
- **`data/`** : Sources de données (API, cache local, repositories implémentations)
- **`domain/`** : Logique métier pure (entities, use cases, repository interfaces)
- **`presentation/`** : UI (screens, widgets, providers/state management)

### Shared Code Organization
- **`shared/core/`** : Composants primitifs réutilisables (models, widgets, utils, theme)
- **`shared/features/`** : Features complètes partagées entre plusieurs types d'utilisateurs (product, troc)

### State Management
- **Riverpod 2.x** pour la gestion d'état
- **Notifier/AsyncNotifier** pour les providers
- Providers dans `presentation/providers/`

## Règles de développement

### Imports
- **Utiliser des imports de package** : `package:economax/...`
- **Éviter les imports relatifs** pour les imports cross-module

### Limites de lignes
- **Screen/Page** : max 200 lignes
- **Widget UI** : max 150 lignes → split obligatoire sinon

### Couleurs
- **Interdit** : couleurs en dur
- **Obligatoire** : utiliser `AppColors` partout

### Prix
- **Format** : `1 500 FCFA` (espacement + " FCFA" à la fin)
- **Widget** : utiliser `PriceFormatter` pour le formatage

### Padding & Spacing
- Padding autorisés : 16, 20, 24, 32 uniquement
- `Gap()` obligatoire dans Column/Row

### Const
- `const` partout où c'est possible pour optimiser les rebuilds

## Nom du projet

**ECONOMAX** - E-commerce 100% burkinabè (Ouagadougou, Bobo, Koudougou & partout)
