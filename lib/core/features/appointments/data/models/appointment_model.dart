import 'package:myapp/core/features/location/data/models/location_model.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  AppointmentModel(
      {required super.appointmentStatus,
      required super.appointmentType,
      required super.bloodGroup,
      required super.appointmentParticipantId,
      required super.appointmentCreaterId,
      required super.appointmentLocation,
      required super.appointmentCreaterPhoneNo,
      required super.appointmentOtherPartyType,
      required super.appointmentDateTime,
      required super.fetchedAppointmentID,
      super.appointmentCase,
      super.bloodBags,
      required super.appointmentDateTimeCreated,
      required super.appointmentParticipantName,
      required super.appointmentCreaterName,
      required super.createrIsCompleted,
      required super.participantIsCompleted});

  factory AppointmentModel.fromJson(Map<String, dynamic> map) {
    return AppointmentModel(
        appointmentStatus: Appointment.getAppointmentStatusFromString(
            map['appointmentStatus']),
        appointmentType:
            Appointment.getAppointmentTypeFromString(map['appointmentType']),
        bloodGroup: map['bloodGroup'],
        appointmentParticipantId: map['appointmentParticipantId'],
        appointmentCreaterId: map['appointmentCreaterId'],
        appointmentLocation: LocationModel(
            latitude: map['latitude'],
            longitude: map['longitude'],
            address: map['address']),
        appointmentCreaterPhoneNo: map['appointmentCreaterPhoneNo'],
        appointmentOtherPartyType:
            Appointment.getAppointmentOtherPartyFromString(
                map['appointmentOtherPartyType']),
        appointmentDateTime: map['appointmentDateTime']?.toDate(),
        fetchedAppointmentID: map['appointmentId'],
        appointmentCase: map['appointmentCase'] == null
            ? null
            : Appointment.getAppointmentCaseFromString(map['appointmentCase']),
        bloodBags: map['bloodBags'],
        appointmentDateTimeCreated: map['appointmentDateTimeCreated'].toDate(),
        appointmentParticipantName: map['appointmentParticipantName'],
        appointmentCreaterName: map['appointmentCreaterName'],
        createrIsCompleted: map['createrIsCompleted'],
        participantIsCompleted: map['participantIsCompleted']);
  }

  factory AppointmentModel.fromAppointment(Appointment appointment) {
    return AppointmentModel(
      appointmentStatus: appointment.appointmentStatus,
      appointmentType: appointment.appointmentType,
      bloodGroup: appointment.bloodGroup,
      appointmentParticipantId: appointment.appointmentParticipantId,
      appointmentCreaterId: appointment.appointmentCreaterId,
      appointmentLocation: appointment.appointmentLocation,
      appointmentCreaterPhoneNo: appointment.appointmentCreaterPhoneNo,
      appointmentOtherPartyType: appointment.appointmentOtherPartyType,
      appointmentDateTime: appointment.appointmentDateTime,
      fetchedAppointmentID: appointment.appointmentID,
      appointmentCase: appointment.appointmentCase,
      bloodBags: appointment.bloodBags,
      appointmentDateTimeCreated: appointment.appointmentDateTimeCreated,
      appointmentParticipantName: appointment.appointmentParticipantName,
      appointmentCreaterName: appointment.appointmentCreaterName,
      participantIsCompleted: appointment.participantIsCompleted,
      createrIsCompleted: appointment.createrIsCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentStatus':
          Appointment.getAppointmentStatusAsString(appointmentStatus),
      'appointmentType':
          Appointment.getAppointmentTypeAsString(appointmentType),
      'bloodGroup': bloodGroup,
      'appointmentParticipantId': appointmentParticipantId,
      'appointmentCreaterId': appointmentCreaterId,
      'latitude': appointmentLocation.latitude,
      'longitude': appointmentLocation.longitude,
      'address': appointmentLocation.address,
      'appointmentCreaterPhoneNo': appointmentCreaterPhoneNo,
      'appointmentOtherPartyType': Appointment.getAppointmentOtherPartyAsString(
          appointmentOtherPartyType),
      'appointmentDateTime': appointmentDateTime,
      'appointmentId': appointmentID,
      'appointmentCase': appointmentCase != null
          ? Appointment.getAppointmentCaseAsString(appointmentCase!)
          : null,
      'bloodBags': bloodBags,
      'appointmentDateTimeCreated': appointmentDateTimeCreated,
      'appointmentParticipantName': appointmentParticipantName,
      'appointmentCreaterName': appointmentCreaterName,
      'createrIsCompleted': createrIsCompleted,
      'participantIsCompleted': participantIsCompleted
    };
  }

  static Map<String, dynamic> updateAppointmentStatus(
      AppointmentStatus appointmentStatus) {
    return {
      'appointmentStatus':
          Appointment.getAppointmentStatusAsString(appointmentStatus),
    };
  }

  static Map<String, dynamic> updateAppointmentStatusAndTime(
      AppointmentStatus appointmentStatus, DateTime dateTime) {
    return {
      'appointmentStatus':
          Appointment.getAppointmentStatusAsString(appointmentStatus),
      'appointmentDateTime': dateTime
    };
  }
}
