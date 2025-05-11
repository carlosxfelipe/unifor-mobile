import 'package:universal_html/html.dart' as html;

/*
  Atualiza dinamicamente a tag <meta name="theme-color" /> no HTML
  para alterar a cor da barra do navegador (em Flutter Web).

  Exemplo de saída esperada no HTML:
  <meta name="theme-color" content="#85c4f6" />

  Isso é útil para adaptar a aparência da interface do navegador
  conforme o tema ou a cor de fundo ativa no app.
*/

void updateThemeColor(String colorHex) {
  final meta = html.document.querySelector('meta[name="theme-color"]');
  if (meta != null) {
    meta.setAttribute('content', colorHex);
  }
}
