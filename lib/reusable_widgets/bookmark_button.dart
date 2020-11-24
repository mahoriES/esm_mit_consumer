import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';

///The [BookmarkButton] widget, is an animated button, used to show the bookmark status for the merchant
///It also allows toggling the status of the same for the merchant

class BookmarkButton extends StatefulWidget {

  final Function onTap;
  bool isBookmarked;

  BookmarkButton({@required this.onTap, @required this.isBookmarked});

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 1.0, end: 0.6).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear))
      ..addListener(() {setState(() {});})
      ..addStatusListener((status) {
        //By reversing the _controller we go back from the shrank icon to its original size
        if (status == AnimationStatus.completed) _controller.reverse();
      });
    //The assignment below guards from the case, when the current bookmark status is not specified in the constructor
    if (widget.isBookmarked==null)widget.isBookmarked=false;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: GestureDetector(
      onTap: () {
        widget.onTap();
        //When the bookmark button is tapped, we toggle the status while the animations continues
        widget.isBookmarked = !widget.isBookmarked;
        _controller.forward();
      },
      child: Transform.scale(scale: _animation.value,
        child: Icon(
          Icons.bookmark,
          color: widget.isBookmarked ? AppColors.blueBerry : AppColors.blueBerry.withOpacity(0.3),
        ),
      ),
    ),);
  }
}
