// lib/modules/auth/create_account/new_doctor_screen.dart

import 'package:flutter/material.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';
import 'email_confirmation_screen.dart';
import 'new_pregnant_screen.dart'; // Importa a tela de gestante para a navegação.

// --- CONSTANTES DE CORES ---
const Color K_MAIN_PINK = Color(0xFFE91E63);
const Color K_TEXT_GRAY = Color(0xFF616161);
const Color K_FIELD_BACKGROUND = Color(0xFFF5F5F5);

// Enum para rastrear o perfil selecionado no Switch.
enum ProfileRole { pregnant, professional }

class NewDoctorScreen extends StatefulWidget {
  const NewDoctorScreen({super.key});

  @override
  State<NewDoctorScreen> createState() => _NewDoctorScreenState();
}

class _NewDoctorScreenState extends State<NewDoctorScreen> {
  // --- VARIÁVEIS DE ESTADO ---
  int _currentStep = 0;
  ProfileRole _selectedRole =
      ProfileRole.professional; // Começa como Profissional.
  bool _termsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Controladores para os campos de texto.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _crmController = TextEditingController();
  final _documentController = TextEditingController();

  // Chaves para validar os formulários de cada etapa.
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Libera a memória dos controladores.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _crmController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE LÓGICA E NAVEGAÇÃO ---

  void _nextStep() {
    if (_formKeyStep1.currentState!.validate()) {
      setState(() {
        _currentStep = 1;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep = 0;
    });
  }

  void _submitForm() {
    if (_formKeyStep2.currentState!.validate() && _termsAccepted) {
      final email = _emailController.text;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EmailConfirmationScreen(email: email),
        ),
      );
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, aceite os termos e condições.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Simula a ação de selecionar um documento.
  void _selectDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulando a seleção de um documento...')),
    );
    // Em um app real, aqui você usaria um pacote como 'file_picker'.
    setState(() {
      _documentController.text = "documento_anexado.pdf";
    });
  }

  // --- CONSTRUÇÃO DA INTERFACE (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _currentStep == 0
              ? 'Criar Conta de Profisional'
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Image.asset('assets/images/bloom_logo.png', height: 85),
            const SizedBox(height: 32),
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

  // --- WIDGETS AUXILIARES (COMPONENTES) ---

  Widget _buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Gestante',
          style: TextStyle(
            color: _selectedRole == ProfileRole.pregnant
                ? K_MAIN_PINK
                : K_TEXT_GRAY,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: _selectedRole == ProfileRole.professional,
          onChanged: (value) {
            // Se o usuário desativar o switch, navega para a tela de gestante.
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
        Text(
          'Profissional',
          style: TextStyle(
            color: _selectedRole == ProfileRole.professional
                ? K_MAIN_PINK
                : K_TEXT_GRAY,
            fontWeight: FontWeight.bold,
          ),
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
            suffixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email obrigatório.';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                return 'Email inválido.';
              return null;
            },
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
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Senha obrigatória.';
              if (value.length < 6) return 'Mínimo de 6 caracteres.';
              return null;
            },
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
              onPressed: () {
                setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                );
              },
            ),
            validator: (value) {
              if (value != _passwordController.text)
                return 'As senhas não coincidem.';
              return null;
            },
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
            suffixIcon: const Icon(Icons.person_outline, color: Colors.grey),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Nome obrigatório.';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _crmController,
            label: 'Número de Registro Profissional + UF',
            hint: 'CRM, COREN, etc.',
            suffixIcon: const Icon(
              Icons.credit_card_outlined,
              color: Colors.grey,
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Registro obrigatório.';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _documentController,
            label: 'Fazer upload de documento para validação',
            hint: 'Clique para selecionar...',
            suffixIcon: const Icon(
              Icons.upload_file_outlined,
              color: Colors.grey,
            ),
            isReadOnly: true,
            onTap: _selectDocument,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Documento obrigatório.';
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (bool? newValue) {
                  setState(() => _termsAccepted = newValue!);
                },
                activeColor: K_MAIN_PINK,
              ),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    text: 'Eu aceito os ',
                    style: TextStyle(fontSize: 14, color: K_TEXT_GRAY),
                    children: [
                      TextSpan(
                        text: 'Termos de Uso e Política de Privacidade',
                        style: TextStyle(
                          color: K_MAIN_PINK,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('OU', style: TextStyle(color: K_TEXT_GRAY)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: RichText(
            text: TextSpan(
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
        const SizedBox(height: 24),
      ],
    );
  }
}
