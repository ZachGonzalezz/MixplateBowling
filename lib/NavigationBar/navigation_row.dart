import 'package:flutter/material.dart';

class NavigationRow extends StatelessWidget {
  NavigationRow(
      {Key? key,
      required this.icon,
      required this.screeName,
      required this.sendTo,
      required this.isSelected})
      : super(key: key);

  IconData icon;
  String screeName;
  String sendTo;
  bool isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, sendTo);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey[700],
                size: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                screeName,
                style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              )
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
