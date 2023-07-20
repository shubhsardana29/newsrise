import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';
import 'article_details_screen.dart';
import 'authscreen.dart';
import 'news_article.dart';

class NewsScreen extends StatefulWidget {
  final String name;
  NewsScreen({required this.name});
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with WidgetsBindingObserver{
  bool _isLoading = false;
  List<NewsArticle> _articles = [];
  List<NewsArticle> _recentlyViewedArticles = [];
  List<NewsArticle> _recentlyViewedOrder = [];
  List<NewsArticle> _savedArticles = [];
  String _error = '';
  CarouselController _carouselController = CarouselController();
  Timer? _timer;
  int _currentIndex = 0;
  int _autoSwipeInterval = 3000; // Interval in milliseconds (3 seconds)
  TextEditingController _searchController = TextEditingController();
  List<NewsArticle> _searchResults = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    fetchNews();
    fetchSavedArticles(); // Fetch saved articles from Cloud Firestore
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _startAutoSwiping(); // Start auto-swiping after the widgets are built
    });
  }

  Future<void> fetchNews() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final articlesData = await ApiService.fetchNews();
      List<NewsArticle> articles = articlesData
          .map((articleData) => NewsArticle.fromMap(articleData))
          .toList();

      // Sort the articles by date in reverse chronological order
      articles
          .sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));

      setState(() {
        _articles = articles;
        _isLoading = false;
      });

      _startAutoSwiping();
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch news. Please try again.';
      });
    }
  }

  Future<void> fetchSavedArticles() async {
  final user = _auth.currentUser;
  final userId = user?.uid;

  if (userId != null) {
    try {
      final bookmarksCollection =
          FirebaseFirestore.instance.collection('bookmarks');
      final querySnapshot = await bookmarksCollection
          .where('userId', isEqualTo: userId)
          .get();

      final List<String> savedArticleIds = querySnapshot.docs
          .map((document) => document['articleId'] as String)
          .toList();

      setState(() {
        _savedArticles = _articles
            .where((article) => savedArticleIds.contains(article.id))
            .toList();
      });
    } catch (e) {
      // Handle the error
      print('Error fetching saved articles: $e');
    }
  }
}

Future<void> _unbookmarkArticle(NewsArticle article) async {
  final user = _auth.currentUser;
  final userId = user?.uid;

  if (userId != null) {
    try {
      final bookmarksCollection =
          FirebaseFirestore.instance.collection('bookmarks');
      final querySnapshot = await bookmarksCollection
          .where('articleId', isEqualTo: article.id)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentId = querySnapshot.docs.first.id;
        await bookmarksCollection.doc(documentId).delete();
        // Show a success message or perform any other desired actions
      }
    } catch (e) {
      // Handle the error
      print('Error unbookmarking article: $e');
    }
  }
}

Future<void> _updateBookmarkStatus(NewsArticle article, bool isSaved) async {
  final user = _auth.currentUser;
  final userId = user?.uid;

  if (userId != null) {
    try {
      final bookmarksCollection = FirebaseFirestore.instance.collection('bookmarks');
      if (isSaved) {
        await bookmarksCollection.add({
          'articleId': article.id,
          'userId': userId,
          'timestamp': DateTime.now(),
        });
      } else {
        final querySnapshot = await bookmarksCollection
            .where('articleId', isEqualTo: article.id)
            .where('userId', isEqualTo: userId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final documentId = querySnapshot.docs.first.id;
          await bookmarksCollection.doc(documentId).delete();
        }
      }
      // Show a success message or perform any other desired actions
    } catch (e) {
      // Handle the error
      print('Error updating bookmark status: $e');
    }
  }
}

Future<void> _saveArticle(NewsArticle article) async {
  _savedArticles.add(article);
  await _updateBookmarkStatus(article, true);
}



Future<void> _bookmarkArticle(NewsArticle article) async {
  final user = _auth.currentUser;
  final userId = user?.uid;

  if (userId != null) {
    try {
      await FirebaseFirestore.instance.collection('bookmarks').add({
        'articleId': article.id,
        'userId': userId,
        'timestamp': DateTime.now(),
      });
      // Show a success message or perform any other desired actions
    } catch (e) {
      // Handle the error
      print('Error bookmarking article: $e');
    }
  }
}




void _removeSavedArticle(NewsArticle article) async {
  setState(() {
    _savedArticles.remove(article);
  });

  // Remove the bookmark from the Cloud Firestore
  await _unbookmarkArticle(article);
}


void _startAutoSwiping() {
  if (_articles.isNotEmpty) {
    _timer = Timer.periodic(Duration(milliseconds: _autoSwipeInterval), (_) {
      if (_currentIndex < _articles.length - 1) {
        setState(() {
          _currentIndex++; // Update the current index without rebuilding the entire widget tree
        });
      } else {
        setState(() {
          _currentIndex = 0; // Reset the current index to 0
        });
        _carouselController.jumpToPage(0); // Jump to the first item
      }
    });
  }
}


  void _stopAutoSwiping() {
    _timer?.cancel();
  }

  Future<void> _refreshNews() async {
    await fetchNews();
  }

