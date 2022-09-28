import 'package:cybear_jinni/domain/binding/value_objects_routine_cbj.dart';
import 'package:cybear_jinni/domain/core/value_objects.dart';
import 'package:cybear_jinni/infrastructure/bindings/binding_cbj_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'binding_cbj_entity.freezed.dart';

@freezed
class BindingCbjEntity with _$BindingCbjEntity {
  const factory BindingCbjEntity({
    /// The unique id of the binding, will alsow be used as the path id of the.
    required UniqueId uniqueId,

    /// Name of the automation, will be shown to the user.
    required BindingCbjName name,
    required BindingCbjBackgroundColor backgroundColor,

    /// All the automation as string.
    required BindingCbjAutomationString automationString,

    /// Node-Red flow id of the scene
    required BindingCbjNodeRedFlowId nodeRedFlowId,

    /// The actual id of the first node, most of the time will be the same as
    /// uniqueId variable.
    required BindingCbjFirstNodeId firstNodeId,

    /// The Unicode code point at which this icon is stored in the icon font.
    required BindingCbjIconCodePoint iconCodePoint,
    required BindingCbjBackgroundImage image,
    required BindingCbjLastDateOfExecute lastDateOfExecute,
    required BindingCbjStateMassage stateMassage,
    required BindingCbjSenderDeviceOs senderDeviceOs,
    required BindingCbjSenderDeviceModel senderDeviceModel,
    required BindingCbjSenderId senderId,
    required BindingCbjCompUuid compUuid,
    required BindingCbjDeviceStateGRPC deviceStateGRPC,
  }) = _BindingCbjEntity;

  const BindingCbjEntity._();

  BindingCbjDtos toInfrastructure() {
    return BindingCbjDtos(
      uniqueId: uniqueId.getOrCrash(),
      name: name.getOrCrash(),
      backgroundColor: backgroundColor.getOrCrash(),
      automationString: automationString.getOrCrash(),
      firstNodeId: firstNodeId.getOrCrash(),
      nodeRedFlowId: nodeRedFlowId.getOrCrash(),
      iconCodePoint: iconCodePoint.getOrCrash(),
      image: image.getOrCrash(),
      lastDateOfExecute: lastDateOfExecute.getOrCrash(),
      deviceStateGRPC: deviceStateGRPC.getOrCrash(),
      senderDeviceModel: senderDeviceModel.getOrCrash(),
      senderDeviceOs: senderDeviceOs.getOrCrash(),
      senderId: senderId.getOrCrash(),
      compUuid: compUuid.getOrCrash(),
      stateMassage: stateMassage.getOrCrash(),
      // serverTimeStamp: FieldValue.serverTimestamp(),
    );
  }
}
