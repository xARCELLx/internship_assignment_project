import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cash_bloc.dart';
import '../bloc/cash_event.dart';
import '../bloc/cash_state.dart';

class CashPage extends StatefulWidget {
  @override
  _CashPageState createState() => _CashPageState();
}

class _CashPageState extends State<CashPage> {
  final Map<int, int> _quantities = {2000: 0, 500: 0, 200: 0, 100: 0, 50: 0, 20: 0, 10: 0};
  int _selectedDenom = 2000;

  void _increment() => setState(() => _quantities[_selectedDenom] = (_quantities[_selectedDenom] ?? 0) + 1);
  void _decrement() => setState(() => _quantities[_selectedDenom] = (_quantities[_selectedDenom] ?? 0) > 0 ? _quantities[_selectedDenom]! - 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cash Calculator', style: TextStyle(fontWeight: FontWeight.bold))),
      body: BlocListener<CashBloc, CashState>(
        listener: (context, state) {
          if (state is CashError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButton<int>(
                        value: _selectedDenom,
                        items: _quantities.keys.map((denom) => DropdownMenuItem(value: denom, child: Text('$denom ₹'))).toList(),
                        onChanged: (value) => setState(() => _selectedDenom = value!),
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        dropdownColor: Colors.white,
                        iconEnabledColor: Colors.blue,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: Icon(Icons.remove_circle, color: Colors.red), onPressed: _decrement),
                          Text('${_quantities[_selectedDenom]}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          IconButton(icon: Icon(Icons.add_circle, color: Colors.green), onPressed: _increment),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.read<CashBloc>().add(CalculateCashEvent(Map.from(_quantities))),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 12)),
                child: Text('Calculate', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => context.read<CashBloc>().add(SaveCashHistoryEvent()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 12)),
                child: Text('Save History', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              BlocBuilder<CashBloc, CashState>(
                builder: (context, state) {
                  if (state is CashCalculated) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Total Notes: ${state.result.totalNotes} ₹', style: TextStyle(fontSize: 18)),
                            Text('Total Coins: ${state.result.totalCoins} ₹', style: TextStyle(fontSize: 18)),
                            Text('Grand Total: ${state.result.grandTotal} ₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}