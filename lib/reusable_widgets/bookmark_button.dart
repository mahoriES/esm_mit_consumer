import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';

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
        if (status == AnimationStatus.completed) _controller.reverse();
      });
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
