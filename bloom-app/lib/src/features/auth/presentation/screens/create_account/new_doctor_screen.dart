import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/utils/constants.dart';
import 'package:app/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/home/homepage.dart';
import 'package:app/src/shared/widgets/role_selector_switch.dart';
import 'new_pregnant_screen.dart';

/// Tela de cadastro para profissionais, com um formulário em 3 etapas.
class NewDoctorScreen extends StatefulWidget {
  const NewDoctorScreen({super.key});

  @override
  State<NewDoctorScreen> createState() => _NewDoctorScreenState();
}

class _NewDoctorScreenState extends State<NewDoctorScreen> {
  // Controle de estado do formulário
  int _currentStep = 0; // Agora vai de 0 a 2
  bool _termsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedEspecialidade;

  // Chaves de validação para cada etapa
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // Controladores de campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _documentoController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _registroController = TextEditingController();

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

  /// Avança para a próxima etapa do formulário se a atual for válida.
  void _nextStep() {
    bool isValid = false;
    if (_currentStep == 0) {
      isValid = _formKeyStep1.currentState?.validate() ?? false;
    } else if (_currentStep == 1) {
      isValid = _formKeyStep2.currentState?.validate() ?? false;
    }

    if (isValid) {
      setState(() => _currentStep++);
    }
  }

  /// Retorna para a etapa anterior.
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  /// Valida a última etapa e submete todos os dados para a API.
  Future<void> _submitForm() async {
    final isStep3Valid = _formKeyStep3.currentState?.validate() ?? false;
    if (!isStep3Valid || !_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos e aceite os termos.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
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

      final response = await http
          .post(
            Uri.parse('http://localhost:8000/api/auth/registro/profissional'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dadosCadastro),
          )
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseBody['token']);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      } else {
        final errorMessage =
            responseBody['detail'] ?? "Ocorreu um erro desconhecido.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O servidor demorou para responder. Tente novamente.'),
          backgroundColor: AppColors.warning,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro de conexão: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatarDataParaApi(String dataUI) {
    if (dataUI.isEmpty) return '';
    try {
      final data = DateFormat('dd/MM/yyyy').parse(dataUI);
      return data.toUtc().toIso8601String();
    } catch (e) {
      debugPrint("Erro ao formatar data: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta (Etapa ${_currentStep + 1}/3)'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Image.asset('assets/images/bloom_logo.png', height: 85),
            const SizedBox(height: 24),
            RoleSelectorSwitch(
              currentRole: Persona.doctor,
              onSwitchedToDoctor: () {},
              onSwitchedToPregnant: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const NewPregnantScreen()),
              ),
            ),
            const SizedBox(height: 32),
            _buildCurrentStep(),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator(color: AppColors.primaryPink)
            else
              ElevatedButton(
                onPressed: _currentStep < 2 ? _nextStep : _submitForm,
                child: Text(
                  _currentStep < 2 ? 'Próximo' : 'Finalizar Cadastro',
                ),
              ),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// Retorna o widget do formulário da etapa atual.
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Content();
      case 1:
        return _buildStep2Content();
      case 2:
        return _buildStep3Content();
      default:
        return _buildStep1Content();
    }
  }

  Widget _buildStep1Content() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        children: [
          _buildTextField(
            controller: _emailController,
            label: 'E-mail',
            hint: 'seu@email.com',
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
                color: AppColors.textGray,
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
                color: AppColors.textGray,
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
            controller: _birthDateController,
            label: 'Data de nascimento',
            hint: 'DD/MM/AAAA',
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Data obrigatória.' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Content() {
    return Form(
      key: _formKeyStep3,
      child: Column(
        children: [
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
                onChanged: (val) =>
                    setState(() => _termsAccepted = val ?? false),
                activeColor: AppColors.primaryPink,
              ),
              const Expanded(
                child: Text(
                  'Eu aceito os Termos de Uso',
                  style: TextStyle(color: AppColors.textGray),
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
        Text(
          label,
          style: const TextStyle(color: AppColors.textGray, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textGray, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          validator: validator,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
              builder: (context, child) => Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryPink,
                  ),
                ),
                child: child!,
              ),
            );
            if (pickedDate != null) {
              controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textGray,
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
          style: TextStyle(color: AppColors.textGray, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedEspecialidade,
          hint: const Text('Selecione sua especialidade'),
          isExpanded: true,
          items: kEspecialidades.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) =>
              setState(() => _selectedEspecialidade = newValue),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text.rich(
          TextSpan(
            text: 'Já possui uma conta? ',
            style: const TextStyle(color: AppColors.textGray, fontSize: 16),
            children: [
              const TextSpan(
                text: 'Entrar',
                style: TextStyle(
                  color: AppColors.primaryPink,
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
