import 'models/locale.dart';

class L {
  static String get(String key, LocaleModel localeModel) {
    var locale;
    //todo: remove switch, use extensions/helpers
    switch (localeModel) {
      case LocaleModel.en:
        locale = 'en';
        break;
      case LocaleModel.ru:
        locale = 'ru';
        break;
      case LocaleModel.ua:
        locale = 'ua';
        break;
    }

    const dict = {
      'CONNECT': {'en': 'CONNECT', 'ua': 'З\'ЄДНАЙ', 'ru': 'СОЕДИНИ'},
      'connect_same': {
        'en':
            'Connect devices to the same network - use Wi-Fi or Mobile Hotspot',
        'ua':
            'Під\'єднайте девайси до однієї мережі - використовуйте Wi-Fi або Мобільну Точку Доступу',
        'ru':
            'Подсоедините устройства к одной сети - используйте Wi-FI или мобильную точку доступа'
      },
      'SEND': {'en': 'SEND', 'ua': 'ВІДПРАВ', 'ru': 'ОТПРАВЬ'},
      'select_any': {
        'en': 'Select any file you like',
        'ua': 'Виберіть будь-який файл',
        'ru': 'Выбери любой файл'
      },
      'RECEIVE': {'en': 'RECEIVE', 'ua': 'ОТРИМАЙ', 'ru': 'ПОЛУЧИ'},
      'open_link': {
        'en': 'Open given link on another device in any browser',
        'ua':
            'Відкрийте отримане посилання на іншому девайсі, використовуючи будь-який веб-переглядач',
        'ru':
            'Откройте полученную ссылку на другом устройстве, используя любой браузер'
      },
      'DONE': {'en': 'DONE', 'ua': 'ГОТОВО', 'ru': 'ГОТОВО'},
      'NEXT': {'en': 'NEXT', 'ua': 'ДАЛІ', 'ru': 'ДАЛЬШЕ'},
      'loading...': {
        'en': 'loading...',
        'ua': 'завантаження...',
        'ru': 'загрузка...'
      },
      'Mobile Hotspot': {
        'en': 'Mobile Hotspot',
        'ua': 'Мобільна Точка Доступу',
        'ru': 'Мобильная Точка Доступа'
      },
      'Connect to': {
        'en': 'Connect to',
        'ua': 'Під\'єднайтесь до',
        'ru': 'Подсоединитесь к'
      },
      'or enable': {
        'en': 'or set up a',
        'ua': 'або увімкніть',
        'ru': 'или включите'
      },
      'enable Mobile Hotspot': {
        'en': 'Mobile Hotspot',
        'ua': 'Мобільну Точку Доступу',
        'ru': 'Мобильную Точку Доступа'
      },
      'Not connected': {'en': 'Not connected', 'ua': 'З\'єднання немає'},
      'Now open': {
        'en': 'Now open this link\nin any browser',
        'ua': 'Тепер відкрийте це посилання\nу будь-якому браузері',
        'ru': 'Теперь откройте эту ссылку\nв любом браузере'
      },
      'The recipient': {
        'en': 'The recipient needs to be connected\nto the same network',
        'ua': 'Отримувач має бути підключений\nдо тієї ж самої мережі',
        'ru': 'Получатель должен быть подключен\nк той же сети'
      },
      'Select file': {
        'en': 'Select file',
        'ua': 'Вибрати файл',
        'ru': 'Выбрать файл'
      },
      'Latest': {'en': 'Latest', 'ua': 'Останні', 'ru': 'Последние'},
      'undefined': {
        'en': 'Undefined',
        'ua': 'Не визначено',
        'ru': 'Не определено'
      },
      'EVERYWHERE': {'en': 'EVERYWHERE', 'ua': 'БУДЬ-ДЕ', 'ru': 'ВЕЗДЕ'},
      'sharik_is_available': {
        'en':
            'Sharik is available for Android, Windows, MacOS and Linux!\nClick here to learn more',
        'ua':
            'Sharik доступний для Android, Windows, MacOS та Linux!\nНатисніть тут щоб дізнатися більше',
        'ru':
            'Sharik доступный для Android, Windows, MacOS и Linux!\nНажмите здесь чтобы узнать больше'
      },
      'copied': {
        'en': 'Copied to Clipboard',
        'ua': 'Скопійовано до Буферу обміну',
        'ru': 'Скопировано в Буфер обмена'
      },
      'Type text': {
        'en': 'Type some text',
        'ua': 'Введіть текст',
        'ru': 'Введите текст'
      },
      'Close': {'en': 'Close', 'ua': 'Закрити', 'ru': 'Закрыть'},
      'Send': {'en': 'Send', 'ua': 'Відправити', 'ru': 'Отправить'},
      'Text': {'en': 'Text', 'ua': 'Текст', 'ru': 'Текст'},
      'App': {'en': 'App', 'ua': 'Програма', 'ru': 'Приложение'},
      'Hide system apps': {
        'en': 'Hide system apps',
        'ua': 'Приховати системні додатки',
        'ru': 'Спрятать системные приложения',
      },
      'Hide non-launchable apps': {
        'en': 'Hide non-launchable apps',
        'ua': 'Приховати службові додатки',
        'ru': 'Спрятать служебные приложения',
      },
      'Search': {
        'en': 'Search',
        'ua': 'Пошук',
        'ru': 'Поиск',
      },
    };
    return dict[key][locale];
  }
}
