import 'package:crypto_swift/home.dart';
import 'package:crypto_swift/login.dart';
import 'package:crypto_swift/model/user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomeScreen(
        user: User(
          id: '1001',
          name: "Dhruv R Jain",
          walletAddress: '0xjguwg7tg3288cbw8y8b3b8ybw8db',
        ),
      ),
    ),
  );
}

// HomeScreen(user: User(id: '1001', name: "Dhruv R Jain", walletAddress: '0xjguwg7tg3288cbw8y8b3b8ybw8db'))
