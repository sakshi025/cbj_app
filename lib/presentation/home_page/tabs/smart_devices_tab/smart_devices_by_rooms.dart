import 'package:cybear_jinni/application/devices/device_watcher/device_watcher_bloc.dart';
import 'package:cybear_jinni/application/lights/device_actor/lights_actor_bloc.dart';
import 'package:cybear_jinni/domain/devices/device_entity.dart';
import 'package:cybear_jinni/infrastructure/core/gen/smart_device/client/protoc_as_dart/smart_connection.pb.dart';
import 'package:cybear_jinni/infrastructure/core/gen/smart_device/client/protoc_as_dart/smart_connection.pbgrpc.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/core/theme_data.dart';
import 'package:cybear_jinni/presentation/home_page/tabs/smart_devices_tab/devices_in_the_room_blocks/blinds_in_the_room.dart';
import 'package:cybear_jinni/presentation/home_page/tabs/smart_devices_tab/devices_in_the_room_blocks/lights_in_the_room_block.dart';
import 'package:cybear_jinni/presentation/lights/widgets/critical_light_failure_display_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmartDevicesByRooms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceWatcherBloc, DeviceWatcherState>(
        builder: (context, state) {
      return state.map(
        initial: (_) => Container(),
        loadInProgress: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        loadSuccess: (state) {
          if (state.devices.size != 0) {
            final List<Color> _gradientColor = GradientColors.sky;
            final Map<String, List<DeviceEntity>> tempDevicesByRooms =
                <String, List<DeviceEntity>>{};

            for (int i = 0; i < state.devices.size; i++) {
              final DeviceEntity tempDevice = state.devices[i];
              if (tempDevicesByRooms[tempDevice.roomId.getOrCrash()] == null) {
                tempDevicesByRooms[tempDevice.roomId.getOrCrash()] = [
                  tempDevice
                ];
              } else {
                tempDevicesByRooms[tempDevice.roomId.getOrCrash()]
                    .add(tempDevice);
              }
            }

            final Map<String, Map<String, List<DeviceEntity>>>
                tempDevicesByRoomsByType =
                <String, Map<String, List<DeviceEntity>>>{};

            final Map<String, List<DeviceEntity>> tempDevicesByType =
                <String, List<DeviceEntity>>{};

            tempDevicesByRooms.forEach((k, v) {
              tempDevicesByRoomsByType[k] = {};
              v.forEach((element) {
                if (tempDevicesByRoomsByType[k][element.type.getOrCrash()] ==
                    null) {
                  tempDevicesByRoomsByType[k]
                      [element.type.getOrCrash()] = [element];
                } else {
                  tempDevicesByRoomsByType[k][element.type.getOrCrash()]
                      .add(element);
                }
              });
            });

            int gradientColorCounter = -1;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Home Name',
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Divider(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      thickness: 1,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final String roomId =
                            tempDevicesByRoomsByType.keys.elementAt(index);

                        int numberOfDevicesInTheRoom = 0;

                        tempDevicesByRoomsByType[roomId].forEach((key, value) {
                          value.forEach((element) {
                            numberOfDevicesInTheRoom++;
                          });
                        });

                        return Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Room Name',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
                              ),
                            ),
                            if (numberOfDevicesInTheRoom == 1)
                              Text(
                                '$numberOfDevicesInTheRoom device',
                                style: const TextStyle(fontSize: 12),
                              )
                            else
                              Text(
                                '$numberOfDevicesInTheRoom devices',
                                style: const TextStyle(fontSize: 12),
                              ),
                            GridView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 1.2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 4),
                                itemCount: tempDevicesByRoomsByType[roomId]
                                    .keys
                                    .length,
                                itemBuilder: (BuildContext ctx, secondIndex) {
                                  final String deviceType =
                                      tempDevicesByRoomsByType[roomId]
                                          .keys
                                          .elementAt(secondIndex);
                                  if (deviceType ==
                                      DeviceTypes.Light.toString()) {
                                    return BlocProvider(
                                      create: (context) =>
                                          getIt<LightsActorBloc>(),
                                      child: LightsInTheRoomBlock(
                                          tempDevicesByRoomsByType[roomId]
                                              [deviceType]),
                                    );
                                  } else if (deviceType ==
                                      DeviceTypes.Blinds.toString()) {
                                    return BlocProvider(
                                      create: (context) =>
                                          getIt<LightsActorBloc>(),
                                      child: BlindsInTheRoom(
                                          tempDevicesByRoomsByType[roomId]
                                              [deviceType]),
                                    );
                                  }
                                  return const Text('Not Supported');
                                }),
                            Divider(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              height: 0,
                            ),
                          ],
                        );
                      },
                      itemCount: tempDevicesByRoomsByType.keys.length,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Expanded(
                child: FlatButton(
              onPressed: () {},
              color: Colors.black,
              child: const Text(
                  'No lights have been found.\nPlease add new light'),
            ));
          }
        },
        loadFailure: (state) {
          return CriticalLightFailureDisplay(
            failure: state.devicesFailure,
          );
        },
        error: (Error value) {
          return const Text('Error');
        },
      );
    });
  }
}