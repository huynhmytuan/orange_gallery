import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.space_dashboard_rounded,
            size: 80,
            color: (Theme.of(context).brightness == Brightness.light)
                ? Colors.black
                : Colors.white,
          ),
          const SizedBox(height: 20),
          Text(tr('notice.empty')),
        ],
      ),
    );
  }
}
