import 'package:flutter/material.dart';

class DislikeWidget extends StatefulWidget{
  final bool isDisliked;
  final int dislikeCount;

  const DislikeWidget({super.key, required this.isDisliked, required this.dislikeCount});


  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState(isDisliked, dislikeCount);
}

class _FavoriteWidgetState extends State<DislikeWidget>{
  bool _isDisliked ;
  int _dislikeCount;

  _FavoriteWidgetState(this._isDisliked, this._dislikeCount);



  void _toggleFavorite(){
    setState(() {
      if(_isDisliked ){
        _isDisliked  = false;
        _dislikeCount -= 1;
      }else{
        _isDisliked  = true;
        _dislikeCount += 1 ;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: _isDisliked  ? const Icon(Icons.thumb_down) : const Icon(Icons.thumb_down),
          color: Colors.red,
          onPressed: _toggleFavorite,
          iconSize: 35,
        ),

        Text('$_dislikeCount',
            style: const TextStyle(
            fontSize: 35,
          ),
        ),
      ],
    );
  }
}

