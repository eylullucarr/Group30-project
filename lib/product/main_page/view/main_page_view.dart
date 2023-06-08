import 'package:flutter/material.dart';
import 'package:insulin_calculate/core/util/color.dart';
import 'package:insulin_calculate/product/calculate/viewmodel/calculate_viewmodel.dart';
import 'package:insulin_calculate/product/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../calculate/view/calculate_view.dart';
import '../../calendar/view/calendar_view.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  int pageIndex = 0;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 3));
    Provider.of<CalculateViewModel>(context, listen: false).getFoodsList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer2<CalculateViewModel, CalendarViewModel>(
      builder: (context, calculateState, calendarState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('S U G G A R Y'),
            backgroundColor: ColorUtility.lightCarminePink,
            centerTitle: true,
          ),
          body: isLoading && pageIndex == 0
              ? Center(
                  child: CircularProgressIndicator(
                  color: ColorUtility.lightCarminePink,
                ))
              : pageIndex == 0
                  ? const CalculateView()
                  : const CalendarView(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageIndex,
            selectedItemColor: ColorUtility.lightCarminePink,
            backgroundColor: ColorUtility.backgroundColor,
            elevation: 30,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calculate,
                    color: ColorUtility.lightCarminePink,
                  ),
                  label: 'Hesapla',
                  backgroundColor: ColorUtility.lightCarminePink),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month,
                  color: ColorUtility.lightCarminePink,
                ),
                label: 'Takvim',
              ),
            ],
            onTap: (value) {
              setState(() {
                pageIndex = value;
                calendarState.getDateList();
              });
            },
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.save),
          //   backgroundColor: ColorUtility.lightCarminePink,
          //   onPressed: () {},
          // ),
        );
      },
    );
  }
}
