import 'package:flutter/material.dart';

class AddPostLiveScreen extends StatelessWidget {
  const AddPostLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.live_tv),
              label: const Text('Get Live'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.post_add),
              label: const Text('Make Post'),
            ),
          ],
        ),
      ),
    );
  }
}
