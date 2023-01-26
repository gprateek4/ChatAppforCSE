// Container(
//      margin: EdgeInsets.all(10),
//      padding: EdgeInsets.all(10),
//      decoration: BoxDecoration(
//        border: Border.all(),
//        borderRadius: BorderRadius.circular(12),
//      ),
//      child:
//      Container(
//        padding: EdgeInsets.all(10),
//        child:
//        Column(
//          children: [
//            Text(
//              que,
//              style: TextStyle(
//                  fontSize: 18
//              ),
//            ),
//            Divider(),
//            RadioListTile(
//              title: Text(opt1),
//              value: "op1",
//              groupValue: option,
//              onChanged: (value){
//                setState(() {
//                  option = value.toString();
//                });
//              },
//            ),
//            RadioListTile(
//              title: Text(opt2),
//              value: "op2",
//              groupValue: option,
//              onChanged: (value){
//                setState(() {
//                  option = value.toString();
//                });
//              },
//            ),
//          ],
//        ),
//      ),
//    ),