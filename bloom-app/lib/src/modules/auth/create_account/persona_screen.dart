import 'package:flutter/material.dart';
import 'package:app/src/modules/auth/create_account/new_doctor_screen.dart';
import 'package:app/src/modules/auth/create_account/new_pregnant_screen.dart';

// --- CONSTANTES DE CORES ---
// É uma boa prática definir cores usadas com frequência como constantes
// para garantir consistência e facilitar futuras alterações.
const Color K_MAIN_PINK = Color(0xFFE91E63);
const Color K_LIGHT_GRAY = Color(0xFFF2F2F2);
const Color K_DARK_TEXT = Color(0xFF333333);

// --- ESTRUTURA DE DADOS (ENUM) ---
// Um Enum (enumeração) é usado para definir um conjunto de constantes nomeadas.
// Aqui, ele representa os possíveis perfis de usuário de forma clara e segura.
enum Persona { pregnant, doctor, none }

// --- TELA DE SELEÇÃO DE PERFIL ---
class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  // Variável de estado para armazenar qual persona está selecionada.
  // Começa como 'none' para indicar que nenhuma foi escolhida ainda.
  Persona _selectedPersona = Persona.none;

  // --- MÉTODOS DE NAVEGAÇÃO ---
  // Função que direciona o usuário para a tela de cadastro correta
  // com base na persona que foi selecionada.
  void _navigateToNextScreen() {
    if (_selectedPersona == Persona.pregnant) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const NewPregnantScreen()),
      );
    } else if (_selectedPersona == Persona.doctor) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const NewDoctorScreen()));
    }
  }

  // --- CONSTRUÇÃO DA INTERFACE (UI) ---
  @override
  Widget build(BuildContext context) {
    // Variável booleana para verificar se uma persona foi selecionada.
    // Usada para habilitar/desabilitar o botão "Continuar".
    final bool isPersonaSelected = _selectedPersona != Persona.none;

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar com um botão de "voltar" para uma navegação intuitiva.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // A estrutura principal é uma Coluna.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- SEÇÃO DO TÍTULO ---
              const Text(
                'Queremos te conhecer melhor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: K_DARK_TEXT,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selecione o perfil que mais se encaixa com você.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- SEÇÃO DAS OPÇÕES DE PERFIL ---
              // Chamamos nosso widget auxiliar para criar os cards.
              _buildPersonaCard(
                persona: Persona.pregnant,
                title: 'Sou Gestante',
                imagePath: 'assets/images/pregnant.png',
              ),
              const SizedBox(height: 20),
              _buildPersonaCard(
                persona: Persona.doctor,
                title: 'Sou Médico(a)',
                imagePath: 'assets/images/doctor.png',
              ),

              // O widget Spacer ocupa todo o espaço flexível disponível,
              // empurrando o botão para a parte inferior da tela.
              const Spacer(),

              // --- SEÇÃO DO BOTÃO PRINCIPAL ---
              ElevatedButton(
                // A propriedade `onPressed` recebe `null` se nenhuma persona for selecionada,
                // o que desabilita o botão automaticamente.
                onPressed: isPersonaSelected ? _navigateToNextScreen : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: K_MAIN_PINK,
                  disabledBackgroundColor: Colors.grey.shade300,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR (COMPONENTE) ---
  // Criar widgets auxiliares como este ajuda a evitar repetição de código
  // e torna o método `build` principal mais legível.
  Widget _buildPersonaCard({
    required Persona persona,
    required String title,
    required String imagePath,
  }) {
    // Verifica se este card específico é o que está selecionado no momento.
    final bool isSelected = _selectedPersona == persona;

    // GestureDetector permite que qualquer widget se torne clicável.
    return GestureDetector(
      onTap: () {
        // Ao clicar, atualizamos o estado para refletir a nova seleção.
        setState(() {
          _selectedPersona = persona;
        });
      },
      // AnimatedContainer permite uma transição suave de estilo (cor, borda, etc.).
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? K_MAIN_PINK.withOpacity(0.1) : K_LIGHT_GRAY,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            // A borda muda de cor para dar um feedback visual claro da seleção.
            color: isSelected ? K_MAIN_PINK : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.contain),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? K_MAIN_PINK : K_DARK_TEXT,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
