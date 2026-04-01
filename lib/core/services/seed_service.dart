import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../constants/app_strings.dart';

class SeedService {
  static final _db   = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> seedIfNeeded({Function(String)? onProgress}) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('aci_v8_seeded') == true) return;
    
    onProgress?.call('Seeding Initial Configuration...');
    _seedUsers();
    _seedBishop();
    _seedPastors();
    _seedSynod();
    _seedEvents();
    _seedUpdates();
    _seedGalleryAlbums();
    _seedMeetings();
    _seedZonesAndChurches();
    
    onProgress?.call('Reading Excel Data...');
    await _seedFromCSV(onProgress);
    
    await prefs.setBool('aci_v7_seeded', true);
    debugPrint('ACI Diocese: v6 seed complete');
  }

  static Future<void> _seedUsers() async {
    final users = [
      {'email': 'bishop@acidiocese.org', 'pass': 'bishop123', 'name': 'Rt. Rev. Johnson Durai S.', 'role': 'admin'},
      {'email': 'selvin@acidiocese.org',  'pass': '1234',      'name': 'Pr. Selvin Durai',          'role': 'pastor'},
      {'email': 'david@acidiocese.org',   'pass': '1234',      'name': 'Pr. David Durai',           'role': 'pastor'},
      {'email': 'user@acidiocese.org',    'pass': 'user123',   'name': 'Church Member',             'role': 'user'},
    ];
    for (final u in users) {
      try {
        final c = await _auth.createUserWithEmailAndPassword(email: u['email']!, password: u['pass']!);
        await _db.collection('users').doc(c.user!.uid).set({
          'uid': c.user!.uid, 'name': u['name'], 'email': u['email'],
          'role': u['role'], 'photoUrl': '',
          'createdAt': FieldValue.serverTimestamp(), 'isActive': true,
        });
      } catch (_) {}
    }
  }

  static Future<void> _seedBishop() async {
    await _db.collection('bishop').doc('main').set({
      'name': AppStrings.bishopName,
      'title': AppStrings.bishopTitle,
      'ministry': AppStrings.bishopMinistry,
      'organisation': AppStrings.fullOrgName,
      'photoUrl': '',
      'yearsInMinistry': 25,
      'bio': AppStrings.bishopBio,
      'verse': '"And I will set up one shepherd over them, and he shall feed them, even my servant David; he shall feed them, and he shall be their shepherd." \u2014 Ezekiel 34:23',
      'phone': AppStrings.phone,
      'email': 'bishop@acidiocese.org',
      'foundedDate': AppStrings.foundedDate,
    });
  }

  static Future<void> _seedPastors() async {
    final list = [
      {'id': 'selvin',        'name': 'Pr. Selvin Durai',              'role': 'District Overseer', 'region': 'Dindigul Central', 'phone': '9944107042', 'email': 'selvin@acidiocese.org'},
      {'id': 'david',         'name': 'Pr. David Durai',               'role': 'Senior Minister',   'region': 'Dindigul North',   'phone': '9876543210', 'email': 'david@acidiocese.org'},
      {'id': 'thaaveethu',    'name': 'Pr. Y. Thaaveethu',            'role': 'Senior Minister',   'region': 'Vadipatti',        'phone': '9876500013', 'email': ''},
      {'id': 'baby_thomas',   'name': 'Pr. Baby Thomas',               'role': 'Committee Member',  'region': 'Dindigul South',   'phone': '9876500001', 'email': ''},
      {'id': 't_christudhas', 'name': 'Pr. T. Christudhas',           'role': 'Committee Member',  'region': 'Natham',           'phone': '9876500002', 'email': ''},
      {'id': 'pg_roy',        'name': 'Pr. P. G. Roy',                'role': 'Committee Member',  'region': 'Vedasandur',       'phone': '9876500003', 'email': ''},
      {'id': 'jeyabalan',     'name': 'Pr. Jeyabalan J Devapitchai',  'role': 'Committee Member',  'region': 'Devakottai',       'phone': '9876500004', 'email': ''},
      {'id': 'victor',        'name': 'Pr. Victor Joseph',            'role': 'Committee Member',  'region': 'Palani',           'phone': '9876500005', 'email': ''},
      {'id': 'mariya',        'name': 'Pr. Mariya Susai',             'role': 'Committee Member',  'region': 'Oddanchatram',     'phone': '9876500006', 'email': ''},
      {'id': 'd_christudas',  'name': 'Pr. D. Christudas',           'role': 'Committee Member',  'region': 'Batlagundu',       'phone': '9876500007', 'email': ''},
      {'id': 'ms_john',       'name': 'Pr. M. S. John Rathina Singh', 'role': 'Committee Member',  'region': 'Madurai',          'phone': '9876500008', 'email': ''},
      {'id': 'george',        'name': 'Pr. G. George Ananth',         'role': 'Committee Member',  'region': 'Dindigul East',    'phone': '9876500009', 'email': ''},
      {'id': 'johnson_d',     'name': 'Pr. Johnson P. Daniel',        'role': 'Committee Member',  'region': 'Nilakottai',       'phone': '9876500010', 'email': ''},
      {'id': 'solomon',       'name': 'Pr. Solomon Kennedy',          'role': 'Committee Member',  'region': 'Kodaikanal',       'phone': '9876500011', 'email': ''},
      {'id': 'thomson',       'name': 'Pr. Thomson Mathews',          'role': 'Committee Member',  'region': 'Periyakulam',      'phone': '9876500012', 'email': ''},
    ];
    final batch = _db.batch();
    for (final p in list) {
      batch.set(_db.collection('pastors').doc(p['id'] as String), {
        ...p, 'photoUrl': '', 'aadhaarFrontUrl': '', 'aadhaarBackUrl': '',
        'status': 'approved', 'joinedYear': 2018,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  static Future<void> _seedSynod() async {
    final batch = _db.batch();
    final regions = [
      {'id': 'dindigul',   'name': 'Dindigul Diocese',   'headId': 'selvin',  'headName': 'Pr. Selvin Durai',             'memberCount': 12},
      {'id': 'madurai',    'name': 'Madurai Diocese',    'headId': 'ms_john', 'headName': 'Pr. M. S. John Rathina Singh', 'memberCount': 8},
      {'id': 'kodaikanal', 'name': 'Kodaikanal Diocese', 'headId': 'solomon', 'headName': 'Pr. Solomon Kennedy',          'memberCount': 5},
      {'id': 'palani',     'name': 'Palani Diocese',     'headId': 'victor',  'headName': 'Pr. Victor Joseph',            'memberCount': 6},
    ];
    for (final r in regions) {
      batch.set(_db.collection('synod').doc(r['id'] as String), {...r, 'createdAt': FieldValue.serverTimestamp()});
    }
    await batch.commit();
  }

  static Future<void> _seedEvents() async {
    final batch = _db.batch();
    final events = [
      {
        'title': 'Holy Communion Service \u2014 Big Mass 2026', 'tag': 'BIG MASS 2026',
        'description': 'Annual Holy Communion and worship service for all members of ACI Diocese. All pastors and congregation members are warmly invited to attend and participate in this sacred gathering.',
        'date': Timestamp.fromDate(DateTime(2026, 4, 15, 10, 0)),
        'location': 'Central Diocesan Office, Hanumantharayan Kottai, Dindigul',
        'isActive': true, 'registrationOpen': true,
      },
      {
        'title': 'Annual Synod Meeting 2026', 'tag': 'SYNOD 2026',
        'description': 'Annual general body meeting of all Synod bishops and district overseers. Attendance is mandatory for all ordained pastors.',
        'date': Timestamp.fromDate(DateTime(2026, 5, 20, 9, 0)),
        'location': 'Central Diocesan Office, Dindigul',
        'isActive': true, 'registrationOpen': true,
      },
      {
        'title': 'Ordination Service 2026', 'tag': 'ORDINATION',
        'description': 'Sacred ordination ceremony for new pastors and deacons entering the ministry of ACI Diocese.',
        'date': Timestamp.fromDate(DateTime(2026, 6, 10, 10, 30)),
        'location': 'Central Diocesan Office, Dindigul',
        'isActive': true, 'registrationOpen': false,
      },
    ];
    for (final e in events) {
      batch.set(_db.collection('events').doc(), e);
    }
    await batch.commit();
  }

  static Future<void> _seedUpdates() async {
    final batch = _db.batch();
    final updates = [
      {'title': 'Synod Meeting 2026 \u2014 Registration Open', 'body': 'All ordained pastors register by April 30. Contact central office.', 'date': Timestamp.now(), 'isImportant': true},
      {'title': 'New District Overseer \u2014 Madurai Region', 'body': 'Pr. M. S. John Rathina Singh appointed District Overseer, Madurai, effective 1 March 2026.', 'date': Timestamp.fromDate(DateTime(2026, 3, 1)), 'isImportant': false},
      {'title': 'Big Mass 2026 \u2014 Venue Confirmed', 'body': 'Holy Communion Service at Central Diocesan Office, April 15, 2026 at 10:00 AM.', 'date': Timestamp.fromDate(DateTime(2026, 2, 20)), 'isImportant': true},
    ];
    for (final u in updates) {
      batch.set(_db.collection('updates').doc(), u);
    }
    await batch.commit();
  }

  static Future<void> _seedGalleryAlbums() async {
    final batch = _db.batch();
    final albums = [
      {'id': 'events',     'title': 'Events',              'coverUrl': '', 'photoCount': 0},
      {'id': 'bishop',     'title': 'Bishop & Leadership', 'coverUrl': '', 'photoCount': 0},
      {'id': 'church',     'title': 'Church Life',         'coverUrl': '', 'photoCount': 0},
      {'id': 'ordination', 'title': 'Ordination Services', 'coverUrl': '', 'photoCount': 0},
    ];
    for (final a in albums) {
      batch.set(_db.collection('gallery').doc(a['id'] as String), {...a, 'photos': <String>[], 'createdAt': FieldValue.serverTimestamp()});
    }
    await batch.commit();
  }

  static Future<void> _seedMeetings() async {
    final batch = _db.batch();
    final meetings = [
      {'title': 'Quarterly Pastors Fellowship', 'date': Timestamp.fromDate(DateTime(2026, 4, 5, 10, 0)), 'location': 'Central Office, Dindigul', 'isForPastors': true, 'description': 'Quarterly fellowship and prayer meeting for all registered pastors of ACI Diocese.'},
      {'title': 'Annual Synod Meeting', 'date': Timestamp.fromDate(DateTime(2026, 5, 20, 9, 0)), 'location': 'Central Office, Dindigul', 'isForPastors': true, 'description': 'Annual general body of all Synod bishops and overseers.'},
    ];
    for (final m in meetings) {
      batch.set(_db.collection('meetings').doc(), m);
    }
    await batch.commit();
  }

  static Future<void> _seedZonesAndChurches() async {
    final batch = _db.batch();

    // ── ZONES ────────────────────────────────────────────────────
    final zones = [
      {'id':'dindigul_zone',   'zoneName':'Dindigul Zone',   'zoneCode':'DZ', 'headPastorId':'selvin',  'headPastorName':'Pr. Selvin Durai',             'districtCount':4},
      {'id':'madurai_zone',    'zoneName':'Madurai Zone',    'zoneCode':'MZ', 'headPastorId':'ms_john', 'headPastorName':'Pr. M. S. John Rathina Singh', 'districtCount':4},
      {'id':'kodaikanal_zone', 'zoneName':'Kodaikanal Zone', 'zoneCode':'KZ', 'headPastorId':'solomon', 'headPastorName':'Pr. Solomon Kennedy',          'districtCount':3},
      {'id':'palani_zone',     'zoneName':'Palani Zone',     'zoneCode':'PZ', 'headPastorId':'victor',  'headPastorName':'Pr. Victor Joseph',            'districtCount':3},
    ];
    for (final z in zones) {
      batch.set(_db.collection('zones').doc(z['id'] as String),
        {...z, 'createdAt': FieldValue.serverTimestamp()});
    }

    // ── SAMPLE CHURCHES (replace with real data from Excel sheets) ──
    final churches = [
      {
        'churchId':         'TN0001',
        'churchName':       'ACI Test Church',
        'zoneId':           'madurai_zone',
        'zoneName':         'Madurai Zone',
        'districtName':     'Madurai',
        'pastorName':       'Pr. John Doe',
        'designation':      'Senior Pastor',
        'pastorDob':        '01-Jan-1980',
        'address':          '123 Church Rd, Madurai, TN',
        'pastorPhone':      '9876543210',
        'dateOfOrdination': '15-Aug-2005',
        'isActive':         true,
        'status':           'Active',
        'memberCount':      45,
        'foundedYear':      2005,
        'headBishopName':   'Rt. Rev. Johnson Durai S.',
        'dioceseId':        'aci_diocese',
        'pastorEmail':      '',
        'pastorYearsMinistry': 15,
        'pastorPhotoUrl':   '',
      },
    ];

    for (final c in churches) {
      batch.set(_db.collection('churches').doc(c['churchId'] as String), {
        ...c, 'createdAt': FieldValue.serverTimestamp()});
    }
    await batch.commit();
  }

  static Future<void> _seedFromCSV(Function(String)? onProgress) async {
    final raw = await rootBundle.loadString('assets/data/pastors.csv');
    final lines = raw.split('\n');
    if (lines.isEmpty) return;

    final headers = lines[0].split(',').map((h) => h.trim().replaceAll('"', '')).toList();

    var batch = _db.batch();
    int count = 0;

    for (int i = 1; i < lines.length; i++) {
      if (i % 200 == 0) {
        onProgress?.call('Parsed $i / ${lines.length} rows...');
        await Future.delayed(const Duration(milliseconds: 50)); // let UI breathe
      }

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

      String maxDateStr = '';
      int maxYear = 0;
      int maxMonth = 0;
      int maxDay = 0;

      row.forEach((key, value) {
        final k = key.toString().trim().toLowerCase();
        if (k.contains('d.o.b') || k.contains('dob') || k.contains('birth') || k.contains('ordination') || k.contains('conformation')) return;
        
        final v = value?.toString().trim() ?? '';
        if (v.isNotEmpty && (v.contains('.') || v.contains('/'))) {
           final match = RegExp(r'(\d{1,2})[./-](\d{1,2})[./-](\d{2,4})').firstMatch(v);
           if (match != null) {
              int d = int.parse(match.group(1)!);
              int m = int.parse(match.group(2)!);
              int y = int.parse(match.group(3)!);
              if (y < 100) y += 2000;
              
              if (y > maxYear || (y == maxYear && m > maxMonth) || (y == maxYear && m == maxMonth && d > maxDay)) {
                 if (y <= DateTime.now().year + 5) { // Sanity check to ignore completely invalid future years
                     maxYear = y;
                     maxMonth = m;
                     maxDay = d;
                     maxDateStr = match.group(0)!;
                 }
              }
           }
        }
      });
      final lastPayment = maxDateStr;

      final keywords = <String>{};
      for (final text in [regNo, name, dist, zone, cName]) {
        final words = text.toString().toLowerCase().split(RegExp(r'\s+'));
        for (final w in words) {
          String clean = w.replaceAll(RegExp(r'[^a-z0-9]'), '');
          if (clean.length > 2) keywords.add(clean);
        }
      }
      keywords.add(regNo.toLowerCase()); // exact TN ID always included

      batch.set(_db.collection('churches').doc(regNo), {
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
        'lastPaymentDate':  lastPayment,
        'keywords':         keywords.toList(),
        'createdAt':        FieldValue.serverTimestamp(),
      });

      count++;
      if (count % 495 == 0) {
        batch.commit(); // fire and forget
        batch = _db.batch();
      }
    }

    if (count % 495 != 0) batch.commit(); // fire and forget
    onProgress?.call('Finished queueing $count rows to database!');
  }

  static List<String> _parseCsvLine(String line) {
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
}
