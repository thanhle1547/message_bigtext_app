import 'package:flutter/material.dart';

class BouncingListView extends ListView {
  @override
  ScrollPhysics get physics =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
