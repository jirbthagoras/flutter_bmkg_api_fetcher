import 'dart:async';
import 'dart:convert';
// import 'dart:developer';
// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart' as prefix;

// DONT FORGET TO flutter pub get -v

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<Gempa> fetchGempa() async {

  // SENDING REQUEST AT BMKG'S API

  final response = await http
      .get(Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'));
    

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    // FETCHING THE JSON DATAS TO STRING MANUALLY :)

    return await Gempa.fromString(
      jsonDecode(response.body)["Infogempa"]["gempa"]['Tanggal'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Jam'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['DateTime'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Coordinates'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Lintang'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Bujur'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Magnitude'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Kedalaman'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Wilayah'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Potensi'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Dirasakan'] as String,
      jsonDecode(response.body)["Infogempa"]["gempa"]['Shakemap'] as String,
    );
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.

    throw Exception('Failed to load BMKG data');
  }
}

// CLASS FOR JSON

class Gempa {
  final String tanggal;
  final String jam;
  final String dateTime;
  final String coordinates;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;
  final String potensi;
  final String dirasakan;
  final String shakemap;

  const Gempa({
    required this.tanggal,
    required this.jam,
    required this.dateTime,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
    required this.dirasakan,
    required this.shakemap,
  });

  // CONVERTING JSON TO CLASS

  factory Gempa.fromString(tanggal, jam, dateTime, coordinates, lintang, bujur, magnitude, kedalaman, wilayah, potensi, dirasakan, shakemap){
   
      return Gempa(
      tanggal: tanggal, 
      jam: jam,
      dateTime: dateTime,
      coordinates: coordinates,
      lintang: lintang,
      bujur: bujur,
      magnitude: magnitude,
      kedalaman: kedalaman,
      wilayah: wilayah,
      potensi: potensi,
      dirasakan: dirasakan,
      shakemap: shakemap,

      );

    }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Gempa> futureGempa;

  @override
  void initState() {
    super.initState();
    futureGempa = fetchGempa();
  }

  Widget loadingWidget() => const CircularProgressIndicator();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FETCHING BMKG DATA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetching Data From BMKG'),
        ),
        body: Center(
          child: 
          

        FutureBuilder<Gempa>(

          // DISPLAYING THE DATA TO THE APP

          future: futureGempa,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final gempa = snapshot.data!;
              return Text(gempa.tanggal + gempa.jam + gempa.dateTime + gempa.coordinates + gempa.lintang + gempa.bujur + gempa.magnitude + gempa.kedalaman + gempa.wilayah + gempa.potensi + gempa.dirasakan + gempa.shakemap);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return loadingWidget();
          }
        ),



        ),
      ),
    );
  }
}