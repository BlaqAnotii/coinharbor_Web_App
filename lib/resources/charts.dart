// lib/widgets/candle_chart_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:coinharbor/services/api_services.dart';
import 'package:coinharbor/data/model/chart_model.dart';

class CandleChartWidget extends StatefulWidget {
  final String coinId;
  final String vsCurrency;
  final int days;
  final Duration refreshInterval;

  /// How many candles should be visible initially — higher => thinner candles.
  final int initialVisibleCandleCount;

  const CandleChartWidget({
    super.key,
    required this.coinId,
    this.vsCurrency = 'usd',
    this.days = 1,
    this.refreshInterval = const Duration(seconds: 30),
    this.initialVisibleCandleCount =
        800, // 👈 Increase this for thinner candles
  });

  @override
  State<CandleChartWidget> createState() =>
      _CandleChartWidgetState();
}

class _CandleChartWidgetState extends State<CandleChartWidget> {
  final ApiService _apiService = ApiService();
  List<CandleData> _candles = [];
  bool _loading = true;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadCandles();
    _timer = Timer.periodic(
        widget.refreshInterval, (_) => _loadCandles());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadCandles() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final List<Candle> raw = await _apiService.fetchOHLC(
        coinId: widget.coinId,
        vsCurrency: widget.vsCurrency,
        days: widget.days,
      );

      if (raw.isEmpty) {
        setState(() {
          _candles = [];
          _loading = false;
          _error = 'No data';
        });
        return;
      }

      raw.sort((a, b) => a.time.compareTo(b.time));

      final list = raw.map((c) {
        return CandleData(
          timestamp: c.time.millisecondsSinceEpoch,
          open: c.open,
          high: c.high,
          low: c.low,
          close: c.close,
          volume: 0.0,
        );
      }).toList();

      setState(() {
        _candles = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _formatPrice(num? p) {
    if (p == null) return '-';
    if (p >= 1000) return p.toStringAsFixed(0);
    if (p >= 1) return p.toStringAsFixed(2);
    return p.toStringAsFixed(6);
  }

  String _formatTimeLabel(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (widget.days <= 1) return DateFormat('HH:mm').format(dt);
    return DateFormat('MM/dd').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _candles.isEmpty) {
      return const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null && _candles.isEmpty) {
      return SizedBox(
        height: 260,
        child: Center(
            child: Text('Error: $_error',
                style: const TextStyle(color: Colors.red))),
      );
    }
    if (_candles.isEmpty) {
      return const SizedBox(
        height: 260,
        child: Center(child: Text('No data available')),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // 👈 Light theme background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          SizedBox(
            height: 360,
            child: InteractiveChart(
              candles: _candles,
              initialVisibleCandleCount:
                  widget.initialVisibleCandleCount,
              style: ChartStyle(
                volumeHeightFactor: 0.18,
                priceLabelWidth: 56,
                timeLabelHeight: 22,
                timeLabelStyle: const TextStyle(
                    fontSize: 11, color: Colors.black87),
                priceLabelStyle: const TextStyle(
                    fontSize: 11, color: Colors.black87),
                overlayTextStyle: const TextStyle(
                    fontSize: 12, color: Colors.black),
                priceGainColor: Colors.green,
                priceLossColor: Colors.red,
                volumeColor: Colors.grey.shade400,
                priceGridLineColor: Colors.grey.shade200,
                selectionHighlightColor:
                    Colors.blue.withOpacity(0.1),
                overlayBackgroundColor: Colors.white,
              ),
              timeLabel: (int timestamp, int visibleDataCount) =>
                  _formatTimeLabel(timestamp),
              priceLabel: (double price) => _formatPrice(price),
              overlayInfo: (CandleData candle) {
                return {
                  'Time': DateFormat('yyyy-MM-dd HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          candle.timestamp)),
                  'Open': _formatPrice(candle.open),
                  'High': _formatPrice(candle.high),
                  'Low': _formatPrice(candle.low),
                  'Close': _formatPrice(candle.close),
                  if (candle.volume != null)
                    'Vol': candle.volume!.toStringAsFixed(0),
                };
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Updated ${DateFormat('HH:mm:ss').format(DateTime.now())}',
            style: const TextStyle(
                fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final last = _candles.isNotEmpty ? _candles.last : null;
    final prev = _candles.length > 1
        ? _candles[_candles.length - 2]
        : null;
    final lastPrice = last?.close ?? 0.0;
    final prevPrice = prev?.close ?? lastPrice;
    final diff = lastPrice - prevPrice;
    final pct = prevPrice != 0 ? (diff / prevPrice * 100) : 0.0;
    final color = diff >= 0 ? Colors.green : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            '${widget.coinId.toUpperCase()} / ${widget.vsCurrency.toUpperCase()}',
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_formatPrice(lastPrice),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(
                '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(2)}  (${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%)',
                style: TextStyle(color: color, fontSize: 12)),
          ],
        )
      ],
    );
  }
}
