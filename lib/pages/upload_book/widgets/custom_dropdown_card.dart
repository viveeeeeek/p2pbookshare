import 'package:flutter/material.dart';

class CustomDropDownCard extends StatelessWidget {
  final String? selectedCondition, hintText;
  final List<String> conditions;
  final void Function(String?) onChanged;

  final String? hint;
  final BorderRadius borderRadius;
  final Icon hintIcon;

  const CustomDropDownCard({
    super.key,
    required this.selectedCondition,
    required this.conditions,
    required this.onChanged,
    this.hint,
    required this.borderRadius,
    required this.hintIcon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedCondition,
            iconSize: 0,
            hint: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                hintIcon,
                const SizedBox(
                  width: 15,
                ),
                Text(hintText ?? '')
              ],
            ),
            items: conditions.map((condition) {
              return DropdownMenuItem<String>(
                value: condition,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(condition),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
