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
    this.showTranslateButton = true,
    required this.language,
    required this.onClear,
    required this.onSpeak,
  });
  final String hintText;
  final String translateIcon;
  final void Function()? onPressed;
  final void Function()? onSpeak;
  final void Function()? onClear;
  final TextEditingController controller;
  final void Function()? onTap;
  final bool showTranslateButton;
  final String language;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 260,
          decoration: ShapeDecoration(
            color: Color(0xFFFFFBFE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x08A350A4),
                blurRadius: 3,
                offset: Offset(0, 1),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
            child: Column(
              children: [
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              language,
                              style: TextStyle(
                                color: Color(0xFF003366),
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          IconButton(
                              onPressed: onSpeak,
                              icon: SvgPicture.asset(
                                'assets/icons/speaker.svg',
                                width: 35,
                                colorFilter: ColorFilter.mode(
                                    Color(0xFF003366), BlendMode.srcIn),
                              )),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: onClear,
                        icon: Icon(
                          Icons.clear_outlined,
                          size: 30,
                          color: Color(0xFF003366),
                        )),
                  ],
                ),
                Container(
                  height: 100,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: Color(0xFF4B4662),
                      fontSize: 16,
                    ),
                    maxLines: 3,
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
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: SvgPicture.asset(
                        'assets/icons/copy.svg',
                        width: 30,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF4B4662), BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: onPressed,
                      child: showTranslateButton
                          ? Container(
                              width: 170,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(94, 62, 214, 1),
                                    Color.fromRGBO(96, 60, 214, 1),
                                  ],
                                ),
                                color: Color(0xFF4B4662),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/translate.svg',
                                    width: 30,
                                    colorFilter: ColorFilter.mode(
                                        Color(0xffffffff), BlendMode.srcIn),
                                  ),
                                  SizedBox(width: 10),
                                  Text("Translate",
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                      ))
                                ],
                              ),
                            )
                          : SizedBox(),
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
