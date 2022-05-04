import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nextonmaps/models/monuments.dart';
import 'package:nextonmaps/pages/MapPage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Welcome",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: window.physicalSize.height > 2000 ? const HeightLarge() : const HeightSmall(),
    );
  }
}

class HeightSmall extends StatelessWidget {
  const HeightSmall({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(const LinearGradient(
                  colors: [Vx.yellow500, Vx.orange600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight))
              .make(),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  "Next Stops \n By \n Next on Maps",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(3, 3),
                          blurRadius: 12,
                        ),
                      ],
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  // style: GoogleFonts.ramaraja(
                  //   textStyle: TextStyle(
                  //         shadows: [
                  //           Shadow(
                  //             color: Colors.black.withOpacity(0.3),
                  //             offset: const Offset(3, 3),
                  //             blurRadius: 12,
                  //           )
                  //         ],
                  //         fontSize: 42,
                  //         fontWeight: FontWeight.normal,
                  //         color: Colors.white),
                  // )
                ).pOnly(top: 24),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      enableFeedback: true,
                      elevation: MaterialStateProperty.all(8),
                      overlayColor: MaterialStateProperty.resolveWith((states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.grey
                            : null;
                      }),
                      fixedSize: MaterialStateProperty.all(const Size(280, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: const BorderSide(
                                  color: Colors.black, width: 3)))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const MapSampleTwo()));
                  },
                  child: const Text(
                    "Search For Washrooms",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Container(
                    alignment: Alignment.center,
                    height: 350,
                    child: Swiper(
                      itemCount: MonumentsList.monuments.length,
                      layout: SwiperLayout.TINDER,
                      itemWidth: 350,
                      itemHeight: 350,
                      itemBuilder: (context, index) {
                        final mon = MonumentsList.monuments[index];
                        return VxBox(
                                child: ZStack([
                          Positioned(
                              top: 0,
                              right: 0,
                              child: VxBox(
                                      child: mon.name.text.white.xl.bold
                                          .make()
                                          .px(16))
                                  .black
                                  .height(35)
                                  .withRounded(value: 10)
                                  .alignCenter
                                  .make()),
                        ]))
                            .clip(Clip.antiAlias)
                            .bgImage(DecorationImage(
                                image: NetworkImage(mon.url), fit: BoxFit.fill))
                            .withRounded(value: 55)
                            .white
                            .border(color: Colors.black, width: 4.5)
                            .make()
                            .p(8);
                      },
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeightLarge extends StatelessWidget {
  const HeightLarge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VxAnimatedBox()
            .size(context.screenWidth, context.screenHeight)
            .withGradient(const LinearGradient(
                colors: [Vx.yellow500, Vx.orange600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight))
            .make(),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Text(
                "Next Stops \n By \n Next on Maps",
                textAlign: TextAlign.center,
                style: TextStyle(
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(3, 3),
                        blurRadius: 12,
                      ),
                    ],
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                // style: GoogleFonts.ramaraja(
                //   textStyle: TextStyle(
                //         shadows: [
                //           Shadow(
                //             color: Colors.black.withOpacity(0.3),
                //             offset: const Offset(3, 3),
                //             blurRadius: 12,
                //           )
                //         ],
                //         fontSize: 42,
                //         fontWeight: FontWeight.normal,
                //         color: Colors.white),
                // )
              ).pOnly(top: 24),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    enableFeedback: true,
                    elevation: MaterialStateProperty.all(8),
                    overlayColor: MaterialStateProperty.resolveWith((states) {
                      return states.contains(MaterialState.pressed)
                          ? Colors.grey
                          : null;
                    }),
                    fixedSize: MaterialStateProperty.all(const Size(280, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                            side: const BorderSide(
                                color: Colors.black, width: 3)))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const MapSampleTwo()));
                },
                child: const Text(
                  "Search For Washrooms",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Container(
                  alignment: Alignment.center,
                  height: 350,
                  child: Swiper(
                    itemCount: MonumentsList.monuments.length,
                    layout: SwiperLayout.TINDER,
                    itemWidth: 350,
                    itemHeight: 350,
                    itemBuilder: (context, index) {
                      final mon = MonumentsList.monuments[index];
                      return VxBox(
                              child: ZStack([
                        Positioned(
                            top: 0,
                            right: 0,
                            child: VxBox(
                                    child: mon.name.text.white.xl.bold
                                        .make()
                                        .px(16))
                                .black
                                .height(35)
                                .withRounded(value: 10)
                                .alignCenter
                                .make()),
                      ]))
                          .clip(Clip.antiAlias)
                          .bgImage(DecorationImage(
                              image: NetworkImage(mon.url), fit: BoxFit.fill))
                          .withRounded(value: 55)
                          .white
                          .border(color: Colors.black, width: 4.5)
                          .make()
                          .p(8);
                    },
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
