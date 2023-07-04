// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtg_dex/model/card_result/card_oracle_result.dart';
import 'package:mtg_dex/model/card_result/card_result.dart';
import 'package:mtg_dex/providers/service_provider.dart';

class DetailCard extends ConsumerWidget {
  const DetailCard({
    super.key,
    required this.card,
    required this.cachedNetworkImage,
    required this.imageUri,
  });

  final CardModel card;
  final Widget cachedNetworkImage;
  final String imageUri;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var oracleData = ref.watch(getByCardOracleProvider(card.oracleId ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          card.name ?? 'Card Detail',
          style: GoogleFonts.roboto(),
        ),
      ),
      body: _renderCard(context, oracleData),
    );
  }

  Widget _renderCard(BuildContext context, oracleData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'card:${card.id}',
          child: GestureDetector(
            onTap: () {
              if (imageUri.isEmpty) return;

              _previewCard(context, imageUri);
            },
            child: cachedNetworkImage,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.name ?? '',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
              Text(
                card.cmc.toString() == '0.0' ? '' : card.cmc.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            card.typeLine ?? '',
            style: GoogleFonts.roboto(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.oracleText ?? '',
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    wordSpacing: 4,
                    letterSpacing: .5,
                  ),
                ),

                // Show other variations here
                // use @card.oracleId
                // https://api.scryfall.com/cards/search?order=released&q=oracleid%3A33f52df8-4b44-4422-8b0a-37fead9c894b&unique=prints
                SizedBox(height: 16),
                Text(
                  'Other Variations',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
                Expanded(
                  child: _renderOracleCards(context, oracleData),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderOracleCards(
      BuildContext context, AsyncValue<List<CardOracle>> data) {
    return data.when(
      data: (data) {
        List<CardOracle> cardList = data.map((e) => e).toList();

        if (cardList.isNotEmpty) {
          return _renderCardOracle(context, cardList);
        }

        return Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 100),
          child: Text(
            '',
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
    );
  }

  Widget _renderCardOracle(BuildContext context, List<CardOracle> cards) {
    return ListView.builder(
      itemCount: cards.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (cards[index].id == card.id) return SizedBox();

        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _getCachedImage(context, cards[index].imageUris?.normal),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loadBackCard() {
    return Center(
      child: Image.asset(
        'lib/images/mtg_back_sm.png',
        fit: BoxFit.contain,
        scale: 1,
      ),
    );
  }

  _getCachedImage(BuildContext context, String? uri) {
    if (uri == null) return;

    final cachedNetworkImage = CachedNetworkImage(
      imageUrl: uri,
      placeholder: (context, url) => _loadBackCard(),
      errorWidget: (context, url, error) => Text(error.toString()),
    );

    return InkWell(
      onTap: () {
        debugPrint(uri);
        _previewCard(context, uri);
      },
      child: SizedBox(
        child: cachedNetworkImage,
      ),
    );
  }

  _previewCard(BuildContext context, String imageUrl) {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _getCachedImage(context, imageUrl),
              ),
            ],
          );
        });
  }
}
