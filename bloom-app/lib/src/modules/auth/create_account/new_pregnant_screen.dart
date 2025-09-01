import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // Necessário para usar jsonEncode
import 'dart:async'; // Necessário para usar o TimeoutException
import 'package:http/http.dart'
    as http; // Necessário para fazer as chamadas à API
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';
import 'package:app/src/modules/dashboard-pregnant/homepage.dart';
import 'new_doctor_screen.dart';
import 'package:app/src/core/constants/constants.dart';

// --- CONSTANTES DE CORES ---
const Color K_MAIN_PINK = Color(0xFFE91E63);
const Color K_TEXT_GRAY = Color(0xFF616161);
const Color K_FIELD_BACKGROUND = Color(0xFFF5F5F5);

// Enum para rastrear o perfil selecionado no Switch.
enum ProfileRole { pregnant, professional }

class NewPregnantScreen extends StatefulWidget {
  const NewPregnantScreen({super.key});

  @override
  State<NewPregnantScreen> createState() => _NewPregnantScreenState();
}

class _NewPregnantScreenState extends State<NewPregnantScreen> {
  // --- VARIÁVEIS DE ESTADO ---
  int _currentStep = 0;
  ProfileRole _selectedRole = ProfileRole.pregnant;
  bool _termsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // --- CONTROLADORES DE TEXTO ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _lastMenstruationDateController = TextEditingController();
  final _documentoController = TextEditingController();
  final _dppController = TextEditingController();
  final _antecedentesFamiliaresController = TextEditingController();
  final _antecedentesGinecologicosController = TextEditingController();
  final _antecedentesObstetricosController = TextEditingController();

  // --- CHAVES DO FORMULÁRIO ---
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  @override
  void dispose() {
    // Limpeza de todos os controladores para evitar vazamento de memória.
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    _lastMenstruationDateController.dispose();
    _documentoController.dispose();
    _dppController.dispose();
    _antecedentesFamiliaresController.dispose();
    _antecedentesGinecologicosController.dispose();
    _antecedentesObstetricosController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE NAVEGAÇÃO E SUBMISSÃO ---
  void _nextStep() {
    if (_formKeyStep1.currentState!.validate()) {
      setState(() => _currentStep = 1);
    }
  }

  void _previousStep() {
    setState(() => _currentStep = 0);
  }

  void _submitForm() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, aceite os termos e condições.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKeyStep2.currentState!.validate()) return;

