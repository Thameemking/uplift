import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicScreen extends StatelessWidget {
  final List<Map<String, dynamic>> musicList = [
    {
      'title': 'Calm Meditation',
      'artist': 'Peaceful Mind',
      'duration': '5:30',
      'url': 'https://open.spotify.com/track/2pUhY7tWx8egpw2qn84iSi',
      'color': Colors.blue,
    },
    {
      'title': 'Sleep Sounds',
      'artist': 'Nature Sounds',
      'duration': '8:45',
      'url': 'https://open.spotify.com/track/2pUhY7tWx8egpw2qn84iSi',
      'color': Colors.purple,
    },
    {
      'title': 'Stress Relief',
      'artist': 'Healing Music',
      'duration': '6:15',
      'url': 'https://open.spotify.com/track/2pUhY7tWx8egpw2qn84iSi',
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 20),
                  itemCount: musicList.length,
                  itemBuilder: (context, index) {
                    final music = musicList[index];
                    return _buildMusicCard(context, music);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Music Therapy',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicCard(BuildContext context, Map<String, dynamic> music) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: music['color'].withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: music['color'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.music_note,
            color: music['color'],
          ),
        ),
        title: Text(
          music['title'],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${music['artist']} • ${music['duration']}',
          style: GoogleFonts.poppins(
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.play_circle_fill, color: music['color']),
          onPressed: () => _launchSpotify(music['url']),
        ),
      ),
    );
  }

  Future<void> _launchSpotify(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}