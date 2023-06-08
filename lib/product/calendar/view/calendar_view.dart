import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insulin_calculate/core/util/text_style.dart';
import 'package:insulin_calculate/product/calculate/viewmodel/calculate_viewmodel.dart';
import 'package:insulin_calculate/product/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../core/util/color.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer2<CalculateViewModel, CalendarViewModel>(
      builder: (context, calculateState, calendarState, child) {
        return Container(
          width: size.width,
          height: size.height,
          color: ColorUtility.backgroundColor,
          child: Column(
            children: [
              Expanded(
                  child: Header(
                onPressed: () async {},
              )), //headerp
              Expanded(
                flex: 9,
                child: ListView.builder(
                  //tarihler
                  itemCount: calendarState.datesStringList.length,
                  itemBuilder: (context, index) {
                    return CalendarTile(
                      //tarih kartı
                      size: size,
                      date: calendarState.datesStringList[index],
                      insulin: calendarState.insulinStringList[index],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CalendarTile extends StatelessWidget {
  final String date;
  final String insulin;
  const CalendarTile({
    super.key,
    required this.size,
    required this.date,
    required this.insulin,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(width: 1, color: Colors.black12),
              bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: Row(
          children: [
            Text(
              date,
              style: CustomTextStyle.calendarTileMonth,
            ),
            const Spacer(),
            Column(
              children: [
                Container(
                  width: size.width * 0.17,
                  height: size.width * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorUtility.lightCarminePink,
                  ),
                  child: Row(
                    children: [
                      const Spacer(flex: 2),
                      Text(
                        insulin,
                        style: CustomTextStyle.calendarTileInusulinCounter,
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icon/needle.svg',
                        color: Colors.white,
                        width: 20,
                        height: 20,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final void Function()? onPressed;
  const Header({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text("Takvim", style: CustomTextStyle.title),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.sort,
              color: ColorUtility.lightCarminePink,
              size: 30,
            ),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
