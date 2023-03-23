import 'package:flutter/material.dart';


class HonorPage extends StatelessWidget {
  const HonorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: RankList(ranks: [Rank(name: "张三", score: 10),Rank(name: "李四", score: 10),Rank(name: "name", score: 10),Rank(name: "name", score: 10),Rank(name: "name", score: 10),Rank(name: "name", score: 10),Rank(name: "name", score: 10),Rank(name: "name", score: 10)],),
    );
  }
}

class Rank {
  final String name;
  final int score;

  Rank({required this.name, required this.score});
}

class RankList extends StatefulWidget {
  final List<Rank> ranks;

  const RankList({required this.ranks});

  @override
  _RankListState createState() => _RankListState();
}

class _RankListState extends State<RankList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.ranks.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Text(
              "${index + 1}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            title: Text(widget.ranks[index].name),
            trailing: Text(widget.ranks[index].score.toString()),
          ),
        );
      },
    );
  }
}

class RankScreen extends StatelessWidget {
  final List<Rank> ranks = [
    Rank(name: "Jack", score: 80),
    Rank(name: "Tom", score: 70),
    Rank(name: "Linda", score: 90),
    Rank(name: "Mike", score: 60),
    Rank(name: "Amy", score: 85),
    Rank(name: "Bob", score: 75),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ranking"),
      ),
      body: RankList(ranks: ranks),
    );
  }
}
