import 'package:albaterrapp/services/firebase_services.dart';
import 'package:albaterrapp/utils/color_utils.dart';
import 'package:albaterrapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

FirebaseFirestore db = FirebaseFirestore.instance;

class CreateCustomerPage extends StatefulWidget {
  final List<dynamic> loteInfo;
  const CreateCustomerPage({Key? key, required this.loteInfo}) : super(key: key);

  @override
  State<CreateCustomerPage> createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends State<CreateCustomerPage> {
  
  @override
  void initState() {
    super.initState();    
    loteInfo = widget.loteInfo;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        realtimeDateTime = dateOnly(true, 0);
      });
    });
  }

  List<dynamic> loteInfo = [];
  String realtimeDateTime = '';
  final double porcCuotaInicial = 0.3;
  final double vlrSeparacion = 10000000;
  final int plazoCI = 120;
  final double vlrTEM = 0.0;
  late double cuotaInicial;
  late double saldoCI;
  late double valorAPagar;
  late double valorCuota;
  List<String> nroCuotasList = ['12', '24', '36'];
  String selectedNroCuotas = '12';
  List<String> idtypeList = ['CC', 'CE', 'Pasaporte', 'NIT'];
  String selectedItemIdtype = 'CC';
  List<String> genderList = ['Masculino', 'Femenino', 'Otro'];
  
  String selectedIssuedCountry = 'País';
  String selectedIssuedState = 'Estado';
  String selectedIssuedCity = 'Ciudad';
  String selectedCountry = 'País';
  String selectedState = 'Estado';
  String selectedCity = 'Ciudad';
  bool countryBool = true;
  List countries = [];
  List<String> paymentMethodList= ['Pago de contado', 'Financiación directa'];
  String paymentMethodSelectedItem = 'Pago de contado';
  
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController idtypeController = TextEditingController(text: "");
  TextEditingController idController = TextEditingController(text: "");
  TextEditingController cityController = TextEditingController(text: "");
  TextEditingController stateController = TextEditingController(text: "");
  TextEditingController countryController = TextEditingController(text: "");
  TextEditingController idcountryController = TextEditingController(text: "");
  TextEditingController idstateController = TextEditingController(text: "");
  TextEditingController idcityController = TextEditingController(text: "");
  TextEditingController addressController = TextEditingController(text: "");
  
  
  TextEditingController genderController = TextEditingController(text: "");
  
  
  
  
  
 
  TextEditingController emailController = TextEditingController(text: "");
  Stream<QuerySnapshot>? citiesStream;




  TextEditingController quoteDateController = TextEditingController(text: "");
  TextEditingController quoteDeadlineController = TextEditingController(text: "");
  TextEditingController loteController = TextEditingController(text: "");
  TextEditingController etapaloteController = TextEditingController(text: "");
  TextEditingController arealoteController = TextEditingController(text: "");
  TextEditingController priceloteController = TextEditingController(text: "");
  TextEditingController vlrCuotaIniController = TextEditingController(text: "");
  TextEditingController vlrSeparacionController = TextEditingController(text: "");
  TextEditingController separacionDeadlineController = TextEditingController(text: "");
  TextEditingController saldoCuotaIniController = TextEditingController(text: "");
  TextEditingController saldoCuotaIniDeadlineController = TextEditingController(text: "");
  TextEditingController vlrPorPagarController = TextEditingController(text: "");

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController lastnameController = TextEditingController(text: "");
  String selectedGender = 'Masculino';
  TextEditingController birthdayController = TextEditingController(text: "");



  void onSelectedState(String value) {
  setState(() {
    selectedIssuedState = value;
    citiesStream = FirebaseFirestore.instance.collection('cities').where('stateName', isEqualTo: selectedIssuedState).orderBy('cityName', descending: true).snapshots();
    selectedIssuedCity = 'Ciudad';
  });
}
  
  @override
  Widget build(BuildContext context) {
    int intLotePrice = loteInfo[9].toInt();
    cuotaInicial = intLotePrice * porcCuotaInicial;
    saldoCI = cuotaInicial - vlrSeparacion;
    valorAPagar = intLotePrice - cuotaInicial;
    valorCuota = valorAPagar/(double.parse(selectedNroCuotas));

    return Scaffold(      
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: fifthColor,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Cotización ${loteInfo[1]}', 
          style: TextStyle(color: primaryColor,fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,            
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 244, 246, 252),
                  Color.fromARGB(255, 222, 224, 227),
                  Color.fromARGB(255, 222, 224, 227)
                ],
                begin: Alignment.topCenter, end: Alignment.bottomCenter
              )
            ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                      child: Center(child: Text('Vigencia cotización', style: TextStyle(fontSize: 12),)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                  child: Text('Desde', style: TextStyle(fontSize: 10),),
                                ),
                                textFieldWidget(
                                  dateOnly(false, 0), Icons.date_range_outlined, false, quoteDateController, false
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                  child: Text('Hasta', style: TextStyle(fontSize: 10),),
                                ),
                                textFieldWidget(
                                  dateOnly(false, 15), Icons.date_range_outlined, false, quoteDeadlineController, false
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ), 
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                  child: Text('Inmueble Nº', style: TextStyle(fontSize: 10),),
                                ),
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 800),
                                  child: textFieldWidget(
                                    loteInfo[1], Icons.house_outlined, false, loteController, false)
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                  child: Text('Etapa', style: TextStyle(fontSize: 10),),
                                ),
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 800),
                                  child: textFieldWidget(
                                    loteInfo[7].toString(), Icons.map_outlined, false, etapaloteController, false)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Row(
                        children: [                          
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                  child: Text('Área', style: TextStyle(fontSize: 10),),
                                ),
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 800),
                                  child: textFieldWidget(
                                    '${((loteInfo[8].toInt()).toString())} m²', Icons.terrain_outlined, false, arealoteController, false)
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                  child: Text('Precio', style: TextStyle(fontSize: 10),),
                                ),
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 800),
                                  child: textFieldWidget(
                                    (currencyCOP((intLotePrice).toString())), Icons.monetization_on_outlined, false, priceloteController, false)
                                ),
                              ],
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
                      color: fifthColor.withOpacity(0.1),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                            child: Text('Cuota inicial (30%)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
                          ),
                          const SizedBox(
                            height: 15,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Cuota inicial = Separación + Saldo de la cuota inicial', style: TextStyle(fontSize: 10,),),
                            )
                          ),
                          SizedBox(
                            height: 15,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("Plazo: ${plazoCI.toString()} días", style: const TextStyle(fontSize: 10,),),
                            )
                          ),
                          textFieldWidget(
                            (currencyCOP(cuotaInicial.toInt().toString())), Icons.monetization_on_outlined, false, vlrCuotaIniController, false
                          ),                          
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                            child: Text('Separación', style: TextStyle(fontSize: 12),)
                          ),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: Row(
                              children: [                          
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                      height: 15,
                                      child: Text('Valor', style: TextStyle(fontSize: 10),)),
                                      textFieldWidget(
                                        (currencyCOP((vlrSeparacion.toInt()).toString())), Icons.monetization_on_outlined, false, vlrSeparacionController, false),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                      height: 15,
                                      child: Text('Fecha límite', style: TextStyle(fontSize: 10),)),
                                      textFieldWidget(
                                        dateOnly(false, 0), Icons.date_range_outlined, false, separacionDeadlineController, false),
                                    ],
                                  ),
                                ),
                              ]
                            )
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                            child: Text('Saldo de la cuota inicial', style: TextStyle(fontSize: 12),)
                          ),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: Row(
                              children: [                          
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                      height: 15,
                                      child: Text('Valor', style: TextStyle(fontSize: 10),)),
                                      textFieldWidget(
                                        (currencyCOP((saldoCI.toInt()).toString())), Icons.monetization_on_outlined, false, saldoCuotaIniController, false),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                      height: 15,
                                      child: Text('Fecha límite', style: TextStyle(fontSize: 10),)),
                                      textFieldWidget(
                                        dateOnly(false, plazoCI), Icons.date_range_outlined, false, saldoCuotaIniDeadlineController, false),
                                    ],
                                  ),
                                ),
                    
                              ]
                            )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      color: fourthColor.withOpacity(0.5),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                            child: Text('Valor por pagar (70%)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
                          ),                          
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: textFieldWidget(
                                  (currencyCOP(valorAPagar.toInt().toString())), Icons.monetization_on_outlined, false, vlrPorPagarController, false
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: easyDropdown(paymentMethodList, paymentMethodSelectedItem, (tempPaymentMethod){setState(() {
                                  paymentMethodSelectedItem = tempPaymentMethod!;
                                });}),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20,
                                child: Text(paymentMethodSelectedItem, style: const TextStyle(fontSize: 12),)
                              ),
                              paymentMethod(paymentMethodSelectedItem),                              
                              const SizedBox(
                                    height: 10,
                              ),
                            ],
                          )
                        ]
                      )
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: textFieldWidget(
                        "Nombres", Icons.person_outline, false, nameController, true
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: textFieldWidget(
                        "Apellidos", Icons.person_outline, false, lastnameController, true
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
                            flex: 2,                           
                            child: easyDropdown(genderList, selectedGender, (tempGender){setState(() {
                              selectedGender = tempGender!;
                            });})
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(width: 1, style: BorderStyle.solid, color: fifthColor.withOpacity(0.1)),                                
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextField(
                                  cursorColor: fifthColor,                              
                                  style: TextStyle(color: fifthColor.withOpacity(0.9)),
                                  controller: birthdayController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.cake_outlined, color: fifthColor,),
                                    hintText: "Fecha de nacimiento",                                    
                                  ),
                                  readOnly: true,
                                  onTap: () async{
                                    DateTime? pickeddate = await showDatePicker(
                                      context: context, 
                                      initialDate: DateTime.now().subtract(const Duration(days: 6574)), 
                                      firstDate: DateTime(1900), 
                                      lastDate: DateTime.now().subtract(const Duration(days: 6574)),
                                    );
                                    if(pickeddate != null) {
                                      setState(() {
                                        birthdayController.text = DateFormat('yyyy-MM-dd').format(pickeddate);
                                      });
                                    }
                                  },
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
                      child: textFieldWidget(
                        "Número telefónico", Icons.phone_android, false, phoneController, true
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
                            child: Container(
                              child: easyDropdown(idtypeList, selectedItemIdtype, (tempType){setState(() {
                                selectedItemIdtype = tempType!;
                              });})
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: textFieldWidget(
                              "Nro documento", Icons.person_pin_outlined, false, idController, true
                            ),
                          ),                          
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                      child: Center(child: Text('Lugar de expedición', style: TextStyle(fontSize: 10),)),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), border: Border.all(color: fifthColor.withOpacity(0.1))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('countries').orderBy('countryName').snapshots(),
                                builder: (context, snapshot) {
                                  List<DropdownMenuItem> countryItems = [];
                                  if (!snapshot.hasData) {
                                    const CircularProgressIndicator();
                                  } else {
                                    final countriesList = snapshot.data?.docs;
                                    for (var countries in countriesList!) {
                                      countryItems.add(
                                        DropdownMenuItem(
                                          value: countries['countryName'],
                                          child: Center(child: Text(countries['countryName'])),
                                        ),
                                      );
                                    }
                                  }
                                  return DropdownButton(
                                    items: countryItems,
                                    hint: Center(child: Text(selectedIssuedCountry)),
                                    underline: Container(),
                                    style: TextStyle(color: fifthColor.withOpacity(0.9),),
                                    onChanged: (countryValue) {
                                      setState(() {
                                        selectedIssuedCountry = countryValue!;
                                        if(selectedIssuedCountry ==  'Colombia'){
                                          countryBool = true;
                                        } else {
                                          countryBool = false;
                                        }
                                      });
                                    },
                                    isExpanded: true,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), border: Border.all(color: fifthColor.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('cities').orderBy('stateName', descending: true).snapshots(),
                                      builder: (context, snapshot) {
                                        Set<String> stateNames = {};
                                        List<DropdownMenuItem> stateItems = [];
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          final statesList = snapshot.data?.docs.reversed.toList();
                                          for (var cities in statesList!) {
                                            String stateName = cities['stateName'];
                                            if(countryBool == true){
                                              if (!stateNames.contains(stateName)) {
                                                stateNames.add(stateName);
                                                stateItems.add(
                                                  DropdownMenuItem(
                                                    value: stateName,
                                                    child: Center(child: Text(stateName)),
                                                  ),
                                                );
                                              }
                                            } else {
                                              if (stateName == 'Otro') {
                                                stateItems.add(
                                                  DropdownMenuItem(
                                                    value: stateName,
                                                    child: Center(child: Text(stateName)),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        }
                                        return DropdownButton(
                                          items: stateItems,
                                          hint: Center(child: Text(selectedIssuedState)),
                                          style: TextStyle(color: fifthColor.withOpacity(0.9),),
                                          underline: Container(),
                                          onChanged: (stateValue) {
                                            setState(() {
                                              selectedIssuedState = stateValue!;
                                            });
                                          },
                                          isExpanded: true,
                                        );
                                      },
                                    ),
                                  ),
                                  
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), border: Border.all(color: fifthColor.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('cities').where('stateName', isEqualTo: selectedIssuedState).orderBy('cityName', descending: true).snapshots(),
                                      builder: (context, snapshot) {
                                        Set<String> cityNames = {};
                                        List<DropdownMenuItem> cityItems = [];
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          final citiesList = snapshot.data?.docs.reversed.toList();
                                          for (var cities in citiesList!) {
                                            String cityName = cities['cityName'];                                   
                                            if (!cityNames.contains(cityName)) {
                                              cityNames.add(cityName);
                                              cityItems.add(
                                                DropdownMenuItem(
                                                  value: cityName,
                                                  child: Center(child: Text(cityName)),
                                                ),
                                              );
                                            }                                    
                                          }
                                        }
                                        return DropdownButton(
                                          items: cityItems,
                                          hint: Center(child: Text(selectedIssuedCity)),
                                          underline: Container(),
                                          style: TextStyle(color: fifthColor.withOpacity(0.9),),
                                          onChanged: (cityValue) {
                                            setState(() {
                                              selectedIssuedCity = cityValue!;
                                            });
                                          },
                                          isExpanded: true,
                                        );
                                      },
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: textFieldWidget(
                        "Correo electrónico", Icons.email_outlined, false, emailController, true
                      ),
                    ),                    
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: textFieldWidget(
                        "Dirección", Icons.location_city_outlined, false, addressController, true
                      ),
                    ),                    
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), border: Border.all(color: fifthColor.withOpacity(0.1))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('countries').orderBy('countryName').snapshots(),
                                builder: (context, snapshot) {
                                  List<DropdownMenuItem> countryItems = [];
                                  if (!snapshot.hasData) {
                                    const CircularProgressIndicator();
                                  } else {
                                    final countriesList = snapshot.data?.docs;
                                    for (var countries in countriesList!) {
                                      countryItems.add(
                                        DropdownMenuItem(
                                          value: countries['countryName'],
                                          child: Center(child: Text(countries['countryName'])),
                                        ),
                                      );
                                    }
                                  }
                                  return DropdownButton(
                                    items: countryItems,
                                    hint: Center(child: Text(selectedCountry)),
                                    underline: Container(),
                                    style: TextStyle(color: fifthColor.withOpacity(0.9),),
                                    onChanged: (countryValue) {
                                      setState(() {
                                        selectedCountry = countryValue!;
                                        if(selectedCountry ==  'Colombia'){
                                          countryBool = true;
                                        } else {
                                          countryBool = false;
                                        }
                                      });
                                    },
                                    isExpanded: true,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), border: Border.all(color: fifthColor.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('cities').orderBy('stateName', descending: true).snapshots(),
                                      builder: (context, snapshot) {
                                        Set<String> stateNames = {};
                                        List<DropdownMenuItem> stateItems = [];
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          final statesList = snapshot.data?.docs.reversed.toList();
                                          for (var cities in statesList!) {
                                            String stateName = cities['stateName'];
                                            if(countryBool == true){
                                              if (!stateNames.contains(stateName)) {
                                                stateNames.add(stateName);
                                                stateItems.add(
                                                  DropdownMenuItem(
                                                    value: stateName,
                                                    child: Center(child: Text(stateName)),
                                                  ),
                                                );
                                              }
                                            } else {
                                              if (stateName == 'Otro') {
                                                stateItems.add(
                                                  DropdownMenuItem(
                                                    value: stateName,
                                                    child: Center(child: Text(stateName)),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        }
                                        return DropdownButton(
                                          items: stateItems,
                                          hint: Center(child: Text(selectedState)),
                                          underline: Container(),
                                          style: TextStyle(color: fifthColor.withOpacity(0.9),),
                                          onChanged: (stateValue) {
                                            setState(() {
                                              selectedState = stateValue!;
                                            });
                                          },
                                          isExpanded: true,
                                        );
                                      },
                                    ),
                                  ),
                                  
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), border: Border.all(color: fifthColor.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('cities').where('stateName', isEqualTo: selectedState).orderBy('cityName', descending: true).snapshots(),
                                      builder: (context, snapshot) {
                                        Set<String> cityNames = {};
                                        List<DropdownMenuItem> cityItems = [];
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          final citiesList = snapshot.data?.docs.reversed.toList();
                                          for (var cities in citiesList!) {
                                            String cityName = cities['cityName'];                                   
                                            if (!cityNames.contains(cityName)) {
                                              cityNames.add(cityName);
                                              cityItems.add(
                                                DropdownMenuItem(
                                                  value: cityName,
                                                  child: Center(child: Text(cityName)),
                                                ),
                                              );
                                            }                                    
                                          }
                                        }
                                        return DropdownButton(
                                          items: cityItems,
                                          hint: Center(child: Text(selectedCity)),
                                          underline: Container(),
                                          style: TextStyle(color: fifthColor.withOpacity(0.9),),
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),                    
                    ElevatedButton(
                      onPressed: () async {
                        await addUsers(
                          nameController.text, 
                          lastnameController.text, 
                          phoneController.text, 
                          idController.text, 
                          'user',
                        ).then((_) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("Guardar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentMethod(String paymentMethodSelection){
    if(paymentMethodSelection == 'Pago de contado'){
      return Row(
        children: [                          
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const SizedBox(
                height: 15,
                child: Text('Valor a pagar', style: TextStyle(fontSize: 10),)),
                textFieldWidget(
                  (currencyCOP(valorAPagar.toInt().toString())), Icons.monetization_on_outlined, false, vlrSeparacionController, false),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const SizedBox(
                height: 15,
                child: Text('Fecha límite', style: TextStyle(fontSize: 10),)),
                textFieldWidget(
                  dateOnly(false, plazoCI+30), Icons.date_range_outlined, false, separacionDeadlineController, false),
              ],
            ),
          ),                    
        ]
      );
    } else {
      return Column(
        children: [
          Row(
            children: [                          
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const SizedBox(
                    height: 15,
                    child: Text('Valor de cada cuota', style: TextStyle(fontSize: 10),)),
                    textFieldWidget(
                      (currencyCOP(valorCuota.toInt().toString())), Icons.monetization_on_outlined, false, vlrSeparacionController, false),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const SizedBox(
                    height: 15,
                    child: Text('Financiación a', style: TextStyle(fontSize: 10),)),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: easyDropdown(nroCuotasList, selectedNroCuotas, (tempNroCuotas){setState(() {
                            selectedNroCuotas = tempNroCuotas!;
                          });}),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text('   meses'),
                        )
                      ],
                    ),
                  ],
                ),
              ),                    
            ]
          ),
          Row(
            children: [                          
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const SizedBox(
                    height: 15,
                    child: Text('TEM', style: TextStyle(fontSize: 10),)),
                    textFieldWidget(
                      '${(vlrTEM.toString())} %', Icons.percent_outlined, false, vlrSeparacionController, false),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const SizedBox(
                    height: 15,
                    child: Text('A partir de', style: TextStyle(fontSize: 10),)),
                    textFieldWidget(
                      dateOnly(false, plazoCI+30), Icons.date_range_outlined, false, separacionDeadlineController, false
                    ),
                  ],
                ),
              ),                    
            ]
          ),
        ],
      );
    }
    
  }

  State<StatefulWidget> createState() => throw UnimplementedError();
}