import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/add_post_screen.dart';
import 'package:instagram_clone_flutter/screens/feed_screen.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/screens/search_screen_2.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreenTest(),
  const AddPostScreen(),
  const Center(
      child: Text(
    'Notifications',
    style: TextStyle(fontSize: 32),
  )),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
