import 'package:albaterrapp/services/firebase_services.dart';
import 'package:albaterrapp/utils/color_utils.dart';
import 'package:albaterrapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({Key? key}) : super(key: key);

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}



class _AddPaymentPageState extends State<AddPaymentPage> {

  // ignore: prefer_typing_uninitialized_variables
  var timer;

  @override
  void initState() {
    super.initState();
    lotesStream = FirebaseFirestore.instance.collection('lotes').snapshots();
    getLote();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {    
    lotesStream?.listen(null).cancel();
    timer.cancel(); //cancel the periodic task
    timer; //
    super.dispose();
  }

  Future<void> getLote() async {
    DocumentSnapshot? doc =
        await db.collection('lotes').doc(selectedLote).get();
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final temp = {
      "loteName": data['loteName'],
      "lid": doc.id,    
      "loteState": data['loteState'],
    };
    lote = temp;
  }

  Future<void> getMetodoPago() async {
    DocumentSnapshot? doc =
        await db.collection('infobanco').doc(selectedPaymentMethod).get();
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final temp = {
      "banco": data['banco'],
      "nroCuenta": data['nroCuenta'],  
      "tipoCuenta": data['tipoCuenta'],
    };
    metodoPago = temp;
  }

  Future<void> getPlanPagos() async {
    DocumentSnapshot? doc =
        await db.collection('planPagos').doc(selectedLote).get();
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final temp = {
      "dcto": data['dcto'],
      "estadoPago": data['estadoPago'],    
      "porcCI": data['porcCI'],
      "precioIni": data['precioIni'],
      "precioFin": data['precioFin'],
      "saldoPorPagar": data['saldoPorPagar'],
      "valorPagado": data['valorPagado'],
      "valorSeparacion": data['valorSeparacion'],
    };
    planPagos = temp;
  }

  Future<void> getOrdSep() async {
     QuerySnapshot? querySep =
        await db.collection('ordSep').get();
        for (var docSep in querySep.docs){
          final Map<String, dynamic> data = docSep.data() as Map<String, dynamic>;
          if(data['loteId'] == lote['lid']){
            final temp = {
              "sid": docSep.id,    
              "priceLote": data['priceLote'],
              "precioFinal": data['precioFinal'],
              "dctoLote": data['dctoLote'],
              "vlrCILote": data['vlrCILote'],
              "vlrSepLote": data['vlrSepLote'],
              "separacionDate": data['separacionDate'],
              "saldoSepLote": data['saldoSepLote'],
              "promesaDLDate": data['promesaDLDate'],
            };
            lote = temp;
          }
        }
  }

  late int pagosCounter;
  DateTime quotePickedDate = DateTime.now();
  List<String> paymentMethodList = ['Corriente', 'Ahorros'];
  Map<String, dynamic> lote = {};
  Map<String, dynamic> planPagos = {};
  Stream<QuerySnapshot>? lotesStream;
  Map<String, dynamic> metodoPago = {};
  Stream<QuerySnapshot>? metodoPagoStream;
  String selectedLote = '';
  double paymentValue = 0;
  double discount = 0;
  double totalPrice = 0;
  double saldoPendiente = 0;
  double valorPagado = 0;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController idController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController addressController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController observacionesController = TextEditingController(text: "");
  TextEditingController receiptDateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController valorLetrasController = TextEditingController(text: "");
  String selectedPaymentMethod = 'EFECTIVO';
  String selectedCity = 'Bucaramanga';
  TextEditingController paymentDateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  TextEditingController conceptoPagoController = TextEditingController(text: "");
  TextEditingController paymentNumberController = TextEditingController(text: "");
  TextEditingController paymentValueController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    
    if(selectedLote != ''){
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('planPagos').doc(selectedLote).collection('pagosRealizados');
      collectionReference.get().then((QuerySnapshot pagosSnapshot) {
        pagosCounter = pagosSnapshot.size;
      });
    }
    lotesStream = FirebaseFirestore.instance.collection('lotes').snapshots();
    metodoPagoStream = FirebaseFirestore.instance.collection('infobanco').snapshots();
    getLote();
    getPlanPagos();
    getMetodoPago();
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
            backgroundColor: fifthColor,
            foregroundColor: primaryColor,
            elevation: 0,
            title: Center(
              child: Text(
                "Agregar pago",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 244, 246, 252),
              Color.fromARGB(255, 222, 224, 227),
              Color.fromARGB(255, 222, 224, 227)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [                      
                      Container(
                        alignment: Alignment.center,
                        child: const Text('Fecha recibo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ))),
                      const SizedBox(
                        height: 10,
                      ), 
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: fifthColor.withOpacity(0.1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            cursorColor: fifthColor,
                            style: TextStyle(
                                color: fifthColor.withOpacity(0.9)),
                            controller: receiptDateController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.date_range_outlined,
                                color: fifthColor,
                              ),
                              hintText: DateFormat('dd-MM-yyyy')
                                  .format(quotePickedDate),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate =
                                  await showDatePicker(
                                locale: const Locale("es", "CO"),
                                context: context,
                                initialDate: dateConverter(
                                    receiptDateController.text),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2050),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  receiptDateController.text =
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Text('Información de quien paga',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ))),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: textFieldWidget("Nombre", Icons.person_outline,
                            false, nameController, true, 'name', () {}),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: textFieldWidget(
                            "NIT o Documento de identificación",
                            Icons.badge_outlined,
                            false,
                            idController,
                            true,
                            'id',
                            () {}),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: textFieldWidget(
                            "Número telefónico",
                            Icons.phone_android,
                            false,
                            phoneController,
                            true,
                            'phone',
                            () {}),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: textFieldWidget(
                            "Correo electrónico",
                            Icons.email_outlined,
                            false,
                            emailController,
                            true,
                            'email',
                            () {}),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: textFieldWidget(
                            "Dirección",
                            Icons.location_city_outlined,
                            false,
                            addressController,
                            true,
                            'name',
                            () {}),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color:fifthColor.withOpacity(0.1))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('cities')
                                .orderBy('cityName',
                                    descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              Set<String> cityNames = {};
                              List<DropdownMenuItem> cityItems = [];
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                final citiesList = snapshot
                                    .data?.docs.reversed
                                    .toList();
                                for (var cities in citiesList!) {
                                  String cityName =
                                      cities['cityName'];
                                  if (!cityNames
                                      .contains(cityName)) {
                                    cityNames.add(cityName);
                                    cityItems.add(
                                      DropdownMenuItem(
                                        value: cityName,
                                        child: Center(
                                            child: Text(cityName)),
                                      ),
                                    );
                                  }
                                }
                              }
                              return DropdownButton(
                                items: cityItems,
                                hint: Center(
                                    child:
                                        Text(selectedCity)),
                                underline: Container(),
                                style: TextStyle(
                                  color:
                                      fifthColor.withOpacity(0.9),
                                ),
                                onChanged: (cityValue) {
                                  setState(() {
                                    selectedCity = cityValue!;
                                  });
                                },
                                isExpanded: true,
                              );
                            },
                          ),
                        )
                      ),   
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Text('Información del pago',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ))),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(                                                    
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      border:
                                          Border.all(color: fifthColor.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: lotesStream,
                                      builder: (context, lotesSnapshot) {
                                        List<DropdownMenuItem> loteItems = [];
                                        if (!lotesSnapshot.hasData) {
                                          return const Center(child: CircularProgressIndicator());
                                        } else {
                                          final lotesList = lotesSnapshot.data?.docs;
                                          for (var lotes in lotesList!) {
                                            if (lotes['loteState'] !=
                                                    'Disponible' && lotes['loteState'] != 'Pagado') {
                                              loteItems.add(
                                                DropdownMenuItem(
                                                  value: lotes.id,
                                                  child: Center(
                                                      child: Text(
                                                          '${lotes['loteName']} - ${lotes['loteState']}')),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                        return DropdownButton(
                                          items: loteItems,
                                          hint: Center(
                                              child: Text(selectedLote != ''
                                                  ? '${lote['loteName']}'
                                                  : 'Lote')),
                                          underline: Container(),
                                          style: TextStyle(
                                            color: fifthColor.withOpacity(0.9),
                                          ),
                                          onChanged: (loteValue) {
                                            setState(() async {
                                              selectedLote = loteValue!;
                                              await getLote();
                                              await getPlanPagos();                                              
                                              discount = planPagos['dcto'];
                                              totalPrice = planPagos['precioIni']*(100-discount)/100;
                                              saldoPendiente = planPagos['saldoPorPagar'];
                                              valorPagado = planPagos['valorPagado'];                                              
                                            });
                                          },
                                          isExpanded: true,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                        width: 1,
                                        style: BorderStyle.solid,
                                        color: fifthColor.withOpacity(0.1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      cursorColor: fifthColor,
                                      style: TextStyle(
                                          color: fifthColor.withOpacity(0.9)),
                                      controller: paymentDateController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          Icons.date_range_outlined,
                                          color: fifthColor,
                                        ),
                                        hintText: DateFormat('dd-MM-yyyy')
                                            .format(quotePickedDate),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          locale: const Locale("es", "CO"),
                                          context: context,
                                          initialDate: dateConverter(
                                              paymentDateController.text),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2050),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            paymentDateController.text =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(pickedDate);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),                     
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: textFieldWidget(
                                  (currencyCOP((paymentValue.toInt())
                                      .toString())),
                                  Icons.monetization_on_outlined,
                                  false,
                                  paymentValueController,
                                  true,
                                  'number',
                                  (String value) {                          
                                    setState(() {
                                      double maxValue = totalPrice - planPagos['valorPagado'];
                                      final double newValue = stringConverter(value);
                                      if (newValue <= maxValue) {
                                        paymentValue = newValue;
                                      } else {
                                        paymentValue = maxValue;
                                      }                           
                                      paymentValueController.value = TextEditingValue(
                                        text: (currencyCOP((paymentValue.toInt()).toString())),
                                        selection:TextSelection.collapsed(
                                          offset: (currencyCOP((paymentValue.toInt()).toString())).length
                                        ),
                                      );
                                      updateNumberWords();
                                    });
                                  }                        
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: textFieldWidget(
                                  "Valor en letras",
                                  Icons.abc_outlined,
                                  false,
                                  valorLetrasController,
                                  true,
                                  'name',
                                  () {}
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),                                         
                      const SizedBox(
                        height: 5,
                      ),
                      selectedLote != '' ? Card(
                        color: fifthColor.withOpacity(0.4),
                        elevation: 2,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          width: MediaQuery.of(context).size.width-100,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          child: Column(
                            children: [
                              Text(
                                'Precio inicial',
                                style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Text( 
                                currencyCOP((planPagos['precioIni'].toInt()).toString()),
                                style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Descuento aplicado',
                                style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Text( 
                                '${discount.toInt()}%',
                                style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Valor pagado',
                                        style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Text( 
                                        currencyCOP((valorPagado.toInt()).toString()),
                                        style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Saldo pendiente',
                                        style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currencyCOP(((totalPrice - planPagos['valorPagado']).toInt()).toString()),
                                        style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Saldo pendiente después del pago',
                                style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Text( 
                                currencyCOP(((totalPrice - planPagos['valorPagado'] - paymentValue).toInt()).toString()),
                                style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ) : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(        
                        constraints: const BoxConstraints(maxWidth: 800),                                            
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            border:
                                Border.all(color: fifthColor.withOpacity(0.1))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: metodoPagoStream,
                            builder: (context, metodoPagoSnapshot) {
                              List<DropdownMenuItem> metodoPagoItems = [];
                              if (!metodoPagoSnapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              } else {
                                final metodoPagoList = metodoPagoSnapshot.data?.docs;
                                for (var metodosPago in metodoPagoList!) {                                  
                                  metodoPagoItems.add(
                                    DropdownMenuItem(
                                      value: metodosPago.id,
                                      child: Center(
                                          child: Text(
                                              '${metodosPago['banco']} ${metodosPago['tipoCuenta']} ${metodosPago['nroCuenta']}')),
                                    ),
                                  );                                  
                                }
                              }
                              return DropdownButton(
                                items: metodoPagoItems,
                                hint: Center(
                                    child: Text('${metodoPago['banco']} ${metodoPago['tipoCuenta']} ${metodoPago['nroCuenta']}')),
                                underline: Container(),
                                style: TextStyle(
                                  color: fifthColor.withOpacity(0.9),
                                ),
                                onChanged: (metodoPagoValue) {
                                  setState(() {
                                    selectedPaymentMethod = metodoPagoValue!;
                                    getMetodoPago();
                                  });
                                },
                                isExpanded: true,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: textFieldWidget(
                            "Observaciones",
                            Icons.search_outlined,
                            false,
                            observacionesController,
                            true,
                            'email',
                            () {}),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(250, 50))),
                        onPressed: () async {                          
                          if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          addressController.text.isEmpty || 
                          paymentValue <= 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomAlertMessage(
                                  errorTitle: "Oops!",
                                  errorText:
                                      "Verifique que todos los campos se hayan llenado correctamente.",
                                  stateColor: dangerColor,
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );
                          } else {
                            setState(() {
                              pagosCounter++;
                            });
                            await pagosRealizados(
                              selectedLote,
                              pagosCounter.toString(),
                              paymentValue,
                              'ABONO',
                              receiptDateController.text,
                              paymentDateController.text,
                              selectedPaymentMethod,
                              nameController.text,
                              idController.text,
                              phoneController.text,
                              emailController.text,
                              addressController.text,
                              selectedCity,
                              observacionesController.text
                            );
                            await updatePlanPagos(
                              selectedLote, 
                              planPagos['precioIni'], 
                              totalPrice, 
                              discount, 
                              nextState(),
                              saldoPendiente - paymentValue,
                              valorPagado + paymentValue
                              );
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomAlertMessage(
                                  errorTitle: "Genial!",
                                  errorText:
                                      "Datos almacenados de manera satisfactoria.",
                                  stateColor: successColor,
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );                            
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Guardar"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  String idPagoGen (int value){
    value = value++;
    return value.toString();
  }

  String nextState(){
    late String temp;
    if(planPagos['estadoPago'] == 'Pendiente'){
      paymentValue >= planPagos['valorSeparacion'] ? temp = 'Separado' : temp = 'Pendiente';
    } else {
      temp = 'En proceso';
    }
    if(planPagos['saldoPorPagar'] == paymentValue){
      temp = 'Completo';
    }
    return temp;
  }

  Future<void> loteStatus() async {
    await db.collection("lotes").doc(selectedLote).update({"loteState": 'Lote separado'});
  }

  void updateNumberWords() async {
    valorLetrasController.text = await numeroEnLetras(paymentValue, 'pesos');
  }
  
  double stringConverter(String valorAConvertir) {
    String valorSinPuntos =
        valorAConvertir.replaceAll('\$', '').replaceAll('.', '');
    return double.parse(valorSinPuntos);
  }

  DateTime dateConverter(String stringAConvertir) {
    DateTime dateConverted = DateFormat('dd-MM-yyyy').parse(stringAConvertir);
    return dateConverted;
  }
}