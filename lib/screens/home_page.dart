import 'package:flutter/material.dart';
import 'package:watchful/services/cloud/cloud_incident.dart';
import 'package:watchful/services/cloud/firebase_cloud_storage.dart';
import 'package:watchful/widgets/drawer.dart';
import 'package:watchful/widgets/home_appbar.dart';
import 'package:watchful/widgets/incident_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseCloudStorage _incidentsService;

  @override
  void initState() {
    _incidentsService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const Drawer(
        child: CustomDrawer(),
      ),
      body: StreamBuilder(
          stream: _incidentsService.allIncidents(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allIncidents = snapshot.data as Iterable<CloudIncident>;
                  if (allIncidents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/no_content.png",
                            color: Colors.black.withOpacity(0.1),
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "No incidents reported.",
                          )
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: allIncidents.length,
                      itemBuilder: ((context, index) {
                        final incident = allIncidents.elementAt(index);
                        return IncidentCard(
                            type: incident.type,
                            desc: incident.desc,
                            loc: incident.loc,
                            date: incident.date,
                            img: incident.img);
                      }));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          })),
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
