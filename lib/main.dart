import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_calculator_app/injection_container.dart' as di;
import 'features/cash_calculator/presentation/bloc/cash_bloc.dart';
import 'features/unit_price_calculator/presentation/bloc/unit_price_bloc.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/history/presentation/bloc/history_event.dart'; // Added this import
import 'features/cash_calculator/presentation/pages/cash_page.dart';
import 'features/unit_price_calculator/presentation/pages/unit_price_page.dart';
import 'features/history/presentation/pages/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<CashBloc>()),
        BlocProvider(create: (_) => di.sl<UnitPriceBloc>()),
        BlocProvider(create: (_) => di.sl<HistoryBloc>()..add(FetchHistoryEvent())), // Now recognized
      ],
      child: MaterialApp(
        title: 'Multi Calculator',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/cash': (context) => CashPage(),
          '/unit_price': (context) => UnitPricePage(),
          '/history': (context) => HistoryPage(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multi Calculator', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: Icon(Icons.calculate, color: Colors.blue),
                title: Text('Cash Calculator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pushNamed(context, '/cash'),
              ),
            ),
            SizedBox(height: 15),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: Icon(Icons.price_change, color: Colors.green),
                title: Text('Unit Price Calculator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pushNamed(context, '/unit_price'),
              ),
            ),
            SizedBox(height: 15),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: Icon(Icons.history, color: Colors.orange),
                title: Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}