#!/usr/bin/env python

# script that fetches all the translations from the crowdin server
# and updates our local language files [arb], f-droid metadata files [fastlane] and generates string for publishing

# requirements:
# python3
# pip3 install crowdin-api-client

# example usage [tested & built for Linux]:
# env TOKEN=<token> ./scripts/texts.py
import shutil
import time
from io import BytesIO
from urllib.request import urlopen
from zipfile import ZipFile

from crowdin_api import CrowdinClient
import os


# downloads the latest translations from crowdin
def download_translations(dir):
    class FirstCrowdinClient(CrowdinClient):
        TOKEN = os.environ.get('TOKEN')

    print('Downloading translations from Crowdin...')
    client = FirstCrowdinClient()

    build = client.translations.build_project_translation(458738, {})
    while True:
        status = client.translations.check_project_build_status(458738, build['data']['id'])
        if status['data']['status'] == 'finished':
            break
        else:
            print('Waiting for build to finish')
            time.sleep(5)

    print('Built successfully')

    download = client.translations.download_project_translations(458738, build['data']['id'])

    url = download['data']['url']
    http_response = urlopen(url)
    zipfile = ZipFile(BytesIO(http_response.read()))
    zipfile.extractall(path=dir)

    print('Downloaded translations')


# puts downloaded translations into the app's locales folder
def populate_arb():
    print('Removing old translations...')
    # remove old translations
    for (dirpath, dirnames, filenames) in os.walk('../locales/'):
        for filename in filenames:
            if filename.endswith('.arb') and filename != 'app_en.arb':
                os.remove(os.path.join(dirpath, filename))
        break

    locales = []
    for (dirpath, dirnames, filenames) in os.walk(DIR):
        locales.extend(dirnames)
        break

    files = []
    for locale in locales:
        for (dirpath, dirnames, filenames) in os.walk(DIR + locale):
            for filename in filenames:
                if filename.endswith('.arb'):
                    files.extend([DIR + locale + '/' + filename])

    for file in files:
        # remove @@locale and write files
        contents = open(file, 'r').read()
        name = file.split('/')[-2]
        name = name.replace('-', '_')
        contents = contents.replace('"@@locale": "en",', '')
        # contents = contents.replace('"@@locale": "en",', '"@@locale": "'+name+'",')

        with open(file, 'w') as f:
            f.write(contents)

        shutil.copy(file, '../locales/app_'+name+'.arb')

        if '_' in name:
            new_name = name.split('_')[0]
            open('../locales/app_'+new_name+'.arb', 'w').write('{}')

    print('Populating new translations...')
    print(files)


DIR = "translations/"
download_translations(DIR)
populate_arb()

shutil.rmtree(DIR)
