import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/constants/strings.dart';
import 'package:flutter_breaking/data/models/character.dart';

class CharacterItem extends StatelessWidget {
  final Character character;

  const CharacterItem({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MyColors.myWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, characterDetailsScreen,
            arguments: character),
        child: GridTile(
          child: Hero(
            tag: character.charId,
            child: Container(
              color: MyColors.myGrey,
              child: character.image.isNotEmpty
                  ? CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: character.image,
                      placeholder: (context, url) =>
                          Image.asset('assets/images/loading.gif',fit: BoxFit.cover,),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  //     ? FadeInImage.assetNetwork(
                  //   width: double.infinity,
                  //   height: double.infinity,
                  //   fit: BoxFit.cover,
                  //   placeholder: 'assets/images/loading.gif',
                  //   image: character.image,
                  //   imageErrorBuilder:(context, error, stackTrace) => Image.asset('assets/images/placeholder.png',fit: BoxFit.cover,),
                  // )
                  : Image.asset('assets/images/placeholder.png'),
            ),
          ),
          footer: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.black54,
            alignment: Alignment.bottomCenter,
            child: Text(
              character.name,
              style: const TextStyle(
                height: 1.3,
                fontSize: 16,
                color: MyColors.myWhite,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
