import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CalculationHistory {
  @HiveField(0)
  final String equation;
  @HiveField(1)
  final String result;

  CalculationHistory(this.equation, this.result);
}

class CalculationHistoryAdapter extends TypeAdapter<CalculationHistory> {
  @override
  final int typeId = 0;

  @override
  CalculationHistory read(BinaryReader reader) {
    final equation = reader.readString();
    final result = reader.readString();
    return CalculationHistory(equation, result);
  }

  @override
  void write(BinaryWriter writer, CalculationHistory history) {
    writer.writeString(history.equation);
    writer.writeString(history.result);
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff22252D),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'Calculation History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: const HistoryList(),
    );
  }
}

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final historyBox = Hive.box<CalculationHistory>('history');
  List<CalculationHistory> getHistory() {
    final List<CalculationHistory> historyList = [];
    for (var i = 0; i < historyBox.length; i++) {
      historyList.add(historyBox.getAt(i)!);
    }
    return historyList;
  }

  void deleteHistory(int index) {
    historyBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final historyBox = Hive.box<CalculationHistory>('history');

    print('history items ${historyBox.length}');
    return ListView.builder(
      itemCount: historyBox.length,
      itemBuilder: (context, index) {
        final historyItem = historyBox.getAt(index)!;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
          ),
          child: ListTile(
            title: Text(
              historyItem.equation,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              historyItem.result,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  deleteHistory(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'History item deleted',
                      style: TextStyle(color: Colors.white),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
