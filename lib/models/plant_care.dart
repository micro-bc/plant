import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PlantCareModel extends ChangeNotifier with EquatableMixin {
  int? _period;
  DateTime _last;

  @override
  List<Object?> get props => [_period, _last];

  PlantCareModel({
    int? period,
    DateTime? last,
  })  : _period = period,
        _last = last ?? DateTime.now() {
    if ((period ?? 1) < 1) throw ArgumentError('Period must be >= 1 or null');
  }

  PlantCareModel clone() => PlantCareModel(
        period: _period,
        last: _last,
      );

  Map<String, dynamic> toJson() => {
        'period': _period,
        'last': _last.toIso8601String(),
      };

  PlantCareModel.fromJson(Map<String, dynamic> json)
      : this(
          period: json['period'],
          last: json['last'] == null ? null : DateTime.tryParse(json['last']),
        );

  void updateLast() {
    _last = DateTime.now();
    notifyListeners();
  }

  int? get period => _period;
  DateTime get last => _last;

  DateTime? get nextCare =>
      _period == null ? null : _last.add(Duration(days: _period!));

  int? get daysTillCare => nextCare
      ?.add(const Duration(hours: 12))
      .difference(DateTime.now())
      .inDays;

  set period(int? period) {
    if ((period ?? 1) < 1) throw ArgumentError('Period must be >= 1 or null');
    _period = period;
    notifyListeners();
  }
}
