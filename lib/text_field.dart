import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class textfield extends StatelessWidget {
  textfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.translateIcon,
    this.onPressed,
    this.onTap,
  });
  final String hintText;
  final String translateIcon;
  final void Function()? onPressed;
  final TextEditingController controller;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 220,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: Column(
              children: [
                Container(
                  height: 125,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Color(0xFF4B4662),
                      fontSize: 16,
                    ),
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(fontSize: 20),
                        border: InputBorder.none),
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                  thickness: 2,
                ),
                SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: SvgPicture.asset(
                        'assets/icons/copy.svg',
                        colorFilter: ColorFilter.mode(
                            Color(0xFF4B4662), BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: onPressed,
                      icon: SvgPicture.asset(
                        translateIcon,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF4B4662), BlendMode.srcIn),
                        width: 30,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
