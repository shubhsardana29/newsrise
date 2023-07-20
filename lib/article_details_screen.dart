import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'news_article.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final NewsArticle article;
  final int index;
  final Function(NewsArticle article, bool isSaved) onArticleSaved;

  const ArticleDetailsScreen({
    required this.article,
    required this.index,
    required this.onArticleSaved,
  });

  @override
  _ArticleDetailsScreenState createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _startFadeInAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startFadeInAnimation() {
    _animationController.forward();
  }

  void _openArticleURL() async {
    final url = widget.article.url;
    if (await canLaunch(url!)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

void _toggleSavedState() {
  setState(() {
    widget.article.isSaved = !widget.article.isSaved;
  });
  widget.onArticleSaved(widget.article, widget.article.isSaved);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
        actions: [
          IconButton(
            onPressed: _toggleSavedState,
            icon: Icon(
              widget.article.isSaved ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value.clamp(0.0, 1.0), // Clamp the opacity value within the valid range
              child: GestureDetector(
                onTap: () {}, // Disable opening the URL on tap
                child: Hero(
                  tag: 'news_item_${widget.index}',
                  child: Container(
                    // Your article details UI
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.article.title ?? '',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          widget.article.publishedAt ?? '',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          widget.article.description ?? '',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () => _openArticleURL(),
                          child: Text('Read Full Article'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
