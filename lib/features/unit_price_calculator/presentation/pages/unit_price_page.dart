import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/unit_price_bloc.dart';
import '../bloc/unit_price_event.dart';
import '../bloc/unit_price_state.dart';

class UnitPricePage extends StatefulWidget {
  @override
  _UnitPricePageState createState() => _UnitPricePageState();
}

class _UnitPricePageState extends State<UnitPricePage> {
  final _formKey = GlobalKey<FormState>();
  final _items = <Map<String, TextEditingController>>[];
  final _newItem = {'name': TextEditingController(), 'quantity': TextEditingController(), 'totalPrice': TextEditingController()};

  @override
  void initState() {
    super.initState();
    _addItem();
  }

  void _addItem() {
    setState(() {
      _items.add(Map.from(_newItem));
      _newItem['name'] = TextEditingController();
      _newItem['quantity'] = TextEditingController();
      _newItem['totalPrice'] = TextEditingController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unit Price Calculator', style: TextStyle(fontWeight: FontWeight.bold))),
      body: BlocListener<UnitPriceBloc, UnitPriceState>(
        listener: (context, state) {
          if (state is UnitPriceError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is UnitPriceCalculated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('History saved!')));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ..._items.map((item) => Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(child: TextFormField(controller: item['name']!, decoration: InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                              SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: item['quantity']!, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Qty'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                              SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: item['totalPrice']!, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Price'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: CircleBorder(), padding: EdgeInsets.all(15)),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final items = _items.map((item) {
                        final qty = double.tryParse(item['quantity']!.text) ?? 0.0;
                        final price = double.tryParse(item['totalPrice']!.text) ?? 0.0;
                        return {
                          'name': item['name']!.text,
                          'quantity': qty,
                          'totalPrice': price,
                        };
                      }).where((item) {
                        final qty = item['quantity'] as double;
                        final price = item['totalPrice'] as double;
                        return qty > 0 && price > 0; // Safe comparison after casting
                      }).toList();
                      if (items.isNotEmpty) {
                        context.read<UnitPriceBloc>().add(CalculateUnitPriceEvent(items));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add valid items to calculate')));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 12)),
                  child: Text('Calculate', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && context.read<UnitPriceBloc>().currentResult != null) {
                      context.read<UnitPriceBloc>().add(SaveUnitPriceHistoryEvent());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calculate first or check inputs')));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 12)),
                  child: Text('Save History', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                BlocBuilder<UnitPriceBloc, UnitPriceState>(
                  builder: (context, state) {
                    if (state is UnitPriceCalculated) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.only(top: 20),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ...state.result.items.map((item) => Text('${item.name}: ${item.unitPrice.toStringAsFixed(2)} ₹/unit', style: TextStyle(fontSize: 16))),
                              Text('Total Amount: ${state.result.totalAmount.toStringAsFixed(2)} ₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}