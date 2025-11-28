# Architecture ECONOMAX 🇧🇫

## Structure du projet

```
lib/
├── features/                    # Features organisées par domaine métier
│   ├── auth/                   # Authentification
│   │   ├── data/              # Sources de données (API, local)
│   │   ├── domain/            # Logique métier (entities, repositories)
│   │   └── presentation/      # UI (screens, widgets)
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           └── register_screen.dart
│   │
│   ├── home/                   # Accueil
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart
│   │
│   ├── product/                # Produits
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── product_detail_screen.dart
│   │
│   ├── cart/                   # Panier
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── cart_screen.dart
│   │
│   ├── order/                  # Commandes
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── order_list_screen.dart
│   │
│   ├── seller/                 # Dashboard vendeur burkinabè
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── seller_dashboard_screen.dart
│   │
│   ├── admin/                  # Dashboard équipe ECONOMAX
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── admin_dashboard_screen.dart
│   │
│   ├── search/                 # Recherche
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── search_screen.dart
│   │
│   ├── referral/              # Système codes parrainage
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── referral_screen.dart
│   │
│   └── troc/                  # Vrai troc à la burkinabè
│       ├── data/
│       ├── domain/
│       └── presentation/
│           └── screens/
│               └── troc_screen.dart
│
└── shared/                     # Code partagé entre features
    ├── theme/                 # Thème et couleurs
    │   ├── app_colors.dart    # Palette officielle ECONOMAX
    │   └── app_theme.dart     # Configuration du thème
    │
    ├── widgets/               # Widgets réutilisables
    │   └── fcfa_price.dart   # Widget pour afficher prix en FCFA
    │
    ├── utils/                 # Utilitaires
    │   └── price_formatter.dart
    │
    ├── models/                # Modèles partagés
    ├── services/              # Services partagés (API, storage)
    └── constants/             # Constantes
```

## Principes d'architecture

### Feature-First
Chaque feature est autonome avec sa propre structure :
- `data/` : Sources de données (API, cache local)
- `domain/` : Logique métier pure (entities, use cases, repositories interfaces)
- `presentation/` : UI (screens, widgets, providers)

### Clean Architecture
Séparation claire des responsabilités :
- **Presentation** : UI uniquement, pas de logique métier
- **Domain** : Logique métier pure, indépendante de Flutter
- **Data** : Implémentation des repositories, accès aux données

### State Management
- **Riverpod 2.x** uniquement
- **AsyncNotifier** pour les appels API
- **freezed** pour les modèles immutables

## Règles de développement

### Limites de lignes
- **Screen/Page** : max 200 lignes
- **Widget UI** : max 150 lignes → split obligatoire sinon

### Couleurs
- **Interdit** : couleurs en dur
- **Obligatoire** : utiliser `AppColors()` partout

### Prix
- **Format** : `1 500 FCFA` (espacement + " FCFA" à la fin)
- **Widget** : utiliser `FcfaPrice` widget

### Padding & Spacing
- Padding autorisés : 16, 20, 24, 32 uniquement
- `Gap()` obligatoire dans Column/Row

### Const
- `const` partout où c'est possible

## Nom du projet

**ECONOMAX** - E-commerce 100% burkinabè

