import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yazar/local_database.dart';
import 'package:yazar/model/book.dart';

class Books extends StatefulWidget {
  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  LocalDatabase _localDatabase = LocalDatabase();

  List<Book> _books = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildBookAddFab(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Books"),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(future: _getAllBooks(), builder: _buildListView);
  }

  Widget _buildListView(BuildContext context, AsyncSnapshot<void> snapshot) {
    return ListView.builder(
        itemCount: _books.length, itemBuilder: _buildListItem);
  }

  Widget? _buildListItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          _books[index].id.toString(),
        ),
      ),
      title: Text(_books[index].name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _updateBook(context, index);
            },
          ), IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteBook(index);
            },
          ),
        ],
      ),
    );
  }

  void _updateBook(BuildContext context, int index) async {
    String? _newBookName = await _showBookDialog(context);

    if (_newBookName != null) {
      Book book = _books[index];
      book.name = _newBookName;
      int lineCount = await _localDatabase.updateBook(book);
      if (lineCount > 0) {
        setState(() {});
      }
    }
  }

  Widget _buildBookAddFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addBook(context),
      child: Icon(Icons.add),
    );
  }

  void _addBook(BuildContext context) async {
    String? _bookName = await _showBookDialog(context);

    if (_bookName != null) {
      Book newBook = Book(_bookName, DateTime.now());
      int bookID = await _localDatabase.createBook(newBook);
      print("Books ID: $bookID");
      setState(() {});
    }
  }

  void _deleteBook(int index) async {
    Book book = _books[index];
    int _deletedLineCount = await _localDatabase.deleteBook(book);
    if (_deletedLineCount > 0) {
      setState(() {});
    }
  }

  Future<void> _getAllBooks() async {
    _books = await _localDatabase.readBook();
  }

  Future<String?> _showBookDialog(BuildContext context) {
    String? sonuc = "";
    return showDialog<String?>(
        context: context,
        builder: (context) => AlertDialog(
              alignment: Alignment.center,
              title: Text("Enter the book name:"),
              content: TextField(
                onChanged: (text) => sonuc = text,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () => Navigator.pop(context, sonuc),
                    child: Text("Okay"))
              ],
            ));
  }
}
