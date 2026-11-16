
#!/bin/bash
set -e

echo "Instalando Flutter..."

git clone --depth 1 -b stable \
  https://github.com/flutter/flutter.git \
  /tmp/flutter-sdk

export PATH="/tmp/flutter-sdk/bin:$PATH"

flutter --version
flutter config --enable-web

echo "Instalando dependências..."
flutter pub get

echo "Compilando Flutter Web..."
flutter build web --release

echo "Build concluído!"
