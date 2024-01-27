import 'package:crypto_swift/home.dart';
import 'package:crypto_swift/model/user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(
        user: User(
          id: null,
          name: null,
          walletAddress: null,
        ),
      ),
    ),
  );
}

// HomeScreen(user: User(id: '1001', name: "Dhruv R Jain", walletAddress: '0xjguwg7tg3288cbw8y8b3b8ybw8db'))
