import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  bool _isSearching = false;

  final List<String> _recent = ['Горный велосипед', 'Shimano', 'BMX'];
  final List<String> _trending = [
    '🚵 Горные велосипеды Trek',
    '⚡ Электровелосипеды',
    '🔧 Shimano запчасти',
    '🚴 BMX трюковые',
    '🛡️ Шлемы и защита',
    '🔦 Велофонари'
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final results = _isSearching ? state.filteredProducts : [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            state.setSearchQuery('');
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Поиск велосипедов...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _controller.clear();
                      state.setSearchQuery('');
                      setState(() => _isSearching = false);
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            state.setSearchQuery(val);
            setState(() => _isSearching = val.isNotEmpty);
          },
          onSubmitted: (val) {
            if (val.isNotEmpty) setState(() => _isSearching = true);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                state.setSearchQuery(_controller.text);
                setState(() => _isSearching = true);
              }
            },
            child: const Text('Найти',
                style: TextStyle(color: Color(0xFF1B5E20))),
          ),
        ],
      ),
      body: _isSearching
          ? results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('Ничего не найдено',
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: results.length,
                  itemBuilder: (_, i) => ProductCard(product: results[i]),
                )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_recent.isNotEmpty) ...[
                    Row(
                      children: [
                        const Text(
                          'История поиска',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _recent.clear()),
                          child: Icon(Icons.delete_outline,
                              color: Colors.grey[400], size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _recent.map((r) {
                        return GestureDetector(
                          onTap: () {
                            _controller.text = r;
                            state.setSearchQuery(r);
                            setState(() => _isSearching = true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(r, style: const TextStyle(fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Text(
                    '🔥 Популярные запросы',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _trending.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      dense: true,
                      leading: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: i < 3
                              ? const Color(0xFF1B5E20)
                              : Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      title: Text(_trending[i]),
                      trailing:
                          Icon(Icons.trending_up, color: Colors.grey[400]),
                      onTap: () {
                        final query = _trending[i].replaceAll(RegExp(r'[🔥⚡💻👗🏠🎮] '), '');
                        _controller.text = query;
                        state.setSearchQuery(query);
                        setState(() => _isSearching = true);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
