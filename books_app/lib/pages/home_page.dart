import 'package:books_app/providers/auth.dart';
import 'package:books_app/providers/books_provider.dart';
import 'package:books_app/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
      ),
      drawer: Drawer(
          child: context.watch<AuthProvider>().isAuth
              ? ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Text(
                          "Welcome ${context.watch<AuthProvider>().user.username}"),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                    ListTile(
                      title: const Text("Logout"),
                      trailing: const Icon(Icons.logout),
                      onTap: () {
                        context.read<AuthProvider>().logout();
                      },
                    ),
                  ],
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      title: const Text("Signin"),
                      trailing: const Icon(Icons.login),
                      onTap: () {
                        context.push("/signin");
                      },
                    ),
                    ListTile(
                      title: const Text("Signup"),
                      trailing: const Icon(Icons.how_to_reg),
                      onTap: () {
                        context.push("/signup");
                      },
                    )
                  ],
                )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/add');
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Add a new Book"),
                ),
              ),
            ),
            FutureBuilder(
              future:
                  Provider.of<BooksProvider>(context, listen: false).getBooks(),
              builder: (context, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    return const Center(
                      child: Text('An error occurred'),
                    );
                  } else {
                    return Consumer<BooksProvider>(
                      builder: (context, booksProvider, child) =>
                          ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(), // <- Here
                              itemCount: booksProvider.books.length,
                              itemBuilder: (context, index) =>
                                  BookCard(book: booksProvider.books[index])),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
