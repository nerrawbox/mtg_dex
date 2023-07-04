import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mtg_dex/model/card_result/card_oracle_result.dart';
import 'package:mtg_dex/model/card_result/card_result.dart';
import 'package:mtg_dex/services/api_service/iapi_service.dart';
import 'dart:convert';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService implements IApiService {
  final _baseUrl = 'https://api.scryfall.com';

  @override
  Future<List<CardModel>> searchCards(String entity) async {
    if (entity.isEmpty) return List.empty();

    var response = await http.get(Uri.parse(
        '$_baseUrl/cards/search?q=$entity&unique=prints&order=released'));

    if (response.statusCode >= 200 && response.statusCode < 400) {
      var data = json.decode(response.body);

      var cards = CardResultModel.fromJson(data).data;

      return cards ?? List.empty();
    } else {
      return List.empty();
    }
  }

  @override
  Future<List<CardOracle>> getCardByOracleId(String oracleId) async {
    if (oracleId.isEmpty) return List.empty();

    String url =
        '$_baseUrl/cards/search?order=released&q=oracleid%3A$oracleId&unique=prints';
    var response = await http.get(Uri.parse(url));

    debugPrint(url);

    if (response.statusCode >= 200 && response.statusCode < 400) {
      var data = json.decode(response.body);

      debugPrint(data.toString());

      var cards = CardOracleResult.fromJson(data).data;

      return cards ?? List.empty();
    } else {
      return List.empty();
    }
  }
}
