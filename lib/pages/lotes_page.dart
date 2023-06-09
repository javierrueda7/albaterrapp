import 'package:albaterrapp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../services/firebase_services.dart';

class LotesPage extends StatefulWidget {
  final bool allAccess;
  const LotesPage({
    Key? key, required this.allAccess
  }) : super(key: key);

  @override
  State<LotesPage> createState() => _LotesPageState();
}

class _LotesPageState extends State<LotesPage> {

   @override
  void initState() {
    super.initState();    
    allAccess = widget.allAccess; 
  }

  bool allAccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fifthColor,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Lotes',
          style: TextStyle(color: primaryColor,fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: FutureBuilder(
            future: getLotes(),
            builder: ((context, snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(snapshot.data?[index]['loteName']),
                      trailing: Text(snapshot.data?[index]['loteState']),
                      tileColor: setStatusColor(snapshot.data?[index]['loteState']),
                      onTap: (() async {
                        if(allAccess == true){
                          await Navigator.pushNamed(context, "/editLote", arguments: {
                            "loteId": snapshot.data?[index]['loteId'],
                            "loteName": snapshot.data?[index]['loteName'],                              
                            "loteEtapa": snapshot.data?[index]['loteEtapa'],
                            "loteArea": snapshot.data?[index]['loteArea'],
                            "lotePrice": snapshot.data?[index]['lotePrice'],
                            "loteState": snapshot.data?[index]['loteState'],
                            "loteLinderos": snapshot.data?[index]['loteLinderos'],
                          });
                          setState(() {});
                        } else {
                          setState(() {});
                        }
                      }),
                    );        
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            )
          ),
        ),
      ),
    );
  }

  Color setStatusColor(String value){
    if(value == "Disponible"){
      return Colors.white;
    } if(value == "Lote separado"){
      return separadoColor;
    } else{
      return vendidoColor;
    }
  }

  String setStatus(String value){
    if(value == "Activo"){
      return 'Inactivo';
    } else{
      return 'Activo';
    }
  }

  String setStatusString(String value){
    if(value == "Activo"){
      return 'inactivar';
    } else{
      return 'activar';
    }
  }
}
