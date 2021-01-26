import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;
  MovieHorizontal({@required this.movies, @required this.nextPage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, i) => _createCard(context, movies[i]),
      ),
    );
  }

  Widget _createCard(BuildContext context, Movie movie) {
    movie.uniqueId = "${movie.id}-footer";
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: movie.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('assets/no-image.jpg'),
                    fit: BoxFit.cover,
                    height: 160.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: movie);
      },
    );
  }

  List<Widget> _tarjetas() {
    return movies.map((movie) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('assets/no-image.jpg'),
                    fit: BoxFit.cover,
                    height: 160.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                movie.title,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      );
    }).toList();
  }
}
