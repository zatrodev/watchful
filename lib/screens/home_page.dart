import 'package:flutter/material.dart';
import 'package:watchful/widgets/drawer.dart';
import 'package:watchful/widgets/home_appbar.dart';
import 'package:watchful/widgets/incident_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const Drawer(
        child: CustomDrawer(),
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(children: const [
            IncidentCard(
              type: "Car-napping",
              description:
                  "May isang lalaking pinipilit buksan yung pintuan ng kotse dito",
              location: "Binangonan, Rizal",
              image: "assets/images/sample1.jpg",
              date: "1/13/23",
            ),
            IncidentCard(
              type: "Car Accident",
              description: "A car accident happened on my way to school",
              location: "Taytay, Rizal",
              image: "assets/images/sample2.jpg",
              date: "1/13/23",
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "addIncident");
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
