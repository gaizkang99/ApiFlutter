import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica Examen Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Practica Examen Api'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState(){
    return _MyHomePageState();
  } 
}

class _MyHomePageState extends State<MyHomePage> {

  final pokemon = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String nombre = "";
  String altura = "";
  String peso = "";
  List<String> habilidad = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
          children:<Widget>[TextFormField(
            validator: (value) {
              if(value!.isEmpty || value.trim().isEmpty){
                setState(() {
                  nombre = "";
                  altura = "";
                peso = "";
                habilidad = <String>[];
              });
                return "Escribe el nombre o el id de un pokemon";
              }
            },
            controller: pokemon,
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Pokemon',
            ),
          ),Container(
            padding: EdgeInsets.only(top: 10),
            child: ElevatedButton(
            child: Text('Buscar',
            style: TextStyle(color: Colors.black)
            ),
            onPressed:(){
              if(_formKey.currentState!.validate()){
                buscarPokemon(pokemon);
              }
              } ,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Text("El nombre es: " + nombre.toUpperCase() + "\n", style: TextStyle(color: Colors.black)),
                Text("La altura es: " + altura + " m\n", style: TextStyle(color: Colors.black)),
                Text("El peso es: " + peso + " kg\n", style: TextStyle(color: Colors.black)),
                Text("Habilidades: \n" + imprimirHabilidades() + "\n", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
              ],
            )
          ),
            ] 
        ),
        ),
      ),
    );
  }

  buscarPokemon(TextEditingController pokemon) async {
    final String pok = pokemon.text; 
    String url = "https://pokeapi.co/api/v2/pokemon/" + pok.trim().toLowerCase();
    try {
      http.Response response = await http.get(Uri.parse(url));
      Map data = jsonDecode(response.body);
      List<dynamic> habilidades = data["abilities"];
      List<String> habilidadesfinales = <String>[];
      habilidades.forEach((element){
        habilidadesfinales.add(element["ability"]["name"]);
      });
      setState(() {
        nombre = data["name"];
        altura = data["height"].toString();
        peso = data["weight"].toString();
        habilidad = habilidadesfinales;
      });
    } catch (error){
      setState(() {
          nombre = "";
          altura = "";
          peso = "";
          habilidad = <String>[];
        });
    }

  }

  String imprimirHabilidades() {
    String imprimir = "";
    habilidad.forEach((element) { imprimir+=element.toString() + "\n"; });
    return imprimir;
  }
}
