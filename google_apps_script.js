function setupSheet() {
  var sheetName = "Applications";
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = ss.getSheetByName(sheetName);

  if (!sheet) {
    sheet = ss.insertSheet(sheetName);
  }

  if (sheet.getLastRow() === 0) {
    sheet.appendRow([
      "Application ID",      // 0
      "Full Name",           // 1
      "Baptismal Name",      // 2
      "Date of Birth",       // 3
      "Nationality",         // 4
      "Gender",              // 5
      "Marital Status",      // 6
      "Permanent Address",   // 7
      "Contact Address",     // 8
      "Ministry Function",   // 9
      "Affiliation",         // 10
      "Trust Name",          // 11
      "Church Name",         // 12
      "Church Address",      // 13
      "Tele/Mobile",         // 14
      "Email ID",            // 15
      "Spiritual Milestones",// 16
      "Ordination Request",  // 17
      "Academic Qualification",//18
      "Theological Qualification",//19
      "Family Details",      // 20
      "Prompt to Join ACI",  // 21
      "Reference 1",         // 22
      "Reference 2",         // 23
      "Payment Status",      // 24
      "Payment ID",          // 25
      "Payment Mode",        // 26
      "Verification Status", // 27
      "Timestamp",           // 28
      "Full_JSON"            // 29
    ]);
    
    sheet.getRange(1, 1, 1, 30).setFontWeight("bold").setBackground("#d9ead3");
    sheet.setFrozenRows(1);
    Logger.log("Headers initialized successfully!");
  }

  return sheet;
}

function initializeHeaders() {
  setupSheet();
}

function doPost(e) {
  var lock = LockService.getScriptLock();
  var successLock = lock.tryLock(28000);

  if (!successLock) {
    return ContentService.createTextOutput(JSON.stringify({status: "error", message: "Server busy, please try again."})).setMimeType(ContentService.MimeType.JSON);
  }

  try {
    var sheet = setupSheet();
    
    if (!e || !e.postData || !e.postData.contents) {
      return ContentService.createTextOutput(JSON.stringify({status: "error", message: "No data received"})).setMimeType(ContentService.MimeType.JSON);
    }
    
    var data = JSON.parse(e.postData.contents);

    // 1. ADD NEW RECORD
    if (data.type === "add") {
      // ── LOGICAL DUPLICATE PREVENTION ──
      if (data.payment_status !== "PAID") {
        return ContentService.createTextOutput(JSON.stringify({status: "skipped", message: "Not paid"})).setMimeType(ContentService.MimeType.JSON);
      }

      var existingData = sheet.getDataRange().getValues();
      var isDuplicate = false;
      var incomingId = (data.id || "").trim();
      var incomingPhone = (data.telephone || "").trim();
      var incomingEmail = (data.email || "").trim().toLowerCase();

      for (var i = 1; i < existingData.length; i++) {
        var row = existingData[i];
        var rowId = String(row[0] || "").trim();
        var rowPhone = String(row[14] || "").trim();
        var rowEmail = String(row[15] || "").trim().toLowerCase();

        if (incomingId && rowId === incomingId) { isDuplicate = true; break; }
        if (incomingPhone && rowPhone === incomingPhone) { isDuplicate = true; break; }
        if (incomingEmail && rowEmail === incomingEmail) { isDuplicate = true; break; }
      }

      if (isDuplicate) {
        return ContentService.createTextOutput(JSON.stringify({status: "error", message: "Duplicate user or transaction detected!"})).setMimeType(ContentService.MimeType.JSON);
      }

      var timestamp = data.timestamp || formatTimestamp(new Date());
      // Append apostrophe to force plain text rendering immediately in GS
      var finalTs = "'" + timestamp;
      
      sheet.appendRow([
        data.id || "",
        data.name || "",
        data.baptismal_name || "",
        data.dob || "",
        data.nationality || "",
        data.gender || "",
        data.marital_status || "",
        data.permanent_address || "",
        data.contact_address || "",
        data.ministry_function || "",
        data.affiliation || "",
        data.trust_name || "",
        data.church_name || "",
        data.church_address || "",
        data.telephone || "",
        data.email || "",
        data.spiritual_milestones || "",
        data.ordination_request || "",
        data.academic_qual || "",
        data.theological_qual || "",
        data.family_details || "",
        data.prompt_to_join || "",
        data.reference_1 || "",
        data.reference_2 || "",
        data.payment_status || "PENDING",
        data.payment_id || "",
        data.payment_mode || "",
        data.verification_status || "NOT VERIFIED", 
        finalTs,
        JSON.stringify(data)
      ]);

      // ── FLASH SYNC REFRESH ──
      SpreadsheetApp.flush();

      return ContentService.createTextOutput(JSON.stringify({status: "added"})).setMimeType(ContentService.MimeType.JSON);
    }

    // 2. VERIFY PAYMENT STATUS
    if (data.type === "verify") {
      var rows = sheet.getDataRange().getValues();
      var updated = false;
      for (var i = 1; i < rows.length; i++) {
        if (rows[i][0] == data.id) { 
          sheet.getRange(i + 1, 28).setValue("VERIFIED"); 
          updated = true;
          break;
        }
      }
      if (updated) SpreadsheetApp.flush();
      
      return ContentService.createTextOutput(JSON.stringify({status: "updated"})).setMimeType(ContentService.MimeType.JSON);
    }
    
    return ContentService.createTextOutput(JSON.stringify({status: "ignored"})).setMimeType(ContentService.MimeType.JSON);
  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({status: "error", message: error.toString()})).setMimeType(ContentService.MimeType.JSON);
  } finally {
    lock.releaseLock();
  }
}

