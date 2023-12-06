import 'package:flutter/material.dart';
import 'dart:core';
import 'api_service.dart';
import 'detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tyba Frontend Engineer Test',
      home: const MyHomePage(),
      routes: {
        '/details': (context) => const DetailScreen(item: {}),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _data = [];
  bool _isListView = true;
  int _visibleDataCount = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchData().then((data) {
      setState(() {
        _data = data;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    setState(() {
      _visibleDataCount += 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities'),
      ),
      body: _data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _isListView
              ? _buildListView()
              : _buildGridView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isListView = !_isListView;
          });
        },
        child: Icon(_isListView ? Icons.grid_view : Icons.list),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _visibleDataCount.clamp(0, _data.length),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_data[index]['name']),
          onTap: () {
            _navigateToDetailScreen(_data[index]);
          },
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _visibleDataCount.clamp(0, _data.length),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            _navigateToDetailScreen(_data[index]);
          },
          child: Card(
            child: Center(
              child: Text(_data[index]['name']),
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetailScreen(Map<String, dynamic> selectedItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: selectedItem),
      ),
    );
  }
}
