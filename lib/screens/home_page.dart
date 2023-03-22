import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchful/services/cloud/cloud_incident.dart';
import 'package:watchful/services/cloud/firebase_cloud_storage.dart';
import 'package:watchful/widgets/drawer.dart';
import 'package:watchful/widgets/incident_card.dart';

const primaryColor = 0xFF304529;
const secondaryColor = 0xFFFFFDD0;

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
    }

    setState(() {
      _displayedIncidents = results.toList();
    });
  }

  void _emptyIncidents() {
    setState(() {
      _allIncidents = const Iterable.empty();
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
                    emptyIncidents: _emptyIncidents,
                  ),
                ],
            body: TabBarView(
              children: [
                const FeatureNotAvailable(),
                _allIncidents.isEmpty
                    ? StreamBuilder(
                        stream: _incidentsService.allIncidents(),
                        builder: ((context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                _allIncidents =
                                    snapshot.data as Iterable<CloudIncident>;
                                _displayedIncidents = _allIncidents.toList();
                                if (_displayedIncidents.isEmpty) {
                                  return const NoIncidents();
                                }

                                return IncidentList(
                                    displayedIncidents: _allIncidents.toList());
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            default:
                              return const Center(
                                  child: CircularProgressIndicator());
                          }
                        }))
                    : _displayedIncidents.isEmpty
                        ? const NoIncidents()
                        : IncidentList(displayedIncidents: _displayedIncidents),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _emptyIncidents();
          Navigator.pushNamed(context, "addIncident");
        },
        backgroundColor: const Color(primaryColor),
        child: const Icon(
          Icons.add,
          color: Color(secondaryColor),
        ),
      ),
    );
  }
}

class IncidentList extends StatelessWidget {
  final List<CloudIncident> displayedIncidents;
  const IncidentList({super.key, required this.displayedIncidents});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: displayedIncidents.length,
        itemBuilder: ((_, index) {
          return IncidentCard(
            documentId: displayedIncidents[index].documentId,
            type: displayedIncidents[index].type,
            desc: displayedIncidents[index].desc,
            loc: displayedIncidents[index].loc,
            date: displayedIncidents[index].date,
            img: displayedIncidents[index].img,
            context: context,
          );
        }));
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
            color: Colors.white.withOpacity(0.1),
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 10),
          Text(
            "No incidents reported.",
            style: TextStyle(color: Colors.white.withOpacity(0.25)),
          )
        ],
      ),
    );
  }
}

class FeatureNotAvailable extends StatelessWidget {
  const FeatureNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_very_dissatisfied_rounded,
            size: 100.0,
            color: Colors.white.withOpacity(0.10),
          ),
          const SizedBox(height: 10),
          Text(
            "Feature not yet available.",
            style: TextStyle(color: Colors.white.withOpacity(0.25)),
          )
        ],
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final bool innerBoxIsScrolled;
  final Function filterIncidents;
  final Function emptyIncidents;

  const HomeAppBar(
      {super.key,
      required this.innerBoxIsScrolled,
      required this.filterIncidents,
      required this.emptyIncidents});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      forceElevated: innerBoxIsScrolled,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(primaryColor),
      shadowColor: Theme.of(context).shadowColor,
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      elevation: 8.0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 12.0),
        child: Container(
          width: 100,
          height: 50,
          color: Colors.transparent,
          child: Center(
            child: TextField(
              onChanged: (value) {
                filterIncidents(value);

                if (value.isEmpty) emptyIncidents();
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                  filled: true,
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'Search incidents...',
                  hintStyle: const TextStyle(color: Color(secondaryColor)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(secondaryColor),
                  ),
                  suffixIcon: FirebaseAuth.instance.currentUser!.photoURL !=
                          null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!),
                              radius: 10,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.account_circle_rounded,
                          color: Color(secondaryColor),
                        )),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: TabBar(
          indicator: const UnderlineTabIndicator(
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          labelColor: const Color(secondaryColor),
          unselectedLabelColor: const Color(secondaryColor).withOpacity(0.5),
          tabs: const <Tab>[
            Tab(
              icon: Icon(
                Icons.map_sharp,
                color: Color(secondaryColor),
              ),
              text: "Map",
            ),
            Tab(
              icon: Icon(
                Icons.warning_amber_sharp,
                color: Color(secondaryColor),
              ),
              text: "Incidents",
            ),
          ],
        ),
      ),
    );
  }
}
