import 'package:flutter/material.dart';
import 'package:second/second.dart';
import 'package:sms/sms.dart';
import 'package:translator/translator.dart';
import '../smsfile.dart';


void main() {
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    
    return MaterialApp(
        title: "Test App",
        home: HomePage(),
        
    );
    
  }
}

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleTranslator translator = GoogleTranslator();
  //TextEditingController controller = TextEditingController();

  void _navigateToNextScreen(BuildContext context,var messageone) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Second(messageone: messageone)));
  }

  SmsQuery query = new SmsQuery();
  List<SmsMessage> allmessages=[];

  @override
  void initState() {
    getAllMessages();
    super.initState();
  }

  void getAllMessages(){
      Future.delayed(Duration.zero,() async {
          List<SmsMessage> messages = await query.querySms( //querySms is from sms package
              kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent, SmsQueryKind.Draft], 
              //filter Inbox, sent or draft messages
              count: 100, //number of sms to read
          );

         setState(() { //update UI
            allmessages = messages; 
         });
          
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
         title: Text("குறுஞ்செய்தி உட்பெட்டி"),
         backgroundColor: Color.fromARGB(255, 246, 100, 2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
	floatingActionButton: FloatingActionButton(
		// isExtended: true,
		child: Icon(Icons.send),
		backgroundColor: Color.fromARGB(255, 246, 100, 2),
		onPressed: () {
      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  smsapp(),
                            ),
                          );
		
		},
	  ),
      body: SingleChildScrollView( 
         child: Container(
          
            
            padding: EdgeInsets.all(20),
            child: allmessages == null?
              Center( 
                child: CircularProgressIndicator()
              ):
              Column(
              children:allmessages.map((messageone){ //populating children to column using map
                  String type = "NONE";  //get the type of message i.e. inbox, sent, draft
                  if(messageone.kind == SmsMessageKind.Received){
                     type = "உட்பெட்டி";
                  }else if(messageone.kind == SmsMessageKind.Sent){
                     type = "அனுப்பப்பட்டவை";
                  }else if(messageone.kind == SmsMessageKind.Draft){
                     type = "வரைவு";
                  }
                  return Container( 
                     child: Card( 
                      
                       child: ListTile( 
                          tileColor: Color.fromARGB(255, 255, 210, 165),
                          leading: Icon(Icons.message),
                          title: Padding(child: Text(messageone.address + " (" + type + ")"),
                                    padding: EdgeInsets.only(bottom:10, top:10)
                                 ), // printing address
                          subtitle: Padding(child: Text(messageone.date.toString() + "\n" + messageone.body), 
                                       padding: EdgeInsets.only(bottom:10, top:10)
                                  ), //pringint date time, and body
                          onTap: () {
                           _navigateToNextScreen(context,messageone.body);
                          },
                       )
                     ),
                     
                  );
               }).toList()
            ),
         ),
      )
    );
  }
}



