import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class IconItemRow extends StatelessWidget {
  final String title;
  final String icon;
  final String? value;
  final Function()? onTap;
  const IconItemRow(
      {super.key,
      required this.title,
      required this.icon,
 this.value,
 this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 20,
              height: 20,
              color:Colors.black ,
              
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: const TextStyle(
                 fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                value??"",
                textAlign: TextAlign.right,
                style:const  TextStyle(
                   
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Image.asset("assets/images/back.png",
                width: 12, height: 12,color: Colors.black,
                )
          ],
        ),
      ),
    );
  }
}

class IconItemSwitchRow extends StatelessWidget {
  final String title;
  final String icon;
  final bool value;
  final Function(bool) didChange;

  const IconItemSwitchRow(
      {super.key,
      required this.title,
      required this.icon,
      required this.didChange,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 20,
            height: 20,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            title,
            style:const  TextStyle(
                 fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const SizedBox(
            width: 8,
          ),
          CupertinoSwitch(value: value, onChanged: didChange)
        ],
      ),
    );
  }
}
