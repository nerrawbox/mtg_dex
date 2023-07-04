// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtg_dex/model/card_result/card_result.dart';
import 'package:mtg_dex/pages/detail_card.dart';
import 'package:mtg_dex/providers/service_provider.dart';

class CardResultList extends ConsumerWidget {
  const CardResultList({super.key, required this.searchText});

  final String searchText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var data = ref.watch(searchCardsProvider(searchText));

    return Expanded(
      child: data.when(
        data: (data) {
          List<CardModel> cardList = data.map((e) => e).toList();

          if (cardList.isNotEmpty) {
            return _renderCard(cardList);
          }

          return Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              'Start searching for amazing cards!',
              style: GoogleFonts.roboto(
                color: Colors.white38,
                fontSize: 18,
              ),
            ),
          );
        },
        error: (err, s) => Text(err.toString()),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _loadBackCard() {
    return Image.asset(
      'lib/images/mtg_back_sm.png',
      fit: BoxFit.cover,
      scale: 1,
    );
  }

  Widget _getCachedImage(String? uri) {
    if (uri == null) return const Icon(Icons.error);

    return CachedNetworkImage(
      imageUrl: uri,
      placeholder: (context, url) => _loadBackCard(),
      errorWidget: (context, url, error) => Text(error.toString()),
    );
  }

  Widget _renderCard(List<CardModel> cards) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          if (cards[index].imageUris == null) return const SizedBox();

          return Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: InkWell(
                onTap: () {
                  //navigate to full card detail page here...
                  CardModel selectedCard = cards[index];

                  // save the selected card here to show on recent search

                  final artCrop = cards[index].imageUris?.artCrop;
                  final normal = cards[index].imageUris?.normal ?? '';

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailCard(
                        card: selectedCard,
                        cachedNetworkImage: _getCachedImage(artCrop),
                        imageUri: normal,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'card:${cards[index].id}',
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _getCachedImage(cards[index].imageUris?.normal),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
