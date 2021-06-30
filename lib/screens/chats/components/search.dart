import 'package:flutter/material.dart';

import '../../../constants.dart';

class Search extends StatefulWidget {
  Search({Key key, this.onChanged, this.clearCallback, this.focusNode})
      : super(key: key);

  final void Function(String) onChanged;
  final VoidCallback clearCallback;
  final FocusNode focusNode;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: kpItemHorizontal,
        right: kpItemHorizontal,
        bottom: kpItemHorizontal,
      ),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: kr10,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: widget.focusNode,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(letterSpacing: 0.85),
              // cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                // hintStyle: Theme.of(context).textTheme.headline6,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 12.0, right: 48.0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).hintColor,
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          Visibility(
            visible: _searchController.text.trim().length > 0,
            child: Padding(
              padding: const EdgeInsets.only(top: kpItemHorizontal),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    if (widget.clearCallback != null) widget.clearCallback();
                  });
                },
                style: TextButton.styleFrom(
                  // primary: Theme.of(context).primaryColor,
                  backgroundColor: kcPrimaryColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: kpItemHorizontal, vertical: kpMsgVertical),
                ),
                child: Text('Hủy tìm kiếm',
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
