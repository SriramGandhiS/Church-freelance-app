import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});

  @override
  State<RegistrationFormScreen> createState() => _State();
}

class _State extends State<RegistrationFormScreen> {
  int _currentStep = 0;
  
  // Data Map to hold everything for the JSON payload
  final Map<String, dynamic> _data = {};
  
  // Form Keys for validation per step
  final List<GlobalKey<FormState>> _formKeys = List.generate(8, (_) => GlobalKey<FormState>());

  // Step 1: Personal Details
  final _nameCtrl = TextEditingController();
  final _baptismalCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _nationalityCtrl = TextEditingController(text: 'Indian');
  String _gender = 'Male';
  String _maritalStatus = 'Married';

  // Step 2: Address
  final _permDoorCtrl = TextEditingController();
  final _permStreetCtrl = TextEditingController();
  final _permCityCtrl = TextEditingController();
  final _permTalukCtrl = TextEditingController(); // Taluk (separate from District)
  final _permDistCtrl = TextEditingController();
  final _permStateCtrl = TextEditingController(text: 'Tamil Nadu');
  final _permPinCtrl = TextEditingController();
  bool _sameAsPerm = false;
  final _contDoorCtrl = TextEditingController();
  final _contStreetCtrl = TextEditingController();
  final _contCityCtrl = TextEditingController();
  final _contTalukCtrl = TextEditingController(); // Taluk (separate from District)
  final _contDistCtrl = TextEditingController();
  final _contStateCtrl = TextEditingController(text: 'Tamil Nadu');
  final _contPinCtrl = TextEditingController();

  // Step 3: Spiritual & Affiliation
  String _ministryFunction = 'Pastor';
  final _trustNameCtrl = TextEditingController();
  String _affiliationOption = 'Independent Church';
  final _affiliationDetailsCtrl = TextEditingController();

  // Step 4: Church Details
  final _churchNameCtrl = TextEditingController();
  final _churchStreetCtrl = TextEditingController();
  final _churchCityCtrl = TextEditingController();
  final _churchPinCtrl = TextEditingController();
  final _churchTeleCtrl = TextEditingController();
  final _churchEmailCtrl = TextEditingController();

  // Step 5: Spiritual Milestones
  final _bornAgainCtrl = TextEditingController();
  final _baptizedCtrl = TextEditingController();
  final _holySpiritCtrl = TextEditingController();
  final _calledCtrl = TextEditingController();
  final _startedCtrl = TextEditingController();
  String _ordainRequest = 'Yes';
  final _promptJoinCtrl = TextEditingController();

  // Step 6: Qualifications & Family
  final _academicCtrl = TextEditingController();
  final _theologicalCtrl = TextEditingController();
  final _familyCtrl = TextEditingController(); // Just a dense text area for mobile UX

  // Step 7: References
  final _ref1NameCtrl = TextEditingController();
  final _ref1PhoneCtrl = TextEditingController();
  final _ref1RelationCtrl = TextEditingController();
  final _ref2NameCtrl = TextEditingController();
  final _ref2PhoneCtrl = TextEditingController();
  final _ref2RelationCtrl = TextEditingController();

