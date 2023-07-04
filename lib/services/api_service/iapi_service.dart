import 'package:mtg_dex/model/card_result/card_oracle_result.dart';
import 'package:mtg_dex/model/card_result/card_result.dart';

abstract class IApiService {
  Future<List<CardModel>> searchCards(String entity);

  Future<List<CardOracle>> getCardByOracleId(String oracleId);
}
