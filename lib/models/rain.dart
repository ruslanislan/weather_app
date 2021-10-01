class Rain {
  Rain({
    required this.the1H,
  });

  final double? the1H;

  factory Rain.fromJson(Map<dynamic, dynamic> json) => Rain(
    the1H: json["1h"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "1h": the1H,
  };
}
