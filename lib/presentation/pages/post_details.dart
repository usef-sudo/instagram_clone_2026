import 'package:flutter/material.dart';
import 'package:instagram_clone/data/models/post_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailsPage extends StatelessWidget {
  final PostModel post;

  const PostDetailsPage({super.key, required this.post});

  Future<void> _launch(Uri uri, BuildContext context) async {
    try {
      await launchUrl(uri);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Could not launch URL")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// IMAGE
          Hero(
            tag: post.image,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(post.image),
            ),
          ),

          const SizedBox(height: 16),

          /// DESCRIPTION
          Text(
            post.description,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          /// MAP
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Open Location"),
            subtitle: Text("${post.latitude}, ${post.longitude}"),
            onTap: () {
              final url = Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query=${post.latitude},${post.longitude}");

              _launch(url, context);
            },
          ),

          const Divider(),

          /// WHATSAPP
          ListTile(
            leading: const Icon(Icons.link),
            title: Text(post.phone),
            subtitle: const Text("Open WhatsApp"),
            onTap: () {
              final url = Uri.parse("https://wa.me/${post.phone}");
              _launch(url, context);
            },
          ),

          /// SMS
          ListTile(
            leading: const Icon(Icons.message),
            title: Text(post.phone),
            subtitle: const Text("Send SMS"),
            onTap: () {
              final url = Uri.parse("sms:${post.phone}");
              _launch(url, context);
            },
          ),

          /// CALL
          ListTile(
            leading: const Icon(Icons.call),
            title: Text(post.phone),
            subtitle: const Text("Call"),
            onTap: () {
              final url = Uri.parse("tel:${post.phone}");
              _launch(url, context);
            },
          ),

          /// EMAIL
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(post.email),
            subtitle: const Text("Send Email"),
            onTap: () {
              final url = Uri.parse(
                  "mailto:${post.email}?subject=Hello from the mobile app&body=Sent from Flutter");

              _launch(url, context);
            },
          ),
        ],
      ),
    );
  }
}