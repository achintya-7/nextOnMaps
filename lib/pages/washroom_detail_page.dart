import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nextonmaps/models/all_places.dart';
import 'package:nextonmaps/models/review_model.dart';
import 'package:nextonmaps/my_services/map_service.dart';
import 'package:nextonmaps/repository/db_repository.dart';
import 'package:nextonmaps/widgets/custom_pop_up_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class WashroomDetailPage extends StatelessWidget {
  final Item washroom;

  const WashroomDetailPage(this.washroom, {super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController reviewController = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/BG_washroom_detail.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text(washroom.name),
            backgroundColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey[200],
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Center(child: Text(washroom.name)),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                  color: Colors.black38,
                ),
                const SizedBox(height: 10),

                // * Address
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey[200],
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        washroom.address,
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                  color: Colors.black38,
                ),
                const SizedBox(height: 10),

                const Spacer(
                  flex: 2,
                ),

                SizedBox(
                  height: 45,
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        try {
                          MapService.launchUrlFunc(Uri.parse(washroom.link));
                        } catch (e) {
                          Fluttertoast.showToast(msg: "Something went wrong");
                        }
                      },
                      child: const Text('Get Directions')),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ReviewWidget(washroom: washroom),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                            onPressed: () => showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CustomPopUpWidget(
                                                        reviewController:
                                                            reviewController,
                                                        placeName:
                                                            washroom.name)),
                                            child:
                                                const Text("Write a Review")),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: const Text('Review')),
                ),

                const Spacer()
              ],
            ),
          )),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    Key? key,
    required this.washroom,
  }) : super(key: key);

  final Item washroom;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<ReviewModel>>(
        stream:
            DBRepository.getReviews(washroom.name, FirebaseFirestore.instance),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<ReviewModel> data = snapshot.data;
            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'No Reviews yet',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      data[index].time * 1000);
                  String formatDate = DateFormat.yMMMd().format(date);
                  return VxBox(
                    child: ListTile(
                      title: Text(data[index].review),
                      subtitle: Text(formatDate),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${data[index].rating.toInt()}/5"),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          )
                        ],
                      ),
                    ),
                  )
                      .color(Colors.white)
                      .rounded
                      .border(color: Colors.black, width: 3)
                      .make()
                      .pOnly(left: 8, right: 8, top: 4, bottom: 4);
                },
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something Went Wrong',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
