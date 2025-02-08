import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String? tit;
  final dynamic onTap;
  final dynamic icons;
  const CustomListTile({
    this.tit,
    this.onTap,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        0,
        0.0,
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap ?? "",
          splashColor: Colors.orangeAccent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              25.0,
              0,
              25.0,
              0,
            ),
            height: 60,
            child: Row(
              children: [
                Icon(
                  icons ?? "",
                  color: Color(0xFF681d21),
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                  ),
                  child: Text(
                    tit ?? "",
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
