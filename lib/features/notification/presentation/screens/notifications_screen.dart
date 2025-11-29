import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/trade.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../troc/presentation/providers/trade_provider.dart';

/// Fonction helper pour formater le temps
String _formatTime(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays == 0) {
    if (difference.inHours == 0) {
      return 'Il y a ${difference.inMinutes} min';
    }
    return 'Il y a ${difference.inHours} h';
  } else if (difference.inDays == 1) {
    return 'Hier';
  } else if (difference.inDays < 7) {
    return 'Il y a ${difference.inDays} jours';
  } else {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Écran des notifications ECONOMAX
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final allTrades = ref.watch(tradeProvider);
    
    // Pour les clients : notifications sur les retours de leurs propositions de troc
    // Pour les vendeurs : notifications sur les propositions reçues
    final notifications = <Map<String, dynamic>>[];
    
    if (user != null) {
      if (user.isSeller) {
        // Vendeur : notifications sur les propositions reçues
        final receivedTrades = allTrades
            .where((trade) => trade.sellerId == user.id && trade.status == TradeStatus.pending)
            .toList();
        
        for (final trade in receivedTrades) {
          notifications.add({
            'id': 'trade_${trade.id}',
            'title': 'Nouvelle proposition de troc',
            'message': 'Vous avez reçu une nouvelle proposition de troc',
            'time': _formatTime(trade.createdAt),
            'isRead': false,
            'type': 'trade',
            'tradeId': trade.id,
          });
        }
      } else {
        // Client : notifications sur les retours de ses propositions
        final myTrades = allTrades
            .where((trade) => trade.buyerId == user.id)
            .toList();
        
        for (final trade in myTrades) {
          if (trade.status == TradeStatus.accepted) {
            notifications.add({
              'id': 'trade_accepted_${trade.id}',
              'title': 'Proposition acceptée',
              'message': 'Votre proposition de troc a été acceptée !',
              'time': _formatTime(trade.createdAt),
              'isRead': false,
              'type': 'trade',
              'tradeId': trade.id,
            });
          } else if (trade.status == TradeStatus.rejected) {
            notifications.add({
              'id': 'trade_rejected_${trade.id}',
              'title': 'Proposition refusée',
              'message': 'Votre proposition de troc a été refusée',
              'time': _formatTime(trade.createdAt),
              'isRead': false,
              'type': 'trade',
              'tradeId': trade.id,
            });
          }
        }
      }
      
      // Ajouter d'autres types de notifications (commandes, promotions, etc.)
      notifications.addAll([
        {
          'id': 'promo_1',
          'title': 'Promotion',
          'message': 'Nouvelle promotion sur les produits électroniques',
          'time': 'Il y a 2 h',
          'isRead': true,
          'type': 'promotion',
        },
      ]);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Marquer toutes comme lues
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toutes les notifications ont été marquées comme lues'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              'Tout marquer',
              style: TextStyle(color: AppColors.onPrimary),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _EmptyNotifications()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(
                  title: notification['title'] as String,
                  message: notification['message'] as String,
                  time: notification['time'] as String,
                  isRead: notification['isRead'] as bool,
                  type: notification['type'] as String,
                  onTap: () {
                    // Naviguer vers la page correspondante selon le type
                    final type = notification['type'] as String;
                    if (type == 'trade') {
                      // TODO: Naviguer vers l'écran de troc correspondant
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Notification: ${notification['title']}'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Notification: ${notification['title']}'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

/// Carte de notification
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
    required this.onTap,
  });

  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String type;
  final VoidCallback onTap;

  IconData _getIcon() {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'trade':
        return Icons.swap_horiz;
      case 'promotion':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case 'order':
        return AppColors.success;
      case 'trade':
        return AppColors.warning;
      case 'promotion':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 0 : 2,
      color: isRead ? AppColors.surface : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead
              ? AppColors.textSecondary.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.3),
          width: isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getIconColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIcon(),
                  color: _getIconColor(),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: isRead
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// État vide
class _EmptyNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune notification',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore de notifications',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

