// lib/widgets/nft_listing_card.dart
import 'package:flutter/material.dart';
import '../models/nft_listing_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NftListingCard extends StatelessWidget {
  final NftListing listing;
  final VoidCallback onTap;

  const NftListingCard({
    Key? key,
    required this.listing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat("###,##0.00##", "en_US");

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'nft_image_${listing.id}', // Unique tag for Hero animation
                child: Image.network(
                  listing.nftImageUrl ?? 'https://via.placeholder.com/300/1E1E1E/FFFFFF?Text=NFT',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceVariant,
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.image),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.collectionName ?? 'Unknown Collection',
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    listing.nftName ?? 'Unnamed NFT',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: theme.textTheme.bodySmall,
                      ),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.ethereum, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            numberFormat.format(listing.priceInEth),
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
