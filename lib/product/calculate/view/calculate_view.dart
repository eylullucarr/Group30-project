import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insulin_calculate/core/compenent/button/main_button.dart';
import 'package:insulin_calculate/core/util/color.dart';
import 'package:insulin_calculate/core/util/text_style.dart';
import 'package:insulin_calculate/product/calculate/viewmodel/calculate_viewmodel.dart';
import 'package:provider/provider.dart';

class CalculateView extends StatefulWidget {
  const CalculateView({super.key});

  @override
  State<CalculateView> createState() => _CalculateViewState();
}

class _CalculateViewState extends State<CalculateView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<CalculateViewModel>(
      builder: (context, calculateState, child) {
        return Container(
          width: size.width,
          height: size.height,
          color: ColorUtility.backgroundColor,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: SelectCalendar(
                              // Tarih seçme kısmı
                              size: size,
                              onTap: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) => SizedBox(
                                    height: size.height * 0.4,
                                    child: CupertinoDatePicker(
                                      backgroundColor: Colors.white,
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime:
                                          calculateState.selectedDate,
                                      onDateTimeChanged: (DateTime newTime) {
                                        calculateState
                                            .changeSelectedDate(newTime);
                                        calculateState.isIncludeSelectedDate();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          ), // Tarih seçme kısmı
                          const Spacer(),
                          Expanded(
                            flex: 10,
                            child: InsulinCounter(
                                // Hesaplanan insülin sayaçı
                                size: size,
                                isInclude: calculateState.isInclude,
                                insulinCount: calculateState.dateList.isEmpty
                                    ? 0
                                    : calculateState
                                        .dateList[
                                            calculateState.selectedDateIndex]
                                        .insulinCount,
                                // dateModel: calculateState
                                //     .dateList[calculateState.selectedDateIndex],
                                createdDefaultData: true),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: CarbohydrateCounter(
                              // Alınan karbonhidrat sayaçı
                              size: size,
                              carbohydrateAmount:
                                  calculateState.dateList.isEmpty
                                      ? 0
                                      : calculateState
                                          .dateList[
                                              calculateState.selectedDateIndex]
                                          .carbohydrateAmount,
                            ),
                          ),
                          const Spacer(),
                          const Divider()
                        ],
                      ),
                    ),
                  ), // Alınan karbonhidrat sayaçı
                  Expanded(
                      child: FutureBuilder(
                          // Yemek listesi
                          future: calculateState.getFoodsList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                // Yemek listesi
                                padding: const EdgeInsets.only(bottom: 10),
                                itemCount: calculateState
                                    .dateList[calculateState.selectedDateIndex]
                                    .foods
                                    .length,
                                itemBuilder: (context, index) {
                                  return FoodTile(
                                    name: calculateState
                                        .dateList[
                                            calculateState.selectedDateIndex]
                                        .foods[index]
                                        .name,
                                    count: calculateState
                                        .dateList[
                                            calculateState.selectedDateIndex]
                                        .foods[index]
                                        .count,
                                    size: size,
                                    removeOnPressed: () {
                                      calculateState.removeCarbohydrate(index);
                                    },
                                    addOnPressed: () {
                                      calculateState.addCarbohydrate(index);
                                    },
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorUtility.lightCarminePink,
                                ),
                              );
                            }
                          })),
                ],
              ),
              Visibility(
                visible: !calculateState.isInclude,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.73,
                      color: ColorUtility.backgroundColor,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !calculateState.isInclude,
                child: Center(
                  child: MainButton(
                    // Tarih ekleme butonu
                    large: true,
                    icon: Icons.save,
                    text: "Tarih Ekle",
                    onTap: () {
                      calculateState.addDateToList();
                      calculateState.isIncludeSelectedDate();
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FoodTile extends StatelessWidget {
  final String name;

  final void Function()? removeOnPressed;
  final void Function()? addOnPressed;
  final int count;
  const FoodTile({
    super.key,
    required this.size,
    this.count = 0,
    this.removeOnPressed,
    this.addOnPressed,
    required this.name,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Container(
        // yemek listesi kartları
        width: size.width * 0.9,
        height: size.width * 0.16,
        decoration: BoxDecoration(
          color: ColorUtility.lightGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(width: size.width * 0.03),
            const Icon(
              Icons.egg,
              size: 33,
              color: Colors.orangeAccent,
            ),
            SizedBox(width: size.width * 0.03),
            Text("$name", style: CustomTextStyle.foodTileText),
            const Spacer(flex: 10),
            IconButton(
              icon: Icon(Icons.remove, color: ColorUtility.lightCarminePink),
              onPressed: removeOnPressed,
            ),
            Text("$count", style: CustomTextStyle.foodTileText),
            IconButton(
              icon: Icon(
                Icons.add,
                color: ColorUtility.lightCarminePink,
              ),
              onPressed: addOnPressed,
            ),
            SizedBox(width: size.width * 0.01)
          ],
        ),
      ),
    );
  }
}

class InsulinCounter extends StatelessWidget {
  final int insulinCount;
  final bool isInclude;
  final bool createdDefaultData;
  const InsulinCounter({
    super.key,
    required this.size,
    required this.insulinCount,
    required this.isInclude,
    required this.createdDefaultData,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.44,
      height: size.width * 0.44,
      decoration: BoxDecoration(
        // insülin miktarı sayacı
        shape: BoxShape.circle,
        color: ColorUtility.lightCarminePink,
      ),
      child: Column(
        children: [
          const Spacer(flex: 3),
          Row(
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/icon/needle.svg',
                color: Colors.white,
                width: 50,
                height: 50,
              ),
              Text(insulinCount.toString(),
                  style: CustomTextStyle.circleContainerHead),
              // Icon(Icons.vaccines, color: Colors.white, size: 50).,
              const Spacer()
            ],
          ),
          Text("İnsülin", style: CustomTextStyle.circleContainerSubText),
          Text("Miktarınız", style: CustomTextStyle.circleContainerSubText),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class CarbohydrateCounter extends StatelessWidget {
  final int carbohydrateAmount;
  const CarbohydrateCounter({
    super.key,
    required this.size,
    required this.carbohydrateAmount,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Spacer(
            flex: 5,
          ),
          Text("Alınan Karbonhidrat Miktarı:",
              style: CustomTextStyle.counterTitle),
          const Spacer(
            flex: 4,
          ),
          Text(
            "$carbohydrateAmount g",
            style: CustomTextStyle.counter,
          ),
          const Spacer(
            flex: 5,
          )
        ],
      ),
    );
  }
}

class SelectCalendar extends StatelessWidget {
  const SelectCalendar({
    super.key,
    required this.size,
    this.onTap,
  });

  final Size size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculateViewModel>(
      builder: (context, calculateState, child) {
        return SizedBox(
          height: size.height * 0.1,
          width: size.width,
          child: Row(
            children: [
              const Spacer(flex: 2),
              Text("Tarih Seç", style: CustomTextStyle.title),
              const Spacer(flex: 8),
              MainButton(
                // tarih seçme butonu
                large: false,
                icon: Icons.calendar_month,
                text:
                    '${calculateState.selectedDate.day}.${calculateState.selectedDate.month}.${calculateState.selectedDate.year}',
                onTap: onTap,
              ),
              const Spacer(flex: 2),
            ],
          ),
        );
      },
    );
  }
}
