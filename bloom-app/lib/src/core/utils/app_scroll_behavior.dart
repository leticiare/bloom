import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Uma classe de comportamento de rolagem customizada que permite
/// o gesto de arrastar com o mouse em todo o aplicativo.
///
/// Por padrão, o Flutter em desktop/web não permite rolar listas
/// (ListView, PageView) arrastando com o mouse. Esta classe reativa essa funcionalidade.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind
        .mouse, // Adiciona o mouse à lista de dispositivos de arrastar
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}
