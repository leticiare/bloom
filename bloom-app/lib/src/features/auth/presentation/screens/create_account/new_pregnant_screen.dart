import 'dart:async';
import 'package:app/src/features/dashboard_pregnant/presentation/screens/dashboard_shell.dart';
import 'package:app/src/shared/services/registration_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/core/utils/constants.dart';
import 'package:app/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:app/src/shared/widgets/role_selector_switch.dart';
import 'new_doctor_screen.dart';

/// Tela de cadastro para gestantes, com um formulário em 4 etapas.
class NewPregnantScreen extends StatefulWidget {
  const NewPregnantScreen({super.key});

  @override
  State<NewPregnantScreen> createState() => _NewPregnantScreenState();
}

class _NewPregnantScreenState extends State<NewPregnantScreen> {
  // Controle de estado do formulário
  int _currentStep = 0; // Agora vai de 0 a 3
  bool _termsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // Chaves de validação para cada etapa
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // Controladores
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

  final _registrationService = RegistrationService();

  @override
  void dispose() {
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

  /// Avança para a próxima etapa do formulário.
  void _nextStep() {
    bool isValid = false;
    if (_currentStep == 0) {
      isValid = _formKeyStep1.currentState?.validate() ?? false;
    } else if (_currentStep == 1) {
      isValid = _formKeyStep2.currentState?.validate() ?? false;
    } else if (_currentStep == 2) {
      isValid = (_formKeyStep3.currentState?.validate() ?? false);
      if (isValid && !_termsAccepted) {
        isValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você precisa aceitar os termos de uso.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
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

  /// Submete todos os dados do formulário para a API.
  Future<void> _submitForm() async {
    // A validação final acontece antes de chamar este método, na Etapa 3.
    setState(() => _isLoading = true);

    try {
      final dadosCadastro = {
        "email": _emailController.text,
        "senha": _passwordController.text,
        "perfil": "GESTANTE",
        "nome": _nameController.text,
        "documento": _documentoController.text,
        "tipo_documento": "cpf",
        "data_nascimento": _formatarDataParaApi(_birthDateController.text),
        "dum": _formatarDataParaApi(_lastMenstruationDateController.text),
        "dpp": _formatarDataParaApi(_dppController.text),
        "antecedentes_familiares": _antecedentesFamiliaresController.text,
        "antecedentes_ginecologicos": _antecedentesGinecologicosController.text,
        "antecedentes_obstetricos": _antecedentesObstetricosController.text,
      };

      final error = await _registrationService.register(
        userData: dadosCadastro,
      );

      if (error != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
        return;
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso! Bem-vinda!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardShell()),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O servidor demorou para responder.'),
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
      return DateFormat(
        'yyyy-MM-dd',
      ).format(DateFormat('dd/MM/yyyy').parse(dataUI));
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = 'Próximo';
    VoidCallback buttonAction = _nextStep;

    if (_currentStep == 3) {
      buttonText = 'Finalizar Cadastro';
      buttonAction = _submitForm;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta (Etapa ${_currentStep + 1}/4)'),
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
            if (_currentStep < 3)
              RoleSelectorSwitch(
                currentRole: Persona.pregnant,
                onSwitchedToDoctor: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const NewDoctorScreen()),
                ),
                onSwitchedToPregnant: () {},
              ),
            const SizedBox(height: 32),
            _buildCurrentStep(),
            const SizedBox(height: 32),
            if (_isLoading)
              const CircularProgressIndicator(color: AppColors.primaryPink)
            else
              ElevatedButton(onPressed: buttonAction, child: Text(buttonText)),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Content();
      case 1:
        return _buildStep2Content();
      case 2:
        return _buildStep3Content();
      case 3:
        return _buildStep4Content();
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
          _buildDateField(
            controller: _lastMenstruationDateController,
            label: 'Data da última menstruação (DUM)',
            hint: 'DD/MM/AAAA',
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo obrigatório.' : null,
          ),
          const SizedBox(height: 24),
          _buildDateField(
            controller: _dppController,
            label: 'Data Provável do Parto (DPP)',
            hint: 'DD/MM/AAAA',
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo obrigatório.' : null,
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
              const Expanded(child: Text('Eu aceito os Termos de Uso')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Content() {
    return Column(
      key: const ValueKey('step4'),
      children: [
        const Text(
          "Informações Adicionais",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Estas informações são opcionais, mas nos ajudam a personalizar sua experiência.",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textGray),
        ),
        const SizedBox(height: 24),
        _buildMultiLineTextField(
          controller: _antecedentesFamiliaresController,
          label: 'Antecedentes Familiares',
          hint: 'Ex: diabetes, hipertensão...',
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
          hint: 'Ex: número de gestações...',
        ),
      ],
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
              firstDate: DateTime(1900),
              lastDate: DateTime.now().add(const Duration(days: 365)),
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

  Widget _buildMultiLineTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
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
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(hintText: hint),
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
