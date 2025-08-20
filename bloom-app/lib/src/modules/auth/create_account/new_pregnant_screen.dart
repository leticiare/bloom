// lib/register_screen.dart (ou new_pregnant.dart, como você preferir)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'email_confirmation_screen.dart'; // Sua tela de confirmação de email
import 'package:app/src/core/theme/app_colors.dart';
import 'package:app/src/modules/auth/login/login_screen.dart'; // Importa a tela de login

// Enum para rastrear o perfil selecionado
enum ProfileRole { pregnant, professional }

class NewPregnantScreen extends StatefulWidget {
  const NewPregnantScreen({super.key});

  @override
  State<NewPregnantScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<NewPregnantScreen> {
  int _currentStep = 0;
  ProfileRole _selectedRole = ProfileRole.pregnant; // Estado inicial: Gestante

  // Controladores de texto para manter os dados (mesmos para ambos os perfis, mas gerenciados)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _lastMenstruationDateController =
      TextEditingController(); // Específico de gestante
  final _crmCpfController =
      TextEditingController(); // Exemplo para profissional

  // Chaves para a validação de cada etapa do formulário
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  bool _termsAccepted = false; // Estado para o checkbox de termos

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    _lastMenstruationDateController.dispose();
    _crmCpfController.dispose();
    super.dispose();
  }

  // --- Funções de Navegação e Validação ---
  void _nextStep() {
    if (_currentStep == 0 && _formKeyStep1.currentState!.validate()) {
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
      // Aqui você faria a chamada para a sua API ou serviço de cadastro
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EmailConfirmationScreen(email: email),
        ),
      );
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, aceite os termos e condições.'),
        ),
      );
    }
  }

  // --- Estilos para os Campos de Texto (InputDecoration) ---
  InputDecoration _customInputDecoration({
    required String labelText,
    String? hintText,
    IconData? suffixIcon,
    bool filledBackground = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      floatingLabelStyle: const TextStyle(color: AppColors.mediumPink),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: AppColors.depperPink)
          : null,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),
      filled: filledBackground,
      fillColor: filledBackground ? AppColors.lightPink : Colors.transparent,
      border: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.depperPink),
            ),
      focusedBorder: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.mediumPink,
                width: 2.0,
              ),
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.mediumPink, width: 2.0),
            ),
      errorBorder: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
      enabledBorder: filledBackground
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            )
          : const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.depperPink),
            ),
    );
  }

  // --- Widgets das Etapas (Conteúdo Dinâmico) ---
  Widget _buildStep1Content() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insira seu melhor email',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _emailController,
            decoration: _customInputDecoration(
              labelText: 'email@gmail.com',
              suffixIcon: Icons.email_outlined,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um email.';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Email inválido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Crie sua senha',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: _customInputDecoration(
              labelText: '**********',
              suffixIcon: Icons.visibility_off_outlined,
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma senha.';
              }
              if (value.length < 6) {
                return 'A senha deve ter pelo menos 6 caracteres.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Confirme sua senha',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: _customInputDecoration(
              labelText: '**********',
              suffixIcon: Icons.visibility_off_outlined,
              filledBackground: true,
            ),
            obscureText: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'As senhas não coincidem.';
              }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nome completo',
            style: TextStyle(fontSize: 16, color: AppColors.depperPink),
          ),
          TextFormField(
            controller: _nameController,
            decoration: _customInputDecoration(
              labelText: 'Seu nome...',
              suffixIcon: Icons.person_outline,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome completo.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          // Campos específicos para Gestante ou Profissional
          if (_selectedRole == ProfileRole.pregnant) ...[
            Text(
              'Data de nascimento',
              style: TextStyle(fontSize: 16, color: AppColors.depperPink),
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: _customInputDecoration(
                labelText: 'XX/XX/XXXX',
                suffixIcon: Icons.calendar_today_outlined,
              ),
              readOnly: true,
              onTap: () => _selectDate(context, _birthDateController),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecione sua data de nascimento.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Data da última menstruação (DUM)',
              style: TextStyle(fontSize: 16, color: AppColors.depperPink),
            ),
            TextFormField(
              controller: _lastMenstruationDateController,
              decoration: _customInputDecoration(
                labelText: 'XX/XX/XXXX',
                suffixIcon: Icons.calendar_today_outlined,
              ),
              readOnly: true,
              onTap: () =>
                  _selectDate(context, _lastMenstruationDateController),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecione a data da última menstruação.';
                }
                return null;
              },
            ),
          ] else if (_selectedRole == ProfileRole.professional) ...[
            Text(
              'Número do CRM/CPF',
              style: TextStyle(fontSize: 16, color: AppColors.depperPink),
            ),
            TextFormField(
              controller: _crmCpfController,
              decoration: _customInputDecoration(
                labelText: 'CRM/CPF',
                suffixIcon: Icons.credit_card_outlined,
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o CRM/CPF.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (bool? newValue) {
                  setState(() {
                    _termsAccepted = newValue!;
                  });
                },
                activeColor: AppColors.mediumPink,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Eu aceito os ',
                    style: TextStyle(fontSize: 14, color: AppColors.depperPink),
                    children: [
                      TextSpan(
                        text: 'Termos de Uso e Política de Privacidade',
                        style: TextStyle(
                          color: AppColors.mediumPink,
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

  // --- Função para Seleção de Data ---
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.mediumPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mediumPink,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      controller.text = formattedDate;
    }
  }

  // --- Layout da Tela Principal ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mom register'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        // Botão de voltar (visível apenas na segunda etapa)
        leading: _currentStep == 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Bloom',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 40,
                color: AppColors.mediumPink,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _currentStep == 0
                  ? _buildStep1Content()
                  : _buildStep2Content(),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _currentStep == 0 ? _nextStep : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mediumPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentStep == 0 ? 'Próximo' : 'Criar conta',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'OU',
              style: TextStyle(color: AppColors.depperPink, fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: Image.asset(
                  'assets/images/google_icon.png',
                  height: 24.0,
                  width: 24.0,
                ),
                label: Text(
                  'Criar conta com Google',
                  style: TextStyle(color: AppColors.depperPink, fontSize: 18),
                ),
                onPressed: () {
                  print('Login com Google!');
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  side: const BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
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
                  style: TextStyle(color: AppColors.depperPink, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Entrar',
                      style: TextStyle(
                        color: AppColors.mediumPink,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