function doGet(e) {
  var action = e && e.parameter ? e.parameter.action : null;

  if (action === "getSynodMembers") {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var synodSheet = ss.getSheetByName("SynodMembers");
    if (!synodSheet) {
      return ContentService.createTextOutput(JSON.stringify({status: "error", message: "SynodMembers sheet not found"})).setMimeType(ContentService.MimeType.JSON);
    }
    
    var rows = synodSheet.getDataRange().getValues();
    var headers = rows[0];
    var data = [];
    
    for (var i = 1; i < rows.length; i++) {
      var row = rows[i];
      var rowData = {};
      for (var j = 0; j < headers.length; j++) {
        var key = headers[j];
        if (key && typeof key === 'string') {
           rowData[key] = row[j] || "";
        }
      }
      data.push(rowData);
    }
    
    return ContentService.createTextOutput(JSON.stringify({data: data})).setMimeType(ContentService.MimeType.JSON);
  }

  // Original Logic matching your application portal requests
  var sheet = setupSheet();
  var rows = sheet.getDataRange().getValues();
  var data = [];
  
  for (var i = 1; i < rows.length; i++) {
    var row = rows[i];
    
    data.push({
      "id": row[0] || "",
      "name": row[1] || "",
      "phone": row[14] || "",
      "email": row[15] || "",
      "address": row[8] || "",
      "church": row[12] || "",
      "ministryType": row[9] || "",
      "paymentStatus": row[24] || "",
      "paymentId": row[25] || "",
      "paymentMode": row[26] || "",
      "verificationStatus": row[27] || "",
      "timestamp": row[28] || "",
      "full_json": row[29] || "{}"
    });
  }
  
  return ContentService.createTextOutput(JSON.stringify({data: data})).setMimeType(ContentService.MimeType.JSON);
}

// Readable timestamp: "25-Mar-2025 7:30 PM"
function formatTimestamp(d) {
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  var day = d.getDate().toString().padStart(2, '0');
  var month = months[d.getMonth()];
  var year = d.getFullYear();
  var hours = d.getHours();
  var ampm = hours >= 12 ? 'PM' : 'AM';
  hours = hours % 12;
  if (hours === 0) hours = 12;
  var mins = d.getMinutes().toString().padStart(2, '0');
  return day + '-' + month + '-' + year + ' ' + hours + ':' + mins + ' ' + ampm;
}
