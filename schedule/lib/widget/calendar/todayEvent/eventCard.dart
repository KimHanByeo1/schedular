import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:scadule/component/deleteSchedule.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:scadule/widget/calendar/todayEvent/eventContents.dart';

class EventCard extends StatefulWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ReorderableListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.notPastEventList.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              controller.notPastEventList.insert(
                newIndex,
                controller.notPastEventList.removeAt(oldIndex),
              );
              ScheduleServices().updateEventList(controller.notPastEventList);
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: null,
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      DeleteSchedule().showDeleteEventDialog(
                        context,
                        controller.notPastEventList[index].id!,
                        ['calendar', 'notPast'],
                      );
                    },
                    backgroundColor: const Color.fromARGB(255, 248, 112, 112),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: '삭제',
                  ),
                ],
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: EventContents(
                  controller.notPastEventList[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
