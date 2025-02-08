enum StatusAP { empty, loading, failure, success }

abstract class BaseState {
  StatusAP get status;
  String? get error;
}
