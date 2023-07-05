// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtg_dex/components/card_result_list.dart';
import 'package:mtg_dex/providers/service_provider.dart';

class SearchCard extends ConsumerWidget {
  const SearchCard({super.key});

  // _onTextFieldChange(String value) {
  //   if (value.length > 3) debugPrint(value);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchText = ref.watch(searchTextProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.menu,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Text(
              'MTG:Dex',
              style: GoogleFonts.bebasNeue(fontSize: 60),
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              onChanged: (value) {
                if (value.length > 2 || value.isEmpty) {
                  ref.read(searchTextProvider.notifier).state = value;
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search a Card Name...',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
          CardResultList(searchText: searchText),
        ],
      ),
    );
  }
}
