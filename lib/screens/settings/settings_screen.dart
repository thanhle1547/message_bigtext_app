import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/blocs/font_size_factor/bloc.dart';
import 'package:message_bigtext_app/blocs/font_size_factor/event.dart';
import 'package:message_bigtext_app/utils/services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontsize;

  @override
  initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
    //   _fontsize = await Preferences.getFontSizeFactor();
    // });
  }

  _setFontSizeFactor(double size) {
    _fontsize = size;
    RepositoryProvider.of<FontSizeBloc>(context)
        .add(ChangedFontSizeFactorEvent(size));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(CupertinoIcons.textformat_size),
              title: Text(
                'Kích thước phông chữ',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
              subtitle: Slider(
                value: BlocProvider.of<FontSizeBloc>(context).state.size,
                label: BlocProvider.of<FontSizeBloc>(context)
                    .state
                    .size
                    .toStringAsFixed(2),
                onChanged: (newVal) {},
                min: 1,
                max: 2,
                divisions: 6,
                // onChangeEnd: _setFontSizeFactor,
                onChangeEnd: (value) => BlocProvider.of<FontSizeBloc>(context)
                    .add(ChangedFontSizeFactorEvent(value)),
              ),
            ),
            Divider(
              height: 16,
              indent: 16,
              endIndent: 16,
              color: Theme.of(context).accentColor,
            ),
            ListTile(
              title: Text(
                'Xóa tất cả tin nhắn',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