    // Exibe um diálogo de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    String formatarDataParaApi(String dataUI) {
      if (dataUI.isEmpty) return '';
      try {
        final formatoEntrada = DateFormat('dd/MM/yyyy');
        final data = formatoEntrada.parse(dataUI);
        final formatoSaida = DateFormat('yyyy-MM-dd');
        return formatoSaida.format(data);
      } catch (_) {
        return '';
      }
    }

    final dadosCadastro = {
      "email": _emailController.text,
      "senha": _passwordController.text,
      "perfil": "GESTANTE",
      "nome": _nameController.text,
      "documento": _documentoController.text,
      "tipo_documento": "cpf",
      "data_nascimento": formatarDataParaApi(_birthDateController.text),
      "dum": formatarDataParaApi(_lastMenstruationDateController.text),
      "dpp": formatarDataParaApi(_dppController.text),
      "antecedentes_familiares": _antecedentesFamiliaresController.text,
      "antecedentes_ginecologicos": _antecedentesGinecologicosController.text,
      "antecedentes_obstetricos": _antecedentesObstetricosController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('$kApiBaseUrl/api/auth/registro/gestante'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosCadastro),
      );

      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (!mounted) return;
      Navigator.of(context).pop(); // Fecha o diálogo de carregamento

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseBody['token']);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso! Bem-vinda!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage =
            responseBody['detail'] ?? 'Ocorreu um erro no cadastro.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O servidor demorou muito para responder.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro de conexão: verifique sua rede e se o servidor está online.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _currentStep == 0 ? 'Criar Conta de Gestante' : 'Complete seu Perfil',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentStep == 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Image.asset('assets/images/bloom_logo.png', height: 85),
            const SizedBox(height: 24),
            _buildRoleSelector(),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentStep == 0
                  ? _buildStep1Content()
                  : _buildStep2Content(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _currentStep == 0
                    ? _nextStep
                    : (_termsAccepted ? _submitForm : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: K_MAIN_PINK,
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  _currentStep == 0 ? 'Próximo' : 'Criar conta',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Gestante',
          style: TextStyle(color: K_MAIN_PINK, fontWeight: FontWeight.bold),
        ),
        Switch(
          value: _selectedRole == ProfileRole.professional,
          onChanged: (value) {
            if (value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const NewDoctorScreen(),
                ),
              );
            }
          },
          activeColor: K_MAIN_PINK,
          inactiveThumbColor: K_MAIN_PINK,
          inactiveTrackColor: K_MAIN_PINK.withOpacity(0.3),
        ),
        const Text(
          'Profissional',
          style: TextStyle(color: K_TEXT_GRAY, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStep1Content() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        key: const ValueKey('step1'),
        children: [
          _buildTextField(
            controller: _emailController,
            label: 'Insira seu melhor email',
            hint: 'seuemail@gmail.com',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || v.isEmpty || !v.contains('@'))
                ? 'Email inválido.'
                : null,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _passwordController,
            label: 'Crie sua senha',
            hint: '**********',
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? 'Mínimo de 6 caracteres.' : null,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirme sua senha',
            hint: '**********',
            obscureText: !_isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              ),
            ),
            validator: (v) => v != _passwordController.text
                ? 'As senhas não coincidem.'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Content() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        key: const ValueKey('step2'),
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Nome completo',
            hint: 'Seu nome...',
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Nome obrigatório.' : null,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _documentoController,
            label: 'CPF',
            hint: '000.000.000-00',
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'CPF obrigatório.' : null,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _birthDateController,
            label: 'Data de nascimento',
            hint: 'DD/MM/AAAA',
            isReadOnly: true,
            onTap: () => _selectDate(context, _birthDateController),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Data obrigatória.' : null,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _lastMenstruationDateController,
            label: 'Data da última menstruação (DUM)',
            hint: 'DD/MM/AAAA',
            isReadOnly: true,
            onTap: () => _selectDate(context, _lastMenstruationDateController),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Data obrigatória.' : null,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _dppController,
            label: 'Data Provável do Parto (DPP)',
            hint: 'DD/MM/AAAA',
            isReadOnly: true,
            onTap: () => _selectDate(context, _dppController),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Data obrigatória.' : null,
          ),
          const SizedBox(height: 24),
          _buildMultiLineTextField(
            controller: _antecedentesFamiliaresController,
            label: 'Antecedentes Familiares',
            hint: 'Ex: diabetes, hipertensão na família...',
          ),
          const SizedBox(height: 24),
          _buildMultiLineTextField(
            controller: _antecedentesGinecologicosController,
            label: 'Antecedentes Ginecológicos',
            hint: 'Ex: cirurgias, doenças prévias...',
          ),
          const SizedBox(height: 24),
          _buildMultiLineTextField(
            controller: _antecedentesObstetricosController,
            label: 'Antecedentes Obstétricos',
            hint: 'Ex: número de gestações, partos anteriores...',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (bool? newValue) =>
                    setState(() => _termsAccepted = newValue!),
                activeColor: K_MAIN_PINK,
              ),
              const Expanded(
                child: Text(
                  'Eu aceito os Termos de Uso e Política de Privacidade',
                  style: TextStyle(fontSize: 14, color: K_TEXT_GRAY),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    Widget? suffixIcon,
    bool obscureText = false,
    bool isReadOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: K_TEXT_GRAY, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          validator: validator,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon:
                suffixIcon ??
                (isReadOnly
                    ? const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      )
                    : null),
            filled: true,
            fillColor: K_FIELD_BACKGROUND,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: K_MAIN_PINK, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiLineTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: K_TEXT_GRAY, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: K_FIELD_BACKGROUND,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: K_MAIN_PINK, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: K_MAIN_PINK),
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Widget _buildFooter() {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const LoginScreen())),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text.rich(
          TextSpan(
            text: 'Já possui uma conta? ',
            style: TextStyle(color: K_TEXT_GRAY, fontSize: 16),
            children: [
              TextSpan(
                text: 'Entrar',
                style: TextStyle(
                  color: K_MAIN_PINK,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
