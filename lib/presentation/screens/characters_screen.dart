import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breaking/business_logic/cubit/characters_cubit.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/data/models/character.dart';
import 'package:flutter_breaking/presentation/widgets/character_item.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searcherForCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _buildAppBarActions(),
        leading: _isSearching
            ? const BackButton(
                color: MyColors.myGrey,
              )
            : null,
        backgroundColor: MyColors.myYellow,
        title: _isSearching
            ? buildSearchField()
            : const Text(
                'Characters',
                style: TextStyle(color: MyColors.myGrey),
              ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity, Widget child) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            bool isLoaded =
                BlocProvider.of<CharactersCubit>(context).isLoaded();
            if (!isLoaded) {
              BlocProvider.of<CharactersCubit>(context).getAllCharacters();
            }
            return buildBlocWidget();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = state.characters;
          // precacheImages();
          return buildLoadedListWidget();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: MyColors.myYellow,
    ));
  }

  Widget buildLoadedListWidget() {
    return Container(
      color: MyColors.myGrey,
      child: GridView.count(
        addAutomaticKeepAlives: true,
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        children: _searchTextController.text.isEmpty
            ? charactersToItem(allCharacters)
            : charactersToItem(searcherForCharacters),
      ),
    );
  }

  List<Widget> charactersToItem(List<Character> characters) {
    return characters
        .map((character) => CharacterItem(
              character: character,
            ))
        .toList();
  }

  Widget buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
        hintText: 'Find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: MyColors.myGrey,
          fontSize: 18,
        ),
      ),
      style: const TextStyle(
        color: MyColors.myGrey,
        fontSize: 18,
      ),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsToSearchedList(String searchedCharacter) {
    searcherForCharacters = allCharacters
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
            onPressed: () {
              _stopSearching();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: MyColors.myGrey,
            )),
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearch,
            icon: const Icon(
              Icons.search,
              color: MyColors.myGrey,
            )),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    setState(() {
      _searchTextController.clear();
      _isSearching = false;
    });
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Image.asset('assets/images/no_internet.png'),
            const Text(
              'can\'t connect.. please check your internet connection!',
              style: TextStyle(
                  fontSize: 22,
                  color: MyColors.myGrey,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // void precacheImages() {
  //   for (Character character in allCharacters) {
  //     precacheImage(NetworkImage(character.image), context);
  //   }
  // }
}
