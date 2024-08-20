class Medication {
  final int? id;
  final String name;
  final int amount;
  final String type;
  final TimeOfDay time;

  Medication({
    this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type,
      'time': time.format(),
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      type: map['type'],
      time: TimeOfDay.fromDateTime(DateTime.parse(map['time'])),
    );
  }
}
