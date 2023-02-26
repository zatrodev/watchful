import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final bool innerBoxIsScrolled;
  final Function filterIncidents;

  const HomeAppBar(
      {super.key,
      required this.innerBoxIsScrolled,
      required this.filterIncidents});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 144,
      forceElevated: innerBoxIsScrolled,
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromRGBO(208, 240, 192, 1),
      shadowColor: Theme.of(context).shadowColor,
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      elevation: 8.0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
        child: Container(
          width: 100,
          height: 50,
          color: Colors.transparent,
          child: Center(
            child: TextField(
              onChanged: (value) => filterIncidents(value),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                  filled: true,
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'Search incidents...',
                  prefixIcon: const Icon(Icons.search),
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
                      : const Icon(Icons.account_circle_rounded)),
            ),
          ),
        ),
      ),
      bottom: const TabBar(
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 2),
            insets: EdgeInsets.symmetric(horizontal: 16.0)),
        indicatorColor: Color(0xFF3e4839),
        labelColor: Colors.black,
        unselectedLabelColor: Color(0xFF3e4839),
        tabs: <Tab>[
          Tab(
            icon: Icon(
              Icons.map_sharp,
              color: Color(0xFF3e4839),
            ),
            text: "Map",
          ),
          Tab(
            icon: Icon(
              Icons.warning_amber_sharp,
              color: Color(0xFF3e4839),
            ),
            text: "Incidents",
          ),
        ],
      ),
    );
  }
}
