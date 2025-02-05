import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MySliverAppBar extends StatefulWidget {
  const MySliverAppBar({super.key});

  @override
  State<MySliverAppBar> createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: const Padding(
        padding: EdgeInsets.only(
          left: 10,
        ),
        child: Center(
          child: Text(
            "RS",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      title: SizedBox(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: "Search anything you like",
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SvgPicture.asset(
            "assets/cart 02.svg",
            height: 30,
            width: 30,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [],
          ),
        ),
      ),
    );
  }
}
