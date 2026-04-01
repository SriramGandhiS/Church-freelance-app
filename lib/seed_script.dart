import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final file = File('assets/data/pastors.csv');
  if (!file.existsSync()) {
    print('File not found at assets/data/pastors.csv');
    exit(1);
  }

  final lines = await file.readAsLines();
  if (lines.isEmpty) {
    print('Empty CSV file');
    exit(1);
  }

  final headers = lines[0].split(',').map((h) => h.trim().replaceAll('"', '')).toList();
  final db = FirebaseFirestore.instance;

  print('Loaded CSV. Starting seed of ${lines.length - 1} records...');
  
  var batch = db.batch();
  int count = 0;

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    final cells = _parseCsvLine(line);
    if (cells.isEmpty) continue;

    final Map<String, dynamic> row = {};
    for (int j = 0; j < headers.length && j < cells.length; j++) {
      row[headers[j]] = cells[j];
    }

    final regNo = row['Reg.No']?.toString().trim() ?? '';
    if (regNo.isEmpty) continue;

    final name = row['Name'] ?? '';
    final dist = row['District'] ?? row['Distirct'] ?? '';
    final zone = row['Zone'] ?? '';
    final cName = row['Church Name'] ?? '';

    final keywords = <String>{};
    for (final text in [regNo, name, dist, zone, cName]) {
      final words = text.toString().toLowerCase().split(RegExp(r'\s+'));
      for (final w in words) {
        String clean = w.replaceAll(RegExp(r'[^a-z0-9]'), '');
        if (clean.length > 2) keywords.add(clean);
      }
    }
    keywords.add(regNo.toLowerCase());

    batch.set(db.collection('churches').doc(regNo), {
      'churchId':         regNo,
      'pastorName':       name,
      'designation':      row['Designation'] ?? '',
      'pastorDob':        row['D.O.B'] ?? row['DOB'] ?? row['Date Of Birth'] ?? '',
      'address':          row['Contact Address'] ?? row['Office'] ?? '',
      'churchName':       cName,
      'districtName':     dist,
      'pastorPhone':      row['Phone No.'] ?? row['Phone'] ?? '',
      'dateOfOrdination': row['Date of Ordination'] ?? row['Ordination Date'] ?? '',
      'status':           row['Status'] ?? '',
      'state':            row['State'] ?? 'Tamil Nadu',
      'zoneName':         zone,
      'zoneId':           '',
      'isActive':         true,
      'headBishopName':   'Rt. Rev. Johnson Durai S.',
      'dioceseId':        'aci_diocese',
      'memberCount':      0,
      'foundedYear':      0,
      'pastorEmail':      '',
      'pastorPhotoUrl':   '',
      'keywords':         keywords.toList(),
      'createdAt':        FieldValue.serverTimestamp(),
    });

    count++;
    if (count % 495 == 0) {
      await batch.commit();
      print('Committed batch $count');
      batch = db.batch();
    }
  }

  if (count % 495 != 0) {
    await batch.commit();
    print('Committed final batch $count');
  }
  
  print('Successfully processed $count total records.');
  exit(0);
}

List<String> _parseCsvLine(String line) {
  final result = <String>[];
  bool inQuotes = false;
  final buf = StringBuffer();
  for (int i = 0; i < line.length; i++) {
    final c = line[i];
    if (c == '"') {
      inQuotes = !inQuotes;
    } else if (c == ',' && !inQuotes) {
      result.add(buf.toString().trim());
      buf.clear();
    } else {
      buf.write(c);
    }
  }
  result.add(buf.toString().trim());
  return result;
}
