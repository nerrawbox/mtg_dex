import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtg_dex/model/card_result/card_result.dart';
import 'package:mtg_dex/model/card_result/card_oracle_result.dart';
import 'package:mtg_dex/services/api_service/api_service.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

final searchCardsProvider = FutureProvider.family<List<CardModel>, String>(
  (ref, searchText) {
    return ref.watch(apiServiceProvider).searchCards(searchText);
  },
);

final getByCardOracleProvider = FutureProvider.family<List<CardOracle>, String>(
  (ref, oracleId) {
    return ref.watch(apiServiceProvider).getCardByOracleId(oracleId);
  },
);