void _performSearch(String keyword) {
  setState(() {
    if (keyword.isEmpty) {
      // If the search keyword is empty, show all recently viewed articles
      _searchResults = [];
    } else {
      // Filter recently viewed articles by title and publishedAt containing the keyword
      _searchResults = _recentlyViewedOrder.where((article) {
        final title = article.title?.toLowerCase() ?? '';
        final publishedAt = article.publishedAt?.toLowerCase() ?? '';
        return title.contains(keyword.toLowerCase()) ||
            publishedAt.contains(keyword.toLowerCase());
      }).toList();
    }
  });
}


  void _openArticleDetails(NewsArticle article, int index) {
    // Open article details screen
    _stopAutoSwiping();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetailsScreen(
          article: article,
          index: index,
          onArticleSaved: (article, isSaved) {
            if (isSaved) {
              _saveArticle(article);
            } else {
              _removeSavedArticle(article);
            }
          },
        ),
      ),
    ).then((_) {
      setState(() {
      _startAutoSwiping();
        _updateRecentlyViewed(article);
      });
    });
  }

  void _updateRecentlyViewed(NewsArticle article) {
    setState(() {
      _recentlyViewedArticles.remove(article);
      _recentlyViewedArticles.insert(0, article);

      _recentlyViewedOrder.remove(article);
      _recentlyViewedOrder.add(article);
    });
  }


  Widget _buildCarouselTab() {
    return Column(
      children: [
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _error,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: fetchNews,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshNews,
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        items: _articles.map((article) {
                          return GestureDetector(
                            onTap: () =>
                                _openArticleDetails(article, _articles.indexOf(article)),
                            child: Container(
                              margin: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: _getCardColor(_articles.indexOf(article)),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Stack(
                                children: [
                                  if (article.urlToImage != null &&
                                      Uri.tryParse(article.urlToImage!)?.isAbsolute == true)
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: Image.network(
                                          article.urlToImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  else
                                    Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black87,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            article.publishedAt ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16.0,
                                    right: 16.0,
                                    child: IconButton(
                                      icon: Icon(
                                        article.isSaved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          article.isSaved = !article.isSaved;
                                          if (article.isSaved) {
                                            _saveArticle(article);
                                            _bookmarkArticle(article);
                                          } else {
                                            _removeSavedArticle(article);
                                            _unbookmarkArticle(article);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          initialPage: 0,
                          viewportFraction: 0.85,
                          onPageChanged: (index, _) {
                            setState(() {
                              _articles.removeAt(index);
                              _currentIndex = index;
                            });
                            if (_currentIndex == _articles.length - 1) {
                              _currentIndex = 0;
                              _carouselController.jumpToPage(0);
                            } else {
                              Future.delayed(Duration(milliseconds: _autoSwipeInterval), () {
                                _carouselController.nextPage();
                            });
                          }
                        },
                      ),
                    ),
                  ),
      ),
      SizedBox(height: 16.0),
      Text(
        'Your Saved Articles',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: _savedArticles.length,
          itemBuilder: (BuildContext context, int index) {
            final article = _savedArticles[index];
            return GestureDetector(
              onTap: () => _openArticleDetails(article, _articles.indexOf(article)),
              child: Card(
                color: _getCardColor(index % 3), // Use specific colors for cards
                child: ListTile(
                  title: Text(
                    article.title ?? '',
                    style: TextStyle(
                      color: Colors.black, // Set font color to black
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    article.publishedAt ?? '',
                    style: TextStyle(
                      color: Colors.black, // Set font color to black
                      fontSize: 12.0,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _removeSavedArticle(article);
                      });
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}



 Widget _buildRecentlyViewedTab() {
  // Create a filtered list of recently viewed articles based on the search query
  List<NewsArticle> filteredRecentlyViewedArticles = _searchController.text.isNotEmpty
      ? _recentlyViewedOrder.where((article) {
          final title = article.title?.toLowerCase() ?? '';
          final description = article.publishedAt?.toLowerCase() ?? '';
          return title.contains(_searchController.text.toLowerCase()) ||
              description.contains(_searchController.text.toLowerCase());
        }).toList()
      : _recentlyViewedOrder;

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            _performSearch(value); // Call search function on text change
          },
          decoration: InputDecoration(
            labelText: 'Search',
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear(); // Clear search field
                _performSearch(''); // Reset search
              },
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: filteredRecentlyViewedArticles.length,
          itemBuilder: (BuildContext context, int index) {
            final article = filteredRecentlyViewedArticles[index];
            return ListTile(
              title: Text(article.title ?? ''),
              subtitle: Text(article.publishedAt ?? ''),
              onTap: () => _openArticleDetails(article, _articles.indexOf(article)),
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildSavedArticlesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Your Saved Articles',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _savedArticles.length,
            itemBuilder: (BuildContext context, int index) {
              final article = _savedArticles[index];
              final color = _getCardColor(index);
              return GestureDetector(
                onTap: () =>
                    _openArticleDetails(article, _articles.indexOf(article)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: color, // Use the custom color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio:
                              16 / 9, // Make the image aspect ratio 16:9
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                            child: Image.network(
                              article.urlToImage ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                article.publishedAt ?? '',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

// Custom method to get different colors for each card
  Color _getCardColor(int index) {
    final colors = [
      Color.fromARGB(255, 255, 232, 229),
      Color.fromARGB(255, 255, 242, 197),
      Color.fromARGB(255, 224, 241, 255),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hi ${widget.name}'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _signOut();
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home Page'),
              Tab(text: 'Recently Viewed'),
              Tab(text: 'Saved Articles'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCarouselTab(),
            _buildRecentlyViewedTab(),
            _buildSavedArticlesTab(),
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      // Navigate to the login screen or any other desired screen
      // For example:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthScreen()),
      );
    } catch (e) {
      // Handle sign out errors
      print('Error signing out: $e');
    }
  }

}
