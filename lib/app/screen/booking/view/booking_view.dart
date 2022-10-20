import 'package:faux_spot/app/core/app_helper.dart';
import 'package:faux_spot/app/core/colors.dart';
import 'package:faux_spot/app/screen/booking/model/select_model.dart';
import 'package:faux_spot/app/screen/booking/view/widgets/datepicker_widget.dart';
import 'package:faux_spot/app/screen/booking/view_model/booking_provider.dart';
import 'package:faux_spot/app/screen/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingView extends StatelessWidget {
  final DataList data;
  const BookingView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    BookingProvider provider = context.read<BookingProvider>();
    provider.date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: uiOverlay(navigate: whiteColor),
        title: Text(data.turfName!),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          space20,
          DatePickerWidget(provider: provider),
          timeWidget(price: data.turfTime!.timeMorning!, time: "Morning"),
          Consumer<BookingProvider>(builder: (context, value, _) {
            return Wrap(
              direction: Axis.horizontal,
              children: List.generate(
                timeListMorning.length,
                (index) {
                  final list = timeListMorning[index];
                  return GestureDetector(
                    onTap: () {
                      value.multiSelect(
                        index: list.index,
                        value: !selectedList[list.index].selected,
                        booked: selectedList[list.index].booked,
                      );
                    },
                    child: TimeWidget(
                      time: list.time,
                      index: index,
                    ),
                  );
                },
              ),
            );
          }),
          timeWidget(price: data.turfTime!.timeAfternoon!, time: "Afternoon"),
          Consumer<BookingProvider>(builder: (context, value, _) {
            return Wrap(
              direction: Axis.horizontal,
              children: List.generate(
                timeListAfternoon.length,
                (index) {
                  final list = timeListAfternoon[index];
                  return GestureDetector(
                    onTap: () {
                      value.multiSelect(
                        index: list.index,
                        value: !selectedList[list.index].selected,
                        booked: selectedList[list.index].booked,
                      );
                    },
                    child: TimeWidget(
                      time: list.time,
                      index: list.index,
                    ),
                  );
                },
              ),
            );
          }),
          timeWidget(price: data.turfTime!.timeEvening!, time: "Evening"),
          Consumer<BookingProvider>(builder: (context, value, _) {
            return Wrap(
              direction: Axis.horizontal,
              children: List.generate(
                timeListEvening.length,
                (index) {
                  final list = timeListEvening[index];
                  return GestureDetector(
                    onTap: () {
                      value.multiSelect(
                        index: list.index,
                        value: !selectedList[list.index].selected,
                        booked: selectedList[list.index].booked,
                      );
                    },
                    child: TimeWidget(
                      time: list.time,
                      index: list.index,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          provider.addBooking(list: data);
        },
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: primaryColor,
          ),
          child: const Center(
            child: Text(
              "BOOK NOW",
              style: TextStyle(
                color: whiteColor,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column timeWidget({required String time, required String price}) {
    return Column(
      children: [
        space20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            Text(
              "₹ $price",
              style: const TextStyle(
                color: greenColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        space10,
      ],
    );
  }
}

class TimeWidget extends StatelessWidget {
  final int index;
  final String time;
  const TimeWidget({
    Key? key,
    required this.time,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(5),
      height: 50,
      width: size.width * .27,
      decoration: BoxDecoration(
        color: selectedList[index].booked
            ? greyColor
            : selectedList[index].selected
                ? primaryColor
                : whiteColor,
        border: Border.all(
            color: selectedList[index].booked
                ? lightGreyColor
                : selectedList[index].selected
                    ? whiteColor
                    : primaryColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          time,
          style: TextStyle(
            fontSize: 16,
            color: selectedList[index].booked
                ? whiteColor
                : selectedList[index].selected
                    ? whiteColor
                    : primaryColor,
          ),
        ),
      ),
    );
  }
}