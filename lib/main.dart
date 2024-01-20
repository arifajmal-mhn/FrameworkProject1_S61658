import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(RegisterBookApp());
}

class RegisterBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register Book',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme:
              GoogleFonts.wixMadeforTextTextTheme(Theme.of(context).textTheme)),
      home: WelcomeScreen(), // Set the WelcomeScreen as the initial screen
      routes: {
        '/bookList': (context) => BookListScreen(),
        '/addBook': (context) => AddBookScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/welcomeBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4), // Adjust opacity for shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6), // Shadow color
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: const Offset(0, 3), // Offset
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Welcome to',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const Text(
                    'BookVault',
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/bookList');
                    },
                    child: const Text(
                      'Enter',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Map<String, dynamic>> registeredBooks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFeeeeee),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF090A0D),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Registered Books',
          style:
              TextStyle(color: Color(0xFF090A0D), fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: registeredBooks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              registeredBooks[index]['title'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${registeredBooks[index]['author']} - ${registeredBooks[index]['publicationDate']}',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookDetailsScreen(book: registeredBooks[index]),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updatedBook = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookScreen(
                          book: registeredBooks[index],
                        ),
                      ),
                    );

                    if (updatedBook != null) {
                      setState(() {
                        registeredBooks[index] = updatedBook;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      registeredBooks.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF090A0D),
        label: const Text('Add New Book'),
        onPressed: () async {
          final newBook = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBookScreen(),
            ),
          );

          if (newBook != null) {
            setState(() {
              registeredBooks.add(newBook);
            });
          }
        },
        // child: Text('Add New Book'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class EditBookScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  // Declare variables for genre and shelf numbers
  List<String> genres = [
    'Choose a book genre',
    'Action and Adventure',
    'Classics',
    'Comic Book or Graphic Novel',
    'Detective and Mystery',
    'Fantasy',
    'Historical Fiction',
    'Horror',
    'Romance',
    'Science Fiction',
    'History',
  ];
  List<String> shelfNumbers = ['Choose a shelf number', 'A1', 'B2', 'C3', 'D4'];

  String selectedGenre = ''; // Default genre
  String selectedShelfNumber = ''; // Default shelf number

  EditBookScreen({required this.book}) {
    // Assign initial values from book data or default values
    selectedGenre = book['genre'] ?? genres[0];
    selectedShelfNumber = book['shelfNumber'] ?? shelfNumbers[0];
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: book['title']);
    TextEditingController authorController =
        TextEditingController(text: book['author']);
    TextEditingController isbnController =
        TextEditingController(text: book['isbn']);
    TextEditingController publisherController =
        TextEditingController(text: book['publisher']);
    TextEditingController publicationDateController =
        TextEditingController(text: book['publicationDate']);
    TextEditingController editionController =
        TextEditingController(text: book['edition'].toString());
    TextEditingController synopsisController =
        TextEditingController(text: book['synopsis']);
    TextEditingController shelfNumberController =
        TextEditingController(text: book['shelfNumber']);

    // TextEditingController genreController =
    //     TextEditingController(text: book['genre']);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF090A0D),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Book',
          style:
              TextStyle(color: Color(0xFF090A0D), fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            TextFormField(
              controller: isbnController,
              decoration: const InputDecoration(labelText: 'ISBN'),
            ),
            TextFormField(
              controller: publisherController,
              decoration: const InputDecoration(labelText: 'Publisher'),
            ),
            TextFormField(
              controller: publicationDateController,
              decoration: const InputDecoration(labelText: 'Publication Date'),
            ),
            TextFormField(
              controller: editionController,
              decoration: const InputDecoration(labelText: 'Edition'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: selectedGenre,
              items: genres.map((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  selectedGenre = value;
                }
              },
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            TextFormField(
              controller: synopsisController,
              decoration: const InputDecoration(labelText: 'Synopsis'),
            ),
            DropdownButtonFormField<String>(
              value: selectedShelfNumber,
              items: shelfNumbers.map((String shelfNumber) {
                return DropdownMenuItem<String>(
                  value: shelfNumber,
                  child: Text(shelfNumber),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  selectedShelfNumber = value;
                }
              },
              decoration: const InputDecoration(labelText: 'Shelf Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF090A0D),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              onPressed: () {
                String title = titleController.text;
                String author = authorController.text;
                String isbn = isbnController.text;
                String publisher = publisherController.text;
                String publicationDate = publicationDateController.text;
                int edition = int.tryParse(editionController.text) ??
                    1; // Default to 1 if parsing fails
                String synopsis = synopsisController.text;
                String shelfNumber = selectedShelfNumber;

                Map<String, dynamic> updatedBook = {
                  'title': title,
                  'author': author,
                  'isbn': isbn,
                  'publisher': publisher,
                  'publicationDate': publicationDate,
                  'edition': edition,
                  'genre': selectedGenre,
                  'synopsis': synopsis,
                  'shelfNumber': shelfNumber,
                };

                Navigator.pop(context, updatedBook);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  BookDetailsScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF090A0D),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Book Details',
          style:
              TextStyle(color: Color(0xFF090A0D), fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${book['title']}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  '${book['author']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 1),
                Text(
                  '${book['publicationDate']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Edition ${book['edition']}    |    ${book['genre']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //   'Genre: ${book['genre']}',
                //   style: const TextStyle(
                //     fontSize: 40,
                //     fontWeight: FontWeight.w900,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 20),
                Text(
                  'Publisher: ${book['publisher']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Shelf Number: ${book['shelfNumber']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'ISBN: ${book['isbn']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Expanded(
                //   // child: SingleChildScrollView(
                // child: Column(
                // children: [
                Text(
                  'Synopsis:',
                  style: GoogleFonts.baskervville(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  '${book['synopsis']}',
                  style: GoogleFonts.baskervville(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                // ],
                // ),
                // ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddBookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController isbnController = TextEditingController();
    TextEditingController publisherController = TextEditingController();
    TextEditingController publicationDateController = TextEditingController();
    TextEditingController editionController = TextEditingController();
    TextEditingController synopsisController = TextEditingController();
    TextEditingController shelfNumberController = TextEditingController();

    // List of genres and shelf numbers for dropdown menus
    List<String> genres = [
      'Choose a book genre',
      'Action and Adventure',
      'Classics',
      'Comic Book or Graphic Novel',
      'Detective and Mystery',
      'Fantasy',
      'Historical Fiction',
      'Horror',
      'Romance',
      'Science Fiction',
      'History',
    ]; // Add your own genres
    List<String> shelfNumbers = [
      'Choose a shelf number',
      'A1',
      'B2',
      'C3',
      'D4'
    ];

    String selectedGenre = genres[0]; // Default genre
    String selectedShelfNumber = shelfNumbers[0]; // Default shelf number

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF090A0D),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Add Book',
          style:
              TextStyle(color: Color(0xFF090A0D), fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              TextFormField(
                controller: isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
              ),
              TextFormField(
                controller: publisherController,
                decoration: const InputDecoration(labelText: 'Publisher'),
              ),
              TextFormField(
                controller: publicationDateController,
                decoration:
                    const InputDecoration(labelText: 'Publication Date'),
              ),
              TextFormField(
                controller: editionController,
                decoration: const InputDecoration(labelText: 'Edition'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: selectedGenre,
                items: genres.map((String genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    selectedGenre = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Genre'),
              ),
              TextFormField(
                controller: synopsisController,
                decoration: const InputDecoration(labelText: 'Synopsis'),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: selectedShelfNumber,
                items: shelfNumbers.map((String shelfNumber) {
                  return DropdownMenuItem<String>(
                    value: shelfNumber,
                    child: Text(shelfNumber),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    selectedShelfNumber = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Shelf Number'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF090A0D),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
                onPressed: () {
                  String title = titleController.text;
                  String author = authorController.text;
                  String isbn = isbnController.text;
                  String publisher = publisherController.text;
                  String publicationDate = publicationDateController.text;
                  int edition = int.tryParse(editionController.text) ??
                      1; // Default to 1 if parsing fails
                  String synopsis = synopsisController.text;
                  String shelfNumber = selectedShelfNumber;

                  Map<String, dynamic> newBook = {
                    'title': title,
                    'author': author,
                    'isbn': isbn,
                    'publisher': publisher,
                    'publicationDate': publicationDate,
                    'edition': edition,
                    'genre': selectedGenre,
                    'synopsis': synopsis,
                    'shelfNumber': shelfNumber,
                  };

                  Navigator.pop(context, newBook);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
