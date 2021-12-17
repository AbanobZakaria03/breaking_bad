import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breaking/business_logic/cubit/characters_cubit.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/data/models/character.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context)
        .getCharacterQuotes(character.name);

    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              characterInfo(
                                  'Job : ', character.jobs.join(' / ')),
                              buildDivider(),
                              characterInfo('Appeared in : ',
                                  character.categoryForTwoSeries),
                              buildDivider(),
                              characterInfo('Seasons : ',
                                  character.appearanceOfSeasons.join(' / ')),
                              buildDivider(),
                              characterInfo(
                                  'Status : ', character.statusIfDeadOrAlive),
                              buildDivider(),
                              if (character
                                  .betterCallSaulAppearance.isNotEmpty) ...[
                                characterInfo(
                                    'Better Call Saul Seasons : ',
                                    character.betterCallSaulAppearance
                                        .join(' / ')),
                                buildDivider(),
                              ],
                              characterInfo(
                                  'Actor/Actress: ', character.actorName),
                              buildDivider(),
                              BlocBuilder<CharactersCubit, CharactersState>(
                                builder: (context, state) =>
                                    checkIfQuotesAreLoaded(state),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SliverList(
          //   delegate: SliverChildListDelegate(
          //     [
          //       Container(
          //         margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          //         padding: const EdgeInsets.all(8),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             characterInfo('Job : ', character.jobs.join(' / ')),
          //             buildDivider(310),
          //             characterInfo(
          //                 'Appeared in : ', character.categoryForTwoSeries),
          //             buildDivider(250),
          //             characterInfo('Seasons : ',
          //                 character.appearanceOfSeasons.join(' / ')),
          //             buildDivider(270),
          //             characterInfo('Status : ', character.statusIfDeadOrAlive),
          //             buildDivider(285),
          //             if (character.betterCallSaulAppearance.isNotEmpty) ...[
          //               characterInfo('Better Call Saul Seasons : ',
          //                   character.betterCallSaulAppearance.join(' / ')),
          //               buildDivider(150),
          //             ],
          //             characterInfo('Actor/Actress: ', character.actorName),
          //             buildDivider(230),
          //             BlocBuilder<CharactersCubit, CharactersState>(
          //               builder: (context, state) =>
          //                   checkIfQuotesAreLoaded(state),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      floating: true,
      // stretch: true,
      snap: false,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        // centerTitle: true,
        title: Text(
          character.nickName,
          style: const TextStyle(color: MyColors.myWhite),
          // textAlign: TextAlign.start,
        ),
        background: Hero(
          tag: character.charId,
          child: CachedNetworkImage(
            imageUrl: character.image,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -1),
          ),
          // child: Image.network(
          //   character.image,
          //   fit: BoxFit.cover,
          //   alignment: const Alignment(0, -1),
          // ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: MyColors.myYellow,
      height: 30,
      endIndent: 100,
      thickness: 1.5,
    );
  }

  checkIfQuotesAreLoaded(state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmpty(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmpty(state) {
    var quotes = (state as QuotesLoaded).quotes;
    if (quotes.isNotEmpty) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 8),
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: MyColors.myWhite,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: MyColors.myYellow,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuoteIndex].quote),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }
}