  // Step 8: Review & Agree
  bool _agreed = false;

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      FocusScope.of(context).unfocus();
      if (_currentStep < 7) {
        setState(() => _currentStep++);
      } else {
        _proceedToPayment();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // ⚠️ TEST ONLY — REMOVE BEFORE PRODUCTION
  void _autoFillTestData() {
    setState(() {
      // Step 1: Personal
      _nameCtrl.text = 'Rev. John Thomas';
      _baptismalCtrl.text = 'John';
      _dobCtrl.text = '15-06-1985';
      _nationalityCtrl.text = 'Indian';
      _gender = 'Male';
      _maritalStatus = 'Married';

      // Step 2: Address
      _permDoorCtrl.text = '12A';
      _permStreetCtrl.text = 'Grace Nagar, Ambattur';
      _permCityCtrl.text = 'Chennai';
      _permDistCtrl.text = 'Chennai';
      _permTalukCtrl.text = 'Ambattur';
      _permStateCtrl.text = 'Tamil Nadu';
      _permPinCtrl.text = '600053';

      // Step 3: Spiritual
      _ministryFunction = 'Pastor';
      _affiliationOption = 'Independent Church';
      _affiliationDetailsCtrl.text = 'Founder';
      _trustNameCtrl.text = 'Grace Ministries Trust';

      // Step 4: Church
      _churchNameCtrl.text = 'Grace Church';
      _churchStreetCtrl.text = 'Main Road, Ambattur';
      _churchCityCtrl.text = 'Chennai';
      _churchPinCtrl.text = '600053';
      _churchTeleCtrl.text = '9876543210';
      _churchEmailCtrl.text = 'john@example.com';

      // Step 5: Milestones
      _bornAgainCtrl.text = '2005';
      _baptizedCtrl.text = '2006';
      _holySpiritCtrl.text = '2006';
      _calledCtrl.text = '2008';
      _startedCtrl.text = '2010';
      _ordainRequest = 'Yes';
      _promptJoinCtrl.text = 'To grow in leadership and serve the community.';

      // Step 6: Qualifications
      _academicCtrl.text = 'B.A. English, 2005, Madras University';
      _theologicalCtrl.text = 'B.Th., 2008, Southern Asia Bible College';
      _familyCtrl.text = 'Spouse: Mary Thomas (DOB: 20-03-1988). Children: Sarah (2012), Daniel (2015).';

      // Step 7: References
      _ref1NameCtrl.text = 'Pastor Samuel | ACI-001';
      _ref1PhoneCtrl.text = '9876500000';
      _ref1RelationCtrl.text = '2015';
      _ref2NameCtrl.text = 'Pastor David | ACI-002';
      _ref2PhoneCtrl.text = '9876511111';
      _ref2RelationCtrl.text = '2018';
    });
  }

  void _proceedToPayment() {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to the disclaimer to proceed.')));
      return;
    }

    final appId = 'APP-${DateTime.now().millisecondsSinceEpoch}';
    final permAddr = '${_permDoorCtrl.text}, ${_permStreetCtrl.text}, ${_permCityCtrl.text}, ${_permTalukCtrl.text}, ${_permDistCtrl.text}, ${_permStateCtrl.text} - ${_permPinCtrl.text}';

    _data.addAll({
      'id': appId,
      'type': 'add',
      'name': _nameCtrl.text.trim(),
      'baptismal_name': _baptismalCtrl.text.trim(),
      'dob': _dobCtrl.text.trim(),
      'nationality': _nationalityCtrl.text.trim(),
      'gender': _gender,
      'marital_status': _maritalStatus,
      'permanent_address': permAddr,
      'contact_address': _sameAsPerm
          ? permAddr
          : '${_contDoorCtrl.text}, ${_contStreetCtrl.text}, ${_contCityCtrl.text}, ${_contTalukCtrl.text}, ${_contDistCtrl.text}, ${_contStateCtrl.text} - ${_contPinCtrl.text}',
      'ministry_function': _ministryFunction,
      'affiliation': '$_affiliationOption: ${_affiliationDetailsCtrl.text}',
      'trust_name': _trustNameCtrl.text.trim(),
      'church_name': _churchNameCtrl.text.trim(),
      'church_address': '${_churchStreetCtrl.text}, ${_churchCityCtrl.text} - ${_churchPinCtrl.text}',
      'telephone': _churchTeleCtrl.text.trim(),
      'email': _churchEmailCtrl.text.trim(),
      'spiritual_milestones': 'BornAgain: ${_bornAgainCtrl.text} | Baptized: ${_baptizedCtrl.text} | Spirit: ${_holySpiritCtrl.text} | Called: ${_calledCtrl.text} | Started: ${_startedCtrl.text}',
      'ordination_request': _ordainRequest,
      'prompt_to_join': _promptJoinCtrl.text.trim(),
      'academic_qual': _academicCtrl.text.trim(),
      'theological_qual': _theologicalCtrl.text.trim(),
      'family_details': _familyCtrl.text.trim(),
      'reference_1': '${_ref1NameCtrl.text} | ${_ref1PhoneCtrl.text} | Since ${_ref1RelationCtrl.text}',
      'reference_2': '${_ref2NameCtrl.text} | ${_ref2PhoneCtrl.text} | Since ${_ref2RelationCtrl.text}',
    });

    context.push('/join/payment', extra: _data);
  }

