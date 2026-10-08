# GitHub Safari Fix (iOS 16, Dopamine Rootless)

Твик для Safari на iOS 16 (Dopamine Rootless), исправляющий сдвиг верстки GitHub в левый бок и горизонтальное переполнение экрана.

---

## 🛠 Содержимое проекта
* `Tweak.x` — логика хука `WKWebView` в MobileSafari: нормализация `viewport` и инъекция CSS-правил с защитой от сдвига.
* `GitHubFix.plist` — фильтр для инъекции в процесс `com.apple.mobilesafari`.
* `Makefile` — скрипт сборки под `arm64/arm64e` с параметром `THEOS_PACKAGE_SCHEME = rootless`.
* `control` — файл пакета Debian (`com.local.githubfix`).
* `.github/workflows/build.yml` — готовый GitHub Actions workflow для автоматической сборки `.deb` в облаке без локального Theos.

---

## 🚀 Способы сборки

### Вариант 1. Сборка через GitHub Actions (Самый простой — без настройки Theos на ПК)
1. Создайте репозиторий на GitHub и загрузите эту папку с кодом.
2. Перейдите во вкладку **Actions** в вашем репозитории.
3. Запустите workflow **Build Rootless Tweak** (или он соберется автоматически при пуше).
4. В разделе **Artifacts** скачайте готовый `GitHubFix-rootless-deb.zip`, внутри которого будет готовый `.deb` пакет.

---

### Вариант 2. Сборка на компьютере через Theos

#### На macOS / Linux:
1. Установите Theos:
   ```bash
   git clone --recursive https://github.com/theos/theos.git ~/theos
   ```
2. Скачайте iOS SDK (например, 16.5):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/theos/sdks/master/iPhoneOS16.5.sdk.tar.xz | tar -xJ -C ~/theos/sdks
   ```
3. Соберите пакет:
   ```bash
   cd /home/a/code/github-fix
   export THEOS=~/theos
   make package THEOS_PACKAGE_SCHEME=rootless FINALPACKAGE=1
   ```
4. Готовый пакет появится в `packages/com.local.githubfix_1.0.0_iphoneos-arm64.deb`.

---

### Вариант 3. Сборка прямо на iPhone (через NewTerm / SSH)
1. В **Sileo** установите:
   * `NewTerm 3`
   * `Theos Dependencies` / `clang` / `make` / `git`
2. Скопируйте папку проекта на телефон.
3. В терминале на телефоне выполните:
   ```bash
   make package THEOS_PACKAGE_SCHEME=rootless FINALPACKAGE=1
   ```

---

## 📲 Установка пакета на телефон
1. Отправьте файл `.deb` на iPhone (через AirDrop, Telegram «Избранное», локальный сервер или Filza).
2. Нажмите «Поделиться» → открыть в **Sileo** (или откройте через **Filza**).
3. Нажмите **«Установить»**.
4. Полностью перезапустите Safari (смахните из панели многозадачности).
