import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_calculator_app/injection_container.dart' as di; // Added import for di.sl
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: BlocProvider(
        create: (context) => di.sl<HistoryBloc>()..add(FetchHistoryEvent()), // Use di.sl instead of HistoryBloc()
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) return Center(child: CircularProgressIndicator());
            if (state is HistoryLoaded) {
              return ListView.builder(
                itemCount: state.histories.length,
                itemBuilder: (context, index) {
                  final history = state.histories[index];
                  return ListTile(
                    title: Text('${history['type']} - ${history['total']} ₹'),
                    subtitle: Text(history['timestamp']),
                  );
                },
              );
            }
            if (state is HistoryError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No history yet'));
          },
        ),
      ),
    );
  }
}