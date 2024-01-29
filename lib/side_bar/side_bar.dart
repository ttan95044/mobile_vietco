import 'package:flutter/material.dart';
import 'package:mobile_vietco/screen/map_view_screen.dart';
import 'package:mobile_vietco/screen/qr_code/qr_code.dart';
// import 'package:testapp1/test.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const UserProfileRow(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  SidebarItem(icon: Icons.map, text: 'Map'),
                  SizedBox(height: 10),
                  SidebarItem(icon: Icons.qr_code, text: 'QR code'),
                  SizedBox(height: 10),
                  SidebarItem(
                      icon: Icons.chat_bubble_outline, text: 'Messages'),
                  SizedBox(height: 10),
                  SidebarItem(icon: Icons.bookmark_border, text: 'Saved'),
                  SizedBox(height: 10),
                  SidebarItem(icon: Icons.favorite_border, text: 'Favorites'),
                  SizedBox(height: 10),
                  SidebarItem(icon: Icons.lightbulb_outline, text: 'Hint'),
                ],
              ),
            ),
            const LogoutRow(),
          ],
        ),
      ),
    );
  }
}

class UserProfileRow extends StatelessWidget {
  const UserProfileRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const Image(
              fit: BoxFit.cover,
              image: AssetImage('asset/test.jpg'),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Side bar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text == 'Map') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapViewScreen()),
          );
        }
        if (text == 'QR code') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrCode()),
          );
        }
        // Xử lý khi người dùng chọn mục trong sidebar
        print('Selected: $text');
      },
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 20),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class LogoutRow extends StatelessWidget {
  const LogoutRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.cancel,
          color: Colors.white.withOpacity(0.5),
        ),
        Text(
          'Log out',
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const NewRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
