import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart'
    as http; // Necessário para fazer as chamadas à API
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';
import 'package:app/src/modules/dashboard/homepage.dart';
import 'new_pregnant_screen.dart'; // Para navegação no Switch
import 'package:app/src/core/constants/constants.dart';

// --- CONSTANTES ---
const Color K_MAIN_PINK = Color(0xFFE91E63);
const Color K_TEXT_GRAY = Color(0xFF616161);
const Color K_FIELD_BACKGROUND = Color(0xFFF5F5F5);

// Lista de especialidades para o Dropdown
const List<String> kEspecialidades = [
  'Acupuntura',
  'Alergia e Imunologia',
  'Cardiologia',
  'Dermatologia',
  'Endocrinologia',
  'Fisioterapia',
  'Ginecologia e Obstetrícia',
  'Nutrição',
  'Pediatria',
  'Psicologia',
  'Psiquiatria',
];

class NewDoctorScreen extends StatefulWidget {
  const NewDoctorScreen({super.key});

  @override
  State<NewDoctorScreen> createState() => _NewDoctorScreenState();
}

class _NewDoctorScreenState extends State<NewDoctorScreen> {
  // --- VARIÁVEIS DE ESTADO ---
  int _currentStep = 0;
  bool _termsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // --- CONTROLADORES DE TEXTO ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _documentoController = TextEditingController(); // CPF
  final _birthDateController = TextEditingController();
  final _registroController = TextEditingController();
  String? _selectedEspecialidade;

  // --- CHAVES DO FORMULÁRIO ---
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _documentoController.dispose();
    _birthDateController.dispose();
    _registroController.dispose();
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

  // ############# FUNÇÃO CORRIGIDA #############
  // Formata a data para o padrão ISO 8601 (ex: "2025-08-31T00:00:00.000Z")
  String _formatarDataParaApi(String dataUI) {
    if (dataUI.isEmpty) return '';
    try {
      // Converte a string do formulário ('dd/MM/yyyy') para um objeto DateTime
      final data = DateFormat('dd/MM/yyyy').parse(dataUI);
      // Converte o objeto DateTime para o formato ISO 8601 em UTC.
      // É exatamente isso que a sua API espera, conforme o Swagger.
      return data.toUtc().toIso8601String();
    } catch (e) {
      // Se houver qualquer erro na conversão, retorna uma string vazia.
      debugPrint("Erro ao formatar data: $e");
      return '';
    }
  }

  Future<void> _submitForm() async {
    if (!_termsAccepted || !_formKeyStep2.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha todos os campos e aceite os termos.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: K_MAIN_PINK)),
    );

    final dadosCadastro = {
      "email": _emailController.text,
      "senha": _passwordController.text,
      "perfil": "PROFISSIONAL",
      "nome": _nameController.text,
      "documento": _documentoController.text,
      "tipo_documento": "cpf",
      "data_nascimento": _formatarDataParaApi(_birthDateController.text),
      "especialidade": _selectedEspecialidade,
      "registro": _registroController.text,
    };

    try {
      final response = await http
          .post(
            Uri.parse('$kApiBaseUrl/api/auth/registro/profissional'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dadosCadastro),
          )
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;
      Navigator.of(context).pop();

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseBody['token']);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      } else {
        // ### PASSO DE DEBUG: ADICIONE ESTA LINHA! ###
        // Ela vai imprimir o corpo completo da resposta de erro no console.
        print("ERRO 422 - Corpo da Resposta da API: ${response.body}");
        // ###############################################

        final errorMessage =
            responseBody['detail'] ?? "Ocorreu um erro desconhecido.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O servidor demorou para responder. Tente novamente.'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro de conexão: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // O restante do código permanece o mesmo...
  // (build, _buildRoleSelector, _buildStep1Content, etc.)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _currentStep == 0
              ? 'Criar Conta Profissional'
              : 'Complete seu Perfil',
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
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
        child: Column(
          children: [
            Image.asset('assets/images/bloom_logo.png', height: 85),
            const SizedBox(height: 24),
            _buildRoleSelector(),
            const SizedBox(height: 32),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  _currentStep == 0 ? 'Próximo' : 'Criar conta',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
          style: TextStyle(color: K_TEXT_GRAY, fontWeight: FontWeight.bold),
        ),
        Switch(
          value: true,
          onChanged: (value) {
            if (!value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const NewPregnantScreen(),
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
          style: TextStyle(color: K_MAIN_PINK, fontWeight: FontWeight.bold),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _buildDateField(
            context: context,
            controller: _birthDateController,
            label: 'Data de nascimento',
            hint: 'DD/MM/AAAA',
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Data obrigatória.' : null,
          ),
          const SizedBox(height: 24),
          _buildDropdownEspecialidade(),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _registroController,
            label: 'Número de Registro Profissional + UF',
            hint: 'CRM/SP 123456',
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Registro obrigatório.' : null,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (bool? newValue) =>
                    setState(() => _termsAccepted = newValue ?? false),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: K_TEXT_GRAY, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
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

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    Future<void> selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1920),
        lastDate: DateTime.now(),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: K_TEXT_GRAY, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          validator: validator,
          onTap: selectDate,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey,
            ),
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

  Widget _buildDropdownEspecialidade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Especialidade',
          style: TextStyle(color: K_TEXT_GRAY, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedEspecialidade,
          hint: const Text('Selecione sua especialidade'),
          isExpanded: true,
          decoration: InputDecoration(
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
          items: kEspecialidades.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedEspecialidade = newValue;
            });
          },
          validator: (value) => value == null ? 'Campo obrigatório' : null,
        ),
      ],
    );
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
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
