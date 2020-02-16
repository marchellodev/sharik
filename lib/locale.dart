class L {
  static String get(String key, String locale) {
    const dict = {
      'CONNECT': {'en': 'CONNECT', 'ua': 'З\'ЄДНАЙ'},
      'connect_same': {
        'en':
            'Connect devices to the same network - use Wi-Fi or Mobile Hotspot',
        'ua':
            'Під\'єднайте девайси до однієї мережі - використовуйте Wi-Fi або Мобільну Точку Доступу'
      },
      'SEND': {'en': 'SEND', 'ua': 'ВІДПРАВ'},
      'select_any': {
        'en': 'Select any file you like',
        'ua': 'Виберіть будь-який файл'
      },
      'RECEIVE': {'en': 'RECEIVE', 'ua': 'ОТРИМАЙ'},
      'open_link': {
        'en': 'Open given link on another device in any browser',
        'ua':
            'Відкрийте отримане посилання на іншому девайсі, використовуючи будь-який веб-переглядач'
      },
      'DONE': {'en': 'DONE', 'ua': 'ДАЛІ'},
      'NEXT': {'en': 'NEXT', 'ua': 'ДАЛІ'},
      'loading...': {'en': 'loading...', 'ua': 'завантаження...'},
      'Mobile Hotspot': {
        'en': 'Mobile Hotspot',
        'ua': 'Мобільна Точка Доступу'
      },
      'Connect to': {'en': 'Connect to', 'ua': 'Під\'єднайтесь до'},
      'or enable': {'en': 'or enable', 'ua': 'або увімкніть'},
      'enable Mobile Hotspot': {
        'en': 'Mobile Hotspot',
        'ua': 'Мобільну Точку Доступу'
      },
      'Not connected': {'en': 'Not connected', 'ua': 'З\'єднання немає'},
      'Now open': {
        'en': 'Now open this link\nin any browser',
        'ua': 'Тепер відкрийте це посилання\nу будь-якому браузері'
      },
      'The recipient': {
        'en': 'The recipient needs to be connected\nto the same network',
        'ua': 'Отримувач має бути підключений\nдо тієї ж самої мережі'
      },
      'Select file': {'en': 'Select file', 'ua': 'Вибрати файл'},
      'Latest': {'en': 'Latest', 'ua': 'Останні'},
    };
    return dict[key][locale];
  }
}
