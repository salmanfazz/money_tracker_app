import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker_app/pages/utils/utils.dart';
import 'package:money_tracker_app/static.dart' as Static;

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  Future<void> addData({
    required final amount,
    required final date,
    required final type,
    required final note,
  }) async {
    final res = await client.from('tracker').insert({
      'user_id': client.auth.currentUser!.id,
      'amount': amount,
      'date': date,
      'type': type,
      'note': note
    });
    return res;
  }

  int? amount;
  String note = "Milk";
  String type = "Pemasukan";
  DateTime date = DateTime.now();
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),
        body: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Tambahkan Transaksi",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue),
            ),
            //
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor[800],
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.attach_money,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Rp",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                      } catch (e) {}
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child: TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Static.PrimaryMaterialColor[800],
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        12.0,
                      ),
                      child: Icon(
                        Icons.date_range,
                        size: 24.0,
                        // color: Colors.grey[700],
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      "${date.day} ${months[date.month - 1]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor[800],
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.moving_sharp,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: ChoiceChip(
                    label: Text(
                      "Pemasukan",
                      style: TextStyle(
                        fontSize: 22.0,
                        color:
                        type == "Pemasukan" ? Colors.white : Colors.white,
                      ),
                    ),
                    selectedColor: Colors.green,
                    selected: type == "Pemasukan" ? true : false,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          type = "Pemasukan";
                          if (note.isEmpty || note == "Pengeluaran") {
                            note = 'Pemasukan';
                          }
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: ChoiceChip(
                    label: Text(
                      "Pengeluaran",
                      style: TextStyle(
                        fontSize: 22.0,
                        color:
                        type == "Pemasukan" ? Colors.white : Colors.white,
                      ),
                    ),
                    selectedColor: Colors.red[700],
                    selected: type == "Pengeluaran" ? true : false,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          type = "Pengeluaran";
                          if (note.isEmpty || note == "Pengeluaran") {
                            note = 'Pengeluaran';
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Static.PrimaryMaterialColor[800],
                      borderRadius: BorderRadius.circular(16.0)),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.description,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Keterangan",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    onChanged: (val) {
                      note = val;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {

                  if (amount != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                    print(formattedDate.toString());
                    addData(
                        amount: amount, date: formattedDate.toString(), type: type, note: note);
                    Navigator.of(context).pop();
                  } else {
                    print("Not ");
                  }
                },
                child: Text(
                  "Tambah",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}
