#!/usr/bin/env python

# TODO rewrite as a dart package
# script that fetches all the translations from the crowdin server
# and updates our local language files [arb], f-droid metadata files [fastlane] and generates string for publishing

# requirements:
# python3
# pip3 install crowdin-api-client

# example usage [tested & built for Linux]:
# env TOKEN=<crowdin token> ./scripts/texts.py
import json
import shutil
import time
from io import BytesIO
from urllib.request import urlopen
from zipfile import ZipFile

from crowdin_api import CrowdinClient
import os


class FirstCrowdinClient(CrowdinClient):
    TOKEN = os.environ.get('TOKEN')


CROWDIN_PROJECT = 458738


# downloads the latest translations from crowdin
def download_translations(dir):
    print('Downloading translations from Crowdin...')
    client = FirstCrowdinClient()

    build = client.translations.build_project_translation(CROWDIN_PROJECT, {})
    while True:
        status = client.translations.check_project_build_status(CROWDIN_PROJECT, build['data']['id'])
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
        print('name: ' + file)
        # translations/pt-BR/pt_BR.arb
        # translations/fr/fr_FR.arb

        name = file.split('/')[-2]
        name = name.replace('-', '_')
        contents = contents.replace('"@@locale": "en",', '')
        # contents = contents.replace('"@@locale": "en",', '"@@locale": "'+name+'",')

        with open(file, 'w') as f:
            f.write(contents)

        shutil.copy(file, '../locales/app_' + name + '.arb')

        if '_' in name:
            new_name = name.split('_')[0]
            open('../locales/app_' + new_name + '.arb', 'w').write('{}')

    print('Populating new translations...')
    print(files)


# do not run this method many times, due to Github's API rate limits
# returns all github contributors
def _fetch_github_contributors():
    # fetch all github contributors
    contributors = []
    # todo pagination
    api = "https://api.github.com/repos/marchellodev/sharik/contributors?per_page=100"
    response = urlopen(api)
    data = response.read()
    data = data.decode('utf-8')
    data = json.loads(data)
    contributors.extend(data)

    list = []

    for c in contributors:
        login = c['login']

        api = c['url']
        response = urlopen(api)
        data = response.read()
        data = data.decode('utf-8')
        data = json.loads(data)

        name = data['name']
        if name is None:
            name = login

        list.extend([{"link": "https://github.com/" + login, "name": name, "type": "development"}])
        print(name + " " + login)

        time.sleep(1)

    return list

    # TODO finish


def _fetch_crowdin_contributors():
    client = FirstCrowdinClient()
    # todo pagination
    members = client.users.list_project_members(CROWDIN_PROJECT, limit=500)['data']
    result = []
    for m in members:
        login = m["data"]["username"]
        name = m["data"]["fullName"]
        if name is None:
            name = login

        result.extend([{"link": "https://crowdin.com/profile/" + login, "name": name, "type": "translation"}])
    return result


def write_contributors():
    github = _fetch_github_contributors()
    crowdin = _fetch_crowdin_contributors()
    result = github

    for c in crowdin:
        found = False
        for r in result:
            if r['name'] == c['name'] or r['link'].split("/")[-1] == c['link'].split("/")[-1]:
                r['type'] = 'both'
                found = True
                break
        if not found:
            result.extend([c])

    print(result)
    json_object = json.dumps(result, indent=2)
    with open('../assets/contributors.json', 'w') as outfile:
        outfile.write(json_object)


def update_locales():
    print("TODO")


def update_fastlane():
    print("TODO")


def save_metadata_for_marketplaces():
    print("TODO")


# todo make sure the directory is scripts/
DIR = "translations/"
download_translations(DIR)
populate_arb()
# write_contributors()
# shutil.rmtree(DIR)
