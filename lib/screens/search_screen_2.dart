import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';

class SearchScreenTest extends StatefulWidget {
  const SearchScreenTest({Key? key}) : super(key: key);

  @override
  State<SearchScreenTest> createState() => _SearchScreenTestState();
}

class _SearchScreenTestState extends State<SearchScreenTest> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: isShowUsers
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: (snapshot.data! as dynamic).docs == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photoUrl'],
                                ),
                                radius: 16,
                              ),
                              title: Text(
                                (snapshot.data! as dynamic).docs[index]
                                    ['username'],
                              ),
                            ),
                    );
                  },
                );
              },
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => (snapshot.data! as dynamic)
                              .docs ==
                          null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      :
                      // Image.network(
                      //   (snapshot.data! as dynamic).docs[index]['postUrl'],
                      //   fit: BoxFit.cover,
                      // ),
                      CachedNetworkImage(
                          imageUrl: snapshot.data!.docs[index]['postUrl'],
                          fit: BoxFit.cover),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
