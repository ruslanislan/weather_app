import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile(
      {Key? key,
      this.isLast = false,
      required this.text,
      this.icon,
      required this.value,
      this.isFirst = false})
      : super(key: key);
  final String value;
  final String text;
  final bool isLast;
  final bool isFirst;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFa3cdd9),
        borderRadius: BorderRadius.vertical(
            bottom: isLast ? const Radius.circular(10) : Radius.zero,
            top: isFirst ? const Radius.circular(10) : Radius.zero),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                child: icon,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
