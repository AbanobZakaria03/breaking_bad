import 'package:bloc/bloc.dart';
import 'package:flutter_breaking/data/models/character.dart';
import 'package:flutter_breaking/data/models/quote.dart';
import 'package:flutter_breaking/data/repositories/characters_repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  void getAllCharacters() async {
    // charactersRepository.getAllCharacters().then((characters) {
    //   emit(CharactersLoaded(characters));
    //   this.characters = characters;
    // });

    try{
    List<Character> characters = await charactersRepository.getAllCharacters();
    emit(CharactersLoaded(characters));
    }catch(e){
      emit(CharactersErrorCase());
    }
  }

  void getCharacterQuotes(String charName) async {
    List<Quote> quotes =
        await charactersRepository.getCharacterQuotes(charName);
    emit(QuotesLoaded(quotes));
  }

  bool isLoaded() {
    return state is CharactersLoaded;
  }
}
