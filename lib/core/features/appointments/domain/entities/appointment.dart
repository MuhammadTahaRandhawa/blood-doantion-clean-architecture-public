import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Appointment {
  String appointmentID;
  String bloodGroup;
  int? bloodBags;
  AppointmentType appointmentType;
  AppointmentCase? appointmentCase;
  AppointmentStatus appointmentStatus;
  String appointmentParticipantId;
  String appointmentParticipantName;
  String appointmentCreaterId;
  String appointmentCreaterName;
  String appointmentCreaterPhoneNo;
  Location appointmentLocation;
  AppointmentOtherParty appointmentOtherPartyType;
  DateTime? appointmentDateTime;
  DateTime appointmentDateTimeCreated;
  bool? createrIsCompleted;
  bool? participantIsCompleted;

  Appointment(
      {String? fetchedAppointmentID,
      this.appointmentCase,
      required this.appointmentStatus,
      required this.appointmentType,
      this.bloodBags,
      required this.bloodGroup,
      required this.appointmentParticipantId,
      required this.appointmentCreaterId,
      required this.appointmentLocation,
      required this.appointmentCreaterPhoneNo,
      required this.appointmentOtherPartyType,
      required this.appointmentDateTime,
      required this.appointmentDateTimeCreated,
      required this.appointmentParticipantName,
      required this.appointmentCreaterName,
      required this.createrIsCompleted,
      required this.participantIsCompleted})
      : appointmentID = fetchedAppointmentID ?? uuid.v4();

// Function to convert AppointmentOtherParty enum to string
  static String getAppointmentOtherPartyAsString(
      AppointmentOtherParty appointmentOtherParty) {
    switch (appointmentOtherParty) {
      case AppointmentOtherParty.user:
        return 'user';
      case AppointmentOtherParty.center:
        return 'center';
      default:
        throw ArgumentError('Invalid AppointmentType enum value');
    }
  }

  // Function to convert string to AppointmentOtherParty enum
  static AppointmentOtherParty getAppointmentOtherPartyFromString(String type) {
    switch (type) {
      case 'user':
        return AppointmentOtherParty.user;
      case 'center':
        return AppointmentOtherParty.center;
      default:
        throw ArgumentError('Invalid AppointmentType string value');
    }
  }

// Function to convert AppointmentType enum to string
  static String getAppointmentTypeAsString(AppointmentType type) {
    switch (type) {
      case AppointmentType.donation:
        return 'donation';
      case AppointmentType.request:
        return 'request';
      default:
        throw ArgumentError('Invalid AppointmentType enum value');
    }
  }

// Function to convert string to AppointmentType enum
  static AppointmentType getAppointmentTypeFromString(String type) {
    switch (type) {
      case 'donation':
        return AppointmentType.donation;
      case 'request':
        return AppointmentType.request;
      default:
        throw ArgumentError('Invalid AppointmentType string value');
    }
  }

// Function to convert AppointmentCase enum to string
  static String getAppointmentCaseAsString(AppointmentCase caseType) {
    switch (caseType) {
      case AppointmentCase.accident:
        return 'accident';
      case AppointmentCase.childBirth:
        return 'child birth';
      case AppointmentCase.heartSurgery:
        return 'heart surgery';
      case AppointmentCase.cancer:
        return 'cancer';
      case AppointmentCase.other:
        return 'other';
      default:
        throw ArgumentError('Invalid AppointmentCase enum value');
    }
  }

// Function to convert string to AppointmentCase enum
  static AppointmentCase getAppointmentCaseFromString(String caseType) {
    switch (caseType) {
      case 'accident':
        return AppointmentCase.accident;
      case 'child birth':
        return AppointmentCase.childBirth;
      case 'heart surgery':
        return AppointmentCase.heartSurgery;
      case 'cancer':
        return AppointmentCase.cancer;
      case 'other':
        return AppointmentCase.other;
      default:
        return AppointmentCase.other;
    }
  }

// Function to convert AppointmentStatus enum to string
  static String getAppointmentStatusAsString(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'pending';
      case AppointmentStatus.approved:
        return 'approved';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.inProgress:
        return 'inProgress';
      case AppointmentStatus.completed:
        return 'completed';
      default:
        throw ArgumentError('Invalid AppointmentStatus enum value');
    }
  }

// Function to convert string to AppointmentStatus enum
  static AppointmentStatus getAppointmentStatusFromString(String status) {
    switch (status) {
      case 'pending':
        return AppointmentStatus.pending;
      case 'approved':
        return AppointmentStatus.approved;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'inProgress':
        return AppointmentStatus.inProgress;
      case 'completed':
        return AppointmentStatus.completed;
      default:
        throw ArgumentError('Invalid AppointmentStatus string value');
    }
  }
}

enum AppointmentType { donation, request }

enum AppointmentOtherParty { user, center }

enum AppointmentCase { accident, childBirth, heartSurgery, cancer, other }

enum AppointmentStatus { pending, approved, cancelled, inProgress, completed }
