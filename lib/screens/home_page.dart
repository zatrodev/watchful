import 'dart:developer';

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
  Iterable<CloudIncident> _allIncidents = const Iterable.empty();
  List<CloudIncident> _displayedIncidents = [];

  @override
  void initState() {
    _incidentsService = FirebaseCloudStorage();
    super.initState();
  }

  void _filterIncidents(String keyword) {
    Iterable<CloudIncident> results;
    if (keyword.isEmpty) {
      results = _allIncidents;
    } else {
      results = _allIncidents.where((incident) =>
          incident.loc.toLowerCase().contains(keyword.toLowerCase()));
      log(results.toString());
    }

    setState(() {
      _displayedIncidents = results.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: CustomDrawer(),
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            HomeAppBar(
              innerBoxIsScrolled: innerBoxIsScrolled,
              filterIncidents: _filterIncidents,
            ),
          ],
          body: _allIncidents.isEmpty
              ? StreamBuilder(
                  stream: _incidentsService.allIncidents(),
                  builder: ((context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          log("message");
                          _allIncidents =
                              snapshot.data as Iterable<CloudIncident>;
                          _displayedIncidents = _allIncidents.toList();
                          if (_displayedIncidents.isEmpty) {
                            return const NoIncidents();
                          }

                          return IncidentList(
                              displayedIncidents: _displayedIncidents);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  }))
              : _displayedIncidents.isEmpty
                  ? const NoIncidents()
                  : IncidentList(displayedIncidents: _displayedIncidents),
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

class IncidentList extends StatelessWidget {
  final List<CloudIncident> displayedIncidents;
  const IncidentList({super.key, required this.displayedIncidents});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          shrinkWrap: true,
          itemCount: displayedIncidents.length,
          itemBuilder: ((context, index) {
            return IncidentCard(
                type: displayedIncidents[index].type,
                desc: displayedIncidents[index].desc,
                loc: displayedIncidents[index].loc,
                date: displayedIncidents[index].date,
                img: displayedIncidents[index].img);
          })),
    );
  }
}

class NoIncidents extends StatelessWidget {
  const NoIncidents({super.key});

  @override
  Widget build(BuildContext context) {
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
          Text(
            "No incidents reported.",
            style: TextStyle(color: Colors.black.withOpacity(0.25)),
          )
        ],
      ),
    );
  }
}
