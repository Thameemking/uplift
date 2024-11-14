import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final List<Map<String, dynamic>> quotes = [
    {
      'text': 'The only way to do great work is to love what you do.',
      'author': 'Steve Jobs',
      'color': Colors.blue,
    },
    {
      'text': 'Believe you can and you\'re halfway there.',
      'author': 'Theodore Roosevelt',
      'color': Colors.purple,
    },
    {
      'text': 'The future belongs to those who believe in the beauty of their dreams.',
      'author': 'Eleanor Roosevelt',
      'color': Colors.green,
    },
  ];

  int currentIndex = 0;

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
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    return _buildQuoteCard(quotes[index]);
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
            'Daily Quotes',
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

  Widget _buildQuoteCard(Map<String, dynamic> quote) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: quote['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: quote['color'].withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.format_quote,
            size: 40,
            color: quote['color'],
          ),
          SizedBox(height: 20),
          Text(
            quote['text'],
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            '- ${quote['author']}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => Share.share('${quote['text']}\n- ${quote['author']}'),
                color: quote['color'],
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  // Add favorite functionality
                },
                color: quote['color'],
              ),
            ],
          ),
        ],
      ),
    );
  }
}