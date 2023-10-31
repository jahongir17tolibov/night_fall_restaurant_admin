import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:night_fall_restaurant_admin/utils/helpers.dart';
import 'package:night_fall_restaurant_admin/utils/ui_components/standart_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.light_mode_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          tooltip: 'Light mode',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: ListView.builder(
          physics: const RangeMaintainingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return _ordersListItem();
          }),
    );
  }

  Widget _ordersListItem() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      color: Theme.of(context).colorScheme.surface,
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 7,
            height: 110,
            margin: const EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              right: 20.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 110.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextView(
                      text: 'Table: 5',
                      textSize: 32.0,
                      textColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(height: 10),
                    TextView(
                      text: 'Buyurtma: no2.34210623',
                      textSize: 16.0,
                      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    TextView(
                      text: "21:37 11.10.2023",
                      textSize: 16.0,
                      weight: FontWeight.w700,
                      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
