// import 'package:flutter/material.dart';
// import 'package:graphic/graphic.dart';

// class StockAnalysisChart extends StatelessWidget {
//   const StockAnalysisChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> data = [
//       {
//         "year": "2013",
//         "category": "Product Level",
//         "value": 600
//       }, // Stock + Surplus
//       {"year": "2013", "category": "Sales", "value": 900},
//       {
//         "year": "2014",
//         "category": "Product Level",
//         "value": 700
//       }, // Stock + Surplus
//       {"year": "2014", "category": "Sales", "value": 500},
//       {
//         "year": "2015",
//         "category": "Product Level",
//         "value": 1100
//       }, // Stock + Surplus
//       {"year": "2015", "category": "Sales", "value": 800},
//       {
//         "year": "2016",
//         "category": "Product Level",
//         "value": 1300
//       }, // Stock + Surplus
//       {"year": "2016", "category": "Sales", "value": 900},
//       {
//         "year": "2017",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2017", "category": "Sales", "value": 600},
//       {
//         "year": "2018",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2018", "category": "Sales", "value": 600},
//       {
//         "year": "2019",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2019", "category": "Sales", "value": 800},
//       {
//         "year": "2020",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2020", "category": "Sales", "value": 1600},
//       {
//         "year": "2021",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2021", "category": "Sales", "value": 700},
//       {
//         "year": "2022",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2022", "category": "Sales", "value": 1000},
//       {
//         "year": "2023",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2023", "category": "Sales", "value": 300},
//       {
//         "year": "2024",
//         "category": "Product Level",
//         "value": 900
//       }, // Stock + Surplus
//       {"year": "2024", "category": "Sales", "value": 600},
//     ];

//     return Container(
//       height: 400,
//       width: double.infinity,
//       padding: const EdgeInsets.all(8.0),
//       child: Chart(
//         data: data,
//         tooltip: TooltipGuide(),
//         variables: {
//           'year': Variable(
//             accessor: (Map map) => map['year'] as String,
//           ),
//           'value': Variable(
//             accessor: (Map map) => map['value'] as num,
//           ),
//           'category': Variable(
//             accessor: (Map map) => map['category'] as String,
//           ),
//         },
//         marks: [
//           IntervalMark(
//             position: Varset('year') * Varset('value'),
//             color: ColorEncode(
//               variable: 'category',
//               values: [
//                 const Color(0xff0046CD),
//                 const Color(0xff24A005)
//               ], // Product Level (Blue), Sales (Orange)
//             ),
//             modifiers: [
//               DodgeModifier()
//             ], // ✅ Ensures two separate bars per year
//           ),
//         ],
//         axes: [
//           Defaults.horizontalAxis,
//           Defaults.verticalAxis,
//         ],
//         selections: {
//           'hover': PointSelection(
//             dim: Dim.x,
//             on: {GestureType.hover},
//             nearest: true,
//           ),
//         },
//       ),
//     );
//   }
// }
