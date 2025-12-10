import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Analytics Dashboard",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOP SUMMARY CARDS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summaryCard("Total Revenue", "₹85,450", Colors.blue),
                summaryCard("Orders", "540", Colors.green),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summaryCard("Users", "1,320", Colors.orange),
                summaryCard("Providers", "90", Colors.purple),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Monthly Revenue Growth",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            monthlyRevenueChart(),

            const SizedBox(height: 32),
            const Text("Orders Comparison",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ordersBarChart(),

            const SizedBox(height: 32),
            const Text("Recent Activities",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            recentActivity("New order placed", "2 mins ago"),
            recentActivity("Service Updated", "10 mins ago"),
            recentActivity("Employee added", "25 mins ago"),
            recentActivity("Order Complete", "1 hr ago"),
            recentActivity("User joined", "3 hr ago"),
          ],
        ),
      ),
    );
  }

  /*️⃣ Summary Card */
  Widget summaryCard(String title, String value, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
            colors: [color.withOpacity(.9), color.withOpacity(.6)],
            begin: Alignment.topLeft,end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(color: color.withOpacity(.4), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.analytics, color: Colors.white, size: 28),
          const SizedBox(height: 15),
          Text(value, style: const TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.white70,fontSize: 14)),
        ],
      ),
    );
  }

  /*️⃣ Line Chart - Monthly Revenue */
  Widget monthlyRevenueChart() {
    return Container(
      height: 230,
      decoration: BoxDecoration(
          color: Colors.white,borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 8)]),
      padding: const EdgeInsets.all(16),

      child: LineChart(LineChartData(
        backgroundColor: Colors.white,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul"];
                return Text(months[value.toInt()],style: const TextStyle(fontSize: 12));
              })),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true,color: Colors.blue.withOpacity(.2)),
            spots: const [
              FlSpot(0,30), FlSpot(1,40), FlSpot(2,55),
              FlSpot(3,70), FlSpot(4,95), FlSpot(5,80), FlSpot(6,110),
            ],
          )
        ],
      )),
    );
  }

  /*️⃣ Bar Chart - Orders Data */
  Widget ordersBarChart() {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 8)]),
      child: BarChart(BarChartData(
        borderData: FlBorderData(show:false),
        gridData: FlGridData(show:false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles:true,getTitlesWidget:(v,meta){
                const list=["Mon","Tue","Wed","Thu","Fri","Sat"];
                return Text(list[v.toInt()],style: const TextStyle(fontSize: 12));
              })),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles:false)),
        ),
        barGroups: [
          bar(0,35), bar(1,48), bar(2,72), bar(3,60), bar(4,80), bar(5,65),
        ],
      )),
    );
  }

  BarChartGroupData bar(int x,double y)=>BarChartGroupData(
      x:x,
      barRods:[ BarChartRodData(toY:y,color: Colors.deepPurple,borderRadius: BorderRadius.circular(6),width:18) ]
  );

  /*️⃣ Recent logs UI */
  Widget recentActivity(String title,String time){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black12,blurRadius:6)]),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.notifications,color: Colors.blue)),

          const SizedBox(width: 12),
          Expanded(child: Text(title,style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(time,style: const TextStyle(color: Colors.grey,fontSize: 12)),
        ],
      ),
    );
  }
}
