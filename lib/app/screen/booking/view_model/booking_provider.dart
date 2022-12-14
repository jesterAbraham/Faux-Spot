import 'package:faux_spot/app/core/app_helper.dart';
import 'package:faux_spot/app/routes/messenger.dart';
import 'package:faux_spot/app/screen/booking/model/time_model.dart';
import 'package:faux_spot/app/screen/home/model/home_model.dart';
import 'package:faux_spot/app/screen/overview/view_model/overview_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/colors.dart';
import '../../overview/model/booking_response.dart';
import '../model/time_converter.dart';

class BookingProvider extends ChangeNotifier {
  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      uiOverlay(status: transparentColor, navigate: primaryColor),
    );
    super.dispose();
  }

  OverViewProvider overViewProvider = Messenger
      .rootScaffoldMessengerKey.currentContext!
      .read<OverViewProvider>();

  DateTime bookingDAte = DateTime.now();
  DateTime date = DateTime.now();
  changeDAte({required BuildContext context, required DataList list}) async {
    date = (await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: date.add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: primaryColor,
                ),
              ),
              child: child!,
            );
          },
        )) ??
        DateTime.now();
    slotCreate(list: list);
    bookingDAte = date;
    notifyListeners();
  }

  //================================ CREATE SLOT ======================================

  List<TimeModel> morningSlot = [];
  List<TimeModel> afternoonSlot = [];
  List<TimeModel> eveningSlot = [];
  List<BookingList> booking = [];
  List<String> dataList = [];
  double totalAmount = 0.00;
  List<String> infoList = [];

  void slotCreate({required DataList list, DateTime? dateOn}) async {
    dataList.clear();
    booking.clear();
    morningSlot.clear();
    afternoonSlot.clear();
    eveningSlot.clear();
    booking.addAll(overViewProvider.bookingList);
    convertBookingSlot(dateOn: dateOn, list: list);
  }

  //================================ CREATE SLOT ======================================

  void convertToSlot({required DataList list, DateTime? dateOn}) {
    totalAmount = 0;
    int morningTimeStart = list.turfTime!.timeMorningStart!;
    int morningTimeEnd = list.turfTime!.timeMorningEnd!;
    int afternoonTimeStart = list.turfTime!.timeAfternoonStart!;
    int afternoonTimeEnd = list.turfTime!.timeAfternoonEnd!;
    int eveningTimeStart = list.turfTime!.timeEveningStart!;
    int eveningTimeEnd = list.turfTime!.timeEveningEnd!;

    for (int i = morningTimeStart; i < morningTimeEnd; i++) {
      morningSlot
          .add(TimeModel(time: hourConvert(hour: "$i:00"), isSelected: false));
    }
    for (int i = afternoonTimeStart; i < afternoonTimeEnd; i++) {
      afternoonSlot
          .add(TimeModel(time: hourConvert(hour: "$i:00"), isSelected: false));
    }
    for (int i = eveningTimeStart; i < eveningTimeEnd; i++) {
      eveningSlot
          .add(TimeModel(time: hourConvert(hour: "$i:00"), isSelected: false));
    }
    selectedAddList.clear();
    notifyListeners();
  }

  //================================ CONVERT TO BOOKING SLOT ======================================

  String currentDateTime = DateFormat.yMd().format(DateTime.now());

  void convertBookingSlot({DateTime? dateOn, required DataList list}) async {
    int currentTime =
        int.tryParse(DateFormat.Hm().format(DateTime.now()).split(":").first)!;
    String pickedDateTime = DateFormat.yMd().format(dateOn ?? date);
    Future.forEach(booking, (BookingList element) {
      if (element.bookingDate == DateFormat.yMd().format(dateOn ?? date)) {
        for (int i = 0; i < element.timeSlot!.length; i++) {
          infoList.add(hourConvert(hour: "${element.timeSlot![i]}:00"));
          dataList.add(hourConvert(hour: "${element.timeSlot![i]}:00"));
        }
      }
    });

    for (int i = 0; i <= currentTime; i++) {
      if (currentDateTime == pickedDateTime) {
        dataList.add(hourConvert(hour: "$i:00"));
      }
    }
    convertToSlot(list: list, dateOn: dateOn);
  }

  //================================  multiTouch ======================================

  List<int> selectedAddList = [];

  void multiTouch(
      {required int index,
      required String time,
      required bool isSelected,
      required double price}) {
    if (dataList.contains(time)) {
      if (!infoList.contains(time)) {
        Messenger.pop(msg: "Time expired");
      } else {
        Messenger.pop(msg: "Already Booked", color: redColor);
      }
    } else {
      if (!isSelected) {
        totalAmount += price;
        if (backTo24Hour(hour: time) >= 1 && backTo24Hour(hour: time) <= 12) {
          morningSlot[index].isSelected = true;
        } else if (backTo24Hour(hour: time) > 12 &&
            backTo24Hour(hour: time) <= 16) {
          afternoonSlot[index].isSelected = true;
        } else if (backTo24Hour(hour: time) > 16 &&
            backTo24Hour(hour: time) <= 24) {
          eveningSlot[index].isSelected = true;
        }
        selectedAddList.add(backTo24Hour(hour: time));
      } else {
        totalAmount -= price;
        if (backTo24Hour(hour: time) >= 1 && backTo24Hour(hour: time) <= 12) {
          morningSlot[index].isSelected = false;
        } else if (backTo24Hour(hour: time) > 12 &&
            backTo24Hour(hour: time) <= 16) {
          afternoonSlot[index].isSelected = false;
        } else if (backTo24Hour(hour: time) > 16 &&
            backTo24Hour(hour: time) <= 24) {
          eveningSlot[index].isSelected = false;
        }
        selectedAddList
            .removeWhere((element) => element == backTo24Hour(hour: time));
      }
    }
    notifyListeners();
  }

  //================================  BOOKING RESPONSIVE ======================================

  double bookingResponsive({required int count}) {
    if (count > 0 && count <= 3) {
      return 6;
    } else if (count > 3 && count <= 6) {
      return 3.13;
    } else if (count > 6 && count <= 9) {
      return 1.4;
    } else if (count > 9 && count <= 12) {
      return .9;
    } else {
      return 1.3;
    }
  }
}
