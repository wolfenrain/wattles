class SchemaValue {
  SchemaValue(this._oldValue) : _newValue = _oldValue;

  dynamic _oldValue;

  dynamic _newValue;

  /// Returns true if this schema value has been modified.
  bool get isModified => _oldValue != _newValue;

  dynamic get value => _newValue;
  set value(dynamic value) => _newValue = value;

  void persist() => _oldValue = _newValue;

  @override
  String toString() => '$value';
}
