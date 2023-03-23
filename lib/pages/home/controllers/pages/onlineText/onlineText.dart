import 'package:flutter/material.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}
class _ExamPageState extends State<ExamPage> {
  List<Question> _questions = [
    Question(
      title: '问题1',
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
      answer: 'Option A',
    ),
    Question(
      title: '问题2',
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
      answer: 'Option B',
    ),
    Question(
      title: '问题3',
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
      answer: 'Option C',
    ),
  ];
  int _currentIndex = 0;
  int _score = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('在线考试'),
      // ),
      body: Stack(
       // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text("在线考试",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),),
          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          
          Text(
            _questions[_currentIndex].title,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Column(
            children: _questions[_currentIndex]
                .options
                .map((option) => RadioListTile(
                      title: Text(option),
                      value: option,
                      groupValue: _questions[_currentIndex].selected,
                      onChanged: (value) {
                        setState(() {
                          _questions[_currentIndex].selected = value as String?;
                        });
                      },
                    ))
                .toList(),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                child: Text('上一道'),
                onPressed: () {
                  if (_currentIndex > 0) {
                    setState(() {
                      _currentIndex--;
                    });
                  }
                },
              ),
              TextButton(
                child: Text(_isLastQuestion ? '提交答卷' : '下一道'),
                onPressed: _onNextOrSubmitPressed,
              ),
            ],
          ),
        ],
      ),
        ],
      )
    );
  }
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;
  void _onNextOrSubmitPressed() {
    if (_isLastQuestion) {
      _score = _questions.where((q) => q.isCorrect).length;
      // TODO: 实现提交逻辑
      Navigator.pop(context);
    } else {
      setState(() {
        _currentIndex++;
      });
    }
  }
}
class Question {
  String title;
  List<String> options;
  String answer;
  String? selected;
  Question({
    required this.title,
    required this.options,
    required this.answer,
  });
  bool get isCorrect => selected == answer;
}