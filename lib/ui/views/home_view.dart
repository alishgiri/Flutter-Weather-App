import 'package:flutter/material.dart';

import 'package:weatherapp/ui/views/base_view.dart';
import 'package:weatherapp/core/view_models/home_view_model.dart';
import 'package:weatherapp/ui/views/help_view.dart';
import 'package:weatherapp/ui/views/widgets/home/weather_info.dart';

class HomeView extends StatelessWidget {
  void dismissKeyboard(BuildContext context) {
    final currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseView<HomeViewModel>(
      initState: (model) => model.initState(),
      builder: (context, model, _) {
        final isBusy = model.isBusy;
        final data = model.weatherData;
        return Scaffold(
          key: model.scaffoldKey,
          floatingActionButton: isBusy
              ? null
              : RaisedButton(
                  onPressed: () {
                    dismissKeyboard(context);
                    model.onSearch();
                  },
                  child: model.city == null
                      ? const Text('Save')
                      : const Text('Update'),
                ),
          appBar: AppBar(
            elevation: 0,
            title: const Text('Weather App'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => HelpView()),
                  );
                },
                child:
                    const Text('Help', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Form(
                key: model.formKey,
                child: TextFormField(
                  readOnly: isBusy,
                  initialValue: model.city,
                  style: theme.textTheme.headline4,
                  onChanged: model.onSearchChanged,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isEmpty) return "Location is requried.";
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Search City…",
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
              Expanded(
                child: isBusy
                    ? const Center(child: const CircularProgressIndicator())
                    : WeatherInfo(data: data),
              )
            ],
          ),
        );
      },
    );
  }
}