  // ── Validators ──
  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!regex.hasMatch(v.trim())) return 'Invalid email format';
    return null;
  }

  String? _phoneValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final digits = v.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 10) return 'Must be 10 digits';
    return null;
  }

  String? _pinValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (v.trim().length != 6 || int.tryParse(v.trim()) == null) return 'Must be 6 digits';
    return null;
  }

  Widget _buildField(String label, TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          counterText: '', // Hide the 0/10 counter text below the field
        ),
        maxLines: maxLines,
        keyboardType: type,
        validator: validator ?? (v) => v!.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildOptionalField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        ),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildEmailField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: _emailValidator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('Diocesan Membership Application Form'), titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      body: Column(
        children: [
          // ⚠️ TEST ONLY — REMOVE BEFORE PRODUCTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12)),
              onPressed: _autoFillTestData,
              child: const Text('⚠️ AUTO FILL TEST DATA (ALL STEPS)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _prevStep,
        physics: const ClampingScrollPhysics(),
        controlsBuilder: (context, details) {
          final isLast = _currentStep == 7;
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: isLast ? AppColors.sage : AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: details.onStepContinue,
                  child: Text(isLast ? 'Proceed to Payment' : 'Next Step', style: const TextStyle(fontWeight: FontWeight.bold)),
                )),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
                ]
              ],
            ),
          );
        },
        steps: [
          // Step 1: Personal
          Step(
            isActive: _currentStep >= 0,
            title: const Text('I. Personal Details (தனிப்பட்ட விவரங்கள்)'),
            content: Form(
              key: _formKeys[0],
              child: Column(children: [
                _buildField('Full Name (முழுப் பெயர்)', _nameCtrl),
                _buildField('Baptismal Name (ஞானஸ்நான பெயர்)', _baptismalCtrl),
                _buildField('Date of Birth (பிறந்த தேதி)', _dobCtrl),
                _buildField('Nationality (தேசியம்)', _nationalityCtrl),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(labelText: 'Gender (பாலினம்)', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Male', 'Female'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _gender = v!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _maritalStatus,
                  decoration: InputDecoration(labelText: 'Marital Status (திருமண நிலை)', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Married', 'Bachelor', 'Spinster', 'Widowed'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _maritalStatus = v!),
                ),
              ]),
            ),
          ),
          
          // Step 2: Address
          Step(
            isActive: _currentStep >= 1,
            title: const Text('Address (முகவரி)'),
            content: Form(
              key: _formKeys[1],
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Permanent Address (நிரந்தர முகவரி)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.sage)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(flex: 1, child: _buildField('Door No', _permDoorCtrl)),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: _buildField('Street Name', _permStreetCtrl)),
                ]),
                Row(children: [
                  Expanded(child: _buildField('City/Town', _permCityCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField('Pincode', _permPinCtrl, type: TextInputType.number, validator: _pinValidator, maxLength: 6)),
                ]),
                Row(children: [
                  Expanded(child: _buildField('Taluk', _permTalukCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField('District', _permDistCtrl)),
                ]),
                _buildField('State', _permStateCtrl),
                
                const Divider(height: 32),
                Row(children: [
                  const Text('Contact Address (தொடர்பு முகவரி)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.sage)),
                  const Spacer(),
                  Checkbox(value: _sameAsPerm, onChanged: (v) => setState(() => _sameAsPerm = v!)),
                  const Text('Same', style: TextStyle(fontSize: 12)),
                ]),
                const SizedBox(height: 12),
                if (!_sameAsPerm) ...[
                  Row(children: [
                    Expanded(flex: 1, child: _buildField('Door No', _contDoorCtrl)),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: _buildField('Street Name', _contStreetCtrl)),
                  ]),
                  Row(children: [
                    Expanded(child: _buildField('City/Town', _contCityCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildField('Pincode', _contPinCtrl, type: TextInputType.number, validator: _pinValidator, maxLength: 6)),
                  ]),
                  Row(children: [
                    Expanded(child: _buildField('Taluk', _contTalukCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildField('District', _contDistCtrl)),
                  ]),
                  _buildField('State', _contStateCtrl),
                ],
              ]),
            ),
          ),

          // Step 3: Spiritual & Affiliation
          Step(
            isActive: _currentStep >= 2,
            title: const Text('Spiritual & Affiliation (ஆவிக்குரிய & இணைப்பு)'),
            content: Form(
              key: _formKeys[2],
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                DropdownButtonFormField<String>(
                  value: _ministryFunction,
                  decoration: InputDecoration(labelText: 'Ministry Function (ஊழிய பணி)', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Apostle', 'Prophet', 'Evangelist', 'Pastor', 'Teacher', 'Associate Pastor', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _ministryFunction = v!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _affiliationOption,
                  decoration: InputDecoration(labelText: 'Affiliation Type (இணைப்பு வகை)', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Independent Church', 'Denomination', 'Associate / Assistant'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _affiliationOption = v!),
                ),
                const SizedBox(height: 16),
                _buildOptionalField('Detail (Founder/Denom/Chief Pastor Name)', _affiliationDetailsCtrl),
                _buildOptionalField('Name of your Trust (if any)', _trustNameCtrl),
              ]),
            ),
          ),

          // Step 4: Church Details
          Step(
            isActive: _currentStep >= 3,
            title: const Text('IV. Church Details (தேவாலய விவரங்கள்)'),
            content: Form(
              key: _formKeys[3],
              child: Column(children: [
                _buildField('Church Name (தேவாலய பெயர்)', _churchNameCtrl),
                _buildField('Street Address', _churchStreetCtrl),
                Row(children: [
                  Expanded(child: _buildField('City / Town', _churchCityCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField('Pincode', _churchPinCtrl, type: TextInputType.number, validator: _pinValidator, maxLength: 6)),
                ]),
                Row(children: [
                  Expanded(child: _buildField('Mobile (கைபேசி)', _churchTeleCtrl, type: TextInputType.phone, validator: _phoneValidator, maxLength: 10)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildEmailField('Email (மின்னஞ்சல்)', _churchEmailCtrl)),
                ]),
              ]),
            ),
          ),

          // Step 5: Milestones
          Step(
            isActive: _currentStep >= 4,
            title: const Text('V. Spiritual Milestones (ஆவிக்குரிய மைல்கற்கள்)'),
            content: Form(
              key: _formKeys[4],
              child: Column(children: [
                _buildField('When did you born again? (Year)', _bornAgainCtrl),
                _buildField('When did you baptize in full immersion?', _baptizedCtrl),
                _buildField('When did you fill with the Holy Spirit?', _holySpiritCtrl),
                _buildField('When did you call for Ministry?', _calledCtrl),
                _buildField('When did you start the Ministry?', _startedCtrl),
                DropdownButtonFormField<String>(
                  value: _ordainRequest,
                  decoration: InputDecoration(labelText: 'Do you want to be ordained by us?', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _ordainRequest = v!),
                ),
                const SizedBox(height: 16),
                _buildOptionalField('What prompts you to join APOSTOLIC COUNCIL OF INDIA DIOCESE?', _promptJoinCtrl, maxLines: 3),
              ]),
            ),
          ),

          // Step 6: Qualifications
          Step(
            isActive: _currentStep >= 5,
            title: const Text('Qualifications & Family (தகுதிகள் & குடும்பம்)'),
            content: Form(
              key: _formKeys[5],
              child: Column(children: [
                _buildOptionalField('Academic Qualification (Degree, Year, Univ.)', _academicCtrl, maxLines: 3),
                _buildOptionalField('Theological Qualification (Degree, Year, Sem.)', _theologicalCtrl, maxLines: 3),
                _buildOptionalField('Family Details (Spouse/Children Names, DOB)', _familyCtrl, maxLines: 4),
              ]),
            ),
          ),

          // Step 7: Refs
          Step(
            isActive: _currentStep >= 6,
            title: const Text('References (பரிந்துரைகள்)'),
            content: Form(
               key: _formKeys[6],
               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                 const Text('Reference 1 (District Overseer/Member)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.sage)),
                 const SizedBox(height: 12),
                 _buildField('Name & Diocesan ID', _ref1NameCtrl),
                 _buildField('Mobile', _ref1PhoneCtrl, type: TextInputType.phone, validator: _phoneValidator, maxLength: 10),
                 _buildField('I know this person since (Year)', _ref1RelationCtrl),
                 const Divider(height: 32),
                 const Text('Reference 2 (Taluk Co-ordinator/Member)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.sage)),
                 const SizedBox(height: 12),
                 _buildField('Name & Diocesan ID', _ref2NameCtrl),
                 _buildField('Mobile', _ref2PhoneCtrl, type: TextInputType.phone, validator: _phoneValidator, maxLength: 10),
                 _buildField('I know this person since (Year)', _ref2RelationCtrl),
               ]),
            ),
          ),

          // Step 8: Review & Agree
          Step(
            isActive: _currentStep >= 7,
            title: const Text('Review & Agree (சரிபார்த்து ஒப்புக்கொள்)'),
            content: Form(
              key: _formKeys[7],
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Please review all your physical form details carefully before paying the registration fee.', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.warning)),
                  child: const Text('Disclaimer: I hereby declare that the information furnished above is true to the best of my knowledge.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _agreed,
                  onChanged: (v) => setState(() => _agreed = v!),
                  title: const Text('I agree to the Terms and Conditions of ACI Diocese and submit to episcopal authority.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.sage,
                )
              ])
            ),
          )
        ],       // end steps list
      ),          // end Stepper
    ),            // end Expanded
    ],            // end Column children
  ),              // end Column (body)
);              // end Scaffold
}
}
