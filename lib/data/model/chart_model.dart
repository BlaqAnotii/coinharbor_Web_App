class Candle {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory Candle.fromList(List<dynamic> arr) {
    return Candle(
      time: DateTime.fromMillisecondsSinceEpoch(arr[0] as int),
      open: (arr[1] as num).toDouble(),
      high: (arr[2] as num).toDouble(),
      low: (arr[3] as num).toDouble(),
      close: (arr[4] as num).toDouble(),
    );
  }
}
