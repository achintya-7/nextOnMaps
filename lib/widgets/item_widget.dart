// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nextonmaps/models/allPlaces.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key, required this.item})
      : // assert is mostly used in debugging
        super(key: key);

  final Item item;

// this is the widgets which will be used for designing of a
// single cell of a list like adding conetent, image, sub heading, heading, etc.
  @override
  Widget build(BuildContext context) {
    return VxBox(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      item.name.text.lg.color(Colors.black).size(15).bold.make().p(8),
                      item.address.text.color(Colors.black87).size(14).make().pOnly(left: 8)
                    ],
                  )
                ),
            ],
            )
          )
          .color(Colors.white)
          .rounded
          .square(90)
          .border(color: Colors.black, width: 3)
          .make()
          .pOnly(left: 8, right: 8, top: 4, bottom: 4);
  }
}
