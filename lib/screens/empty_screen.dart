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
          Image.asset(
            'assets/images/empty_box.png',
            height: MediaQuery.of(context).size.height * .2,
          ),
          const SizedBox(height: 20),
          Text(tr('notice.empty')),
        ],
      ),
    );
  }
}
