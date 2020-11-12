# SPDX-FileCopyrightText: 2020 Free Software Foundation Europe e.V. <https://fsfe.org>
# SPDX-License-Identifier: GPL-3.0-or-later

# Build an index for the search engine based on the article titles and tags

import glob
import json
from bs4 import BeautifulSoup
from subprocess import run, PIPE
import multiprocessing.dummy as mp
import logging
from os.path import abspath
from os import environ
import time

start_time = time.time()
print("* Creating search index")

# Read the log level from the LOGLEVEL environment variable and default to INFO
logging.basicConfig(
    format="*   %(message)s", level=environ.get("LOGLEVEL", "INFO").upper()
)
logger = logging.getLogger()

# fmt: off
# stopwords from nltk (inlined to avoid dependency)
# generated with
# from nltk.corpus import stopwords
#
# print(
#     {
#         w
#         for w in stopwords.words("dutch")
#         + stopwords.words("english")
#         + stopwords.words("french")
#         + stopwords.words("german")
#         + stopwords.words("italian")
#     }
# )
stopwords = {'facessimo', 'eûtes', 'starai', 'wasn', 'l', 'avuta', 'below', 'del', 'sullo', 'stesse', 'of', 'serez', 'hanno', 'ayant', 'faccio', 'itself', 'eus', 'manchen', 'yourselves', 'niet', 'niets', 'facesse', 'zonder', 'fummo', 'mein', 'soyez', 'facessi', 'aviez', 'facciamo', 'hin', 'want', 'avrò', 'been', 'tra', 'eu', 'tue', 'avez', 'wir', 'einig', 'quanto', 'zu', 'ait', 'each', 'mancher', 'deine', 'aurait', 'sono', 'sarai', 'wird', 'einiges', 'selbst', 'before', 'toi', 'einiger', 'eussiez', 'stava', 'wordt', 'étiez', 'few', 'pas', 'eurer', 'sarete', 'vostre', 'quella', 'le', 'delle', 'avesti', 'anders', 'after', 'den', 'hoe', 'étais', "it's", 'negl', 'd', 'wollte', "you're", 'faresti', 'jener', 'anderr', 'come', 'j', 'other', 'ins', 'si', 'iets', 'ihr', 'wieder', 'dall', 'einem', 'fussiez', "shan't", 'eues', 'starò', 'desselben', 'euch', 'deze', 'sa', 'anderem', 'aveste', 'uit', 'fossero', 'farebbero', 'dagli', 'aus', 'me', 'anderes', 'stavamo', 'meines', 'zelf', 'met', 'ad', 'à', 'eures', 'ha', 'fosti', 'damit', 'perché', 'vos', 'andern', 'fussions', 'meinem', 'sta', 'avessi', 'farai', 'dit', 'also', 'sua', 'dann', 'ihm', 'gli', 'questa', 'vostra', 'abbiano', 'through', 'you', 'mon', "needn't", 'könnte', 'eusse', 'étant', 'er', 'loro', 'suoi', 'mi', 'starebbe', 'con', 'fareste', 'sulla', 'werden', 'il', 'quanti', 'dalle', 'avresti', 'bin', 'quale', 'facciate', 'sur', 'mightn', 'nella', 'zou', 'geweest', 'bij', 'tegen', 'aurai', 'ihrer', 'than', 'stesti', 've', 'dies', 'now', 'nach', 'einige', 'siano', 'dort', 'dan', 'eines', 'viel', 'om', 'over', 'can', 'ours', 'weren', 'aies', 'eure', 'agli', 'more', 'hem', 'étantes', 'facevamo', 'has', 'sarei', 'couldn', 'sonst', 'stareste', 'eussions', 'serai', 'habe', 'fui', 'degl', 'ed', 'het', 'am', 'and', 'where', 'eens', 'him', "doesn't", 'au', 'ce', 'i', 'dalla', 'al', 'wie', 'fus', 'keinen', "hadn't", 'elle', 'seine', 'uns', 'per', 'facemmo', 'kein', 'serions', "you've", 'hij', 'your', 'altijd', 'doing', 'whom', 'll', 'sarà', 'siate', "didn't", 'toen', 'avevo', 'diesen', 'facesti', 'fecero', 'suo', 'but', 'dich', 'welches', "mustn't", 'von', 'sugl', 'ero', 'aura', 'avevi', 'sto', 'faccia', 'zo', 'staremmo', 'ses', 'einmal', 'die', 'what', 'unseres', 'saresti', 'most', 'einigem', "should've", 'because', 'aie', 'vor', 'facendo', 'manche', 'soit', 'la', 'op', 'ne', 'stettero', 'quelle', 'starà', 'tuo', 'lo', 'keine', 'hatte', 'stia', 'into', 'suis', 'était', 'my', 'nor', 'werde', 'avrai', 'stai', 'étés', 'm', 'jedem', 'avrete', 'unter', 'was', 'quanta', 'machen', 'a', 'nichts', 'don', 'e', 'eûmes', 'sia', 'staranno', 'era', 'son', 'faceste', 'moi', 'erano', 'being', 'vostri', 'mich', 'par', 'farò', "hasn't", 'eue', 'avute', 'yourself', 'avais', 'einen', 'fussent', 'any', 'ge', 'vous', 'furono', 'up', 'farei', 'seines', 'u', 'van', 'theirs', 'agl', 'dans', 'nostre', 'c', 'deines', 'keinem', 'then', 'uw', 'alle', 'sollte', 'queste', 'when', 're', 'avuto', 'fanno', 'shouldn', 'have', 'isn', 'bist', 'eravate', 'io', 'is', 'stiate', 'here', 'dell', 'nei', 'noi', 'auraient', 'werd', 'avec', 'votre', 'denselben', 'saremmo', 'nicht', 'himself', 'soyons', 'deinem', 'should', 'mijn', 'na', 'une', 'jenes', 'je', 'faremmo', 'just', "haven't", 'ayants', 'the', 'no', 'essendo', 'ayante', 'themselves', 'worden', 'stetti', 'wirst', 'voi', 'to', 'du', 'abbiate', 'not', 'facevi', 'some', 'avremmo', 'fece', 'voor', 'jede', 'there', 'hier', 'soll', 'does', 'sui', 'vostro', 'man', 'starebbero', 'daar', 'faremo', 'having', 'sul', 'ich', 'avevate', 'ai', 'siete', 'seriez', 'zich', 'he', 'hat', 'deinen', 'qui', 'contro', 'mia', 'hab', 'fût', 'tu', "couldn't", 'too', 'serait', 'durch', 'dir', 'stavo', 'be', 'with', 'étées', 'una', 'hinter', 'avrebbe', 'kon', 'stessero', 'door', 'wezen', 'seinen', 'eri', 'doen', 'aren', 'mais', 'ebbero', 'nos', 'dieser', 'ihn', 'nostri', 'feci', 'ons', 'sera', 'ayons', 'zur', 'miei', "aren't", 'allo', 'können', "shouldn't", 'avions', 'anderen', 'dov', 'farete', 'stessi', 'ebbe', 'diese', 'weiter', 'indem', 'aurons', 'aber', 'der', 'ist', 'nun', 'solchem', 'sehr', 'nostro', 'ma', 'fossimo', 'das', 'es', 'derer', 'avemmo', 'sarebbero', 'keiner', 'heeft', 'sull', 'auras', 'naar', 'avevano', 'êtes', 'chi', 'questi', 'alla', 'saranno', 'aurez', 'facevano', 'qu', 'faceva', 'als', 'wat', 'sugli', 'vi', 'ourselves', 'this', 'ob', 'facciano', 'meinen', 'aux', 'kunnen', 'onder', 'under', 'aurais', 'avessimo', 'had', 'how', "wouldn't", 'eurem', 'only', 'jedes', 'ander', 'kan', 'lui', 'est', 'fusses', 'on', 'ook', 'manches', 'down', 'que', 'again', 'zwar', 'ihre', 'ton', 'seinem', 'eine', 'seras', 'stando', 'herself', 'allem', 'bis', 'their', 'musste', 'meiner', 'della', 'sareste', 'stavi', 'they', 'very', 'welchen', 'tutto', 'that', 'needn', 'aurions', 'farebbe', 'auront', 'derselben', 'unseren', 'weil', 'facessero', 'eût', 'euer', "don't", 'or', 'gewesen', 'mustn', 'above', 'oder', 'avrebbero', 'dessen', 'col', 'questo', 'zijn', 'fûmes', 'reeds', 'further', 'jetzt', 'y', 'jeden', 'staresti', 'ben', 'fai', "won't", 'solchen', 'serais', 'sarebbe', 'jene', 'denn', 'sie', 'sois', 'solche', 'avranno', 'wouldn', 'hatten', 'fusse', 'serons', 'andere', 'sommes', 'avesse', 'fûtes', 'anderer', 'dai', 'ohne', 'aller', 'by', 'sulle', 'starei', 'these', 'avendo', 'same', 'fosse', 'steste', 'leur', 'sind', 'sarò', 'dus', 'we', 'shan', 'mio', 'about', 'étée', 'tes', 'ayez', 'saremo', 'abbia', 'cui', 'keines', 'if', 'fu', 'eusses', 'seraient', 'des', 'su', 'auf', 'starete', 'ik', 'euren', 'étants', 'soient', 'ho', 'own', 'facevo', 'solcher', 'aveva', 'faranno', 'ja', 'once', 'sue', 'which', 'da', 'avremo', 'war', 'pour', "mightn't", 'ces', 'wollen', 'è', 'sont', 'while', 'quante', 'tutti', 'stiano', 'why', 'stemmo', "wasn't", 'te', 'haven', 'muss', 'quelli', 'étaient', 'unser', 'until', 'avevamo', 'iemand', 'n', 'più', 'were', 'en', 'didn', "you'd", 'are', 'noch', 'ayantes', 'wenn', 'mie', 'hun', 'furent', 'und', 'nello', 'di', "isn't", 'ze', 'alles', 'derselbe', 'gegen', 'moet', 'zal', 'avaient', 'welche', 'both', 'between', 'stavate', 'ihnen', 'wo', 'so', 'dove', 'foste', 'wil', 'avait', 'ein', 'stessimo', 'yours', 'zij', 'tua', 'avrà', 'een', 'seront', 'mes', 'dello', 'étions', 'his', 'même', 'aient', 'auriez', 'über', 'nu', 'jenen', 'men', 'zwischen', 'them', 'für', 'nous', 'solches', 'im', 'nel', 'stanno', 'doesn', 'et', 'hadn', 'etwas', 'stette', 'mij', 'her', 'in', 'nur', 'eux', 'unserem', 'quello', 'stavano', 'kann', 'dallo', 'stiamo', 'été', 'um', 'eravamo', 'veel', 'de', 'einigen', 'eurent', 'nostra', 'hasn', 'during', 'avons', 'degli', 'all', 'warst', 'siamo', "you'll", 'allen', 'sein', 'ebbi', 'manchem', 'dat', 'un', 'diesem', 'nog', 'at', 'avuti', 'étante', 'che', 'dieses', 'sondern', 'facevate', 'ont', 'myself', 'hai', 'avete', 'dal', 'avrei', 'dieselbe', 'did', 'dieselben', 'ihrem', 'li', 'seiner', 'fut', 'tuoi', 'dasselbe', 'avessero', 'maar', 'our', 'for', 'welchem', 'ti', 'farà', 'eussent', 'dei', 'zum', 'haben', 'geen', 't', 'sich', 'auch', 'se', 'coi', 'hebben', 'staremo', 'heb', 'doch', 'dem', 'meine', 'as', 'do', 'haar', 'toch', 'vom', 'fossi', 'ci', 'ain', 'negli', 'avreste', 'jeder', 'won', 'dein', 'such', 'sei', 'its', 's', 'ou', 'daß', 'würde', 'she', 'anche', 'dazu', 'tot', 'nelle', 'waren', 'will', 'jenem', 'weg', "weren't", 'o', 'mir', 'deiner', 'würden', 'dagl', "she's", 'off', 'notre', 'demselben', 'ta', 'nell', 'out', 'omdat', 'from', 'unsere', 'während', 'ihres', 'mit', 'lei', 'eut', 'anderm', 'it', 'einer', 'ihren', 'non', 'meer', 'aan', 'abbiamo', 'welcher', 'who', 'an', 'hers', 'bei', 'those', "that'll", 'against', 'uno'}

# fmt: on
articles = []


def process_file(filename: str):
    logger.debug("Processing file {}".format(filename))
    with open(filename, "r", encoding=("utf-8")) as file_fh:
        file_parsed = BeautifulSoup(file_fh.read(), "lxml")
        tags = [
            tag.get("key")
            for tag in file_parsed.find_all("tag")
            if tag.get("key") != "front-page"
        ]
        articles.append(
            {
                "url": "https://fsfe.org/" + filename.replace("xhtml", "html"),
                "tags": " ".join(tags),
                "title": file_parsed.title.text,
                "teaser": " ".join(
                    w
                    for w in file_parsed.body.find("p").text.strip().split(" ")
                    if w.lower() not in stopwords
                )
                if file_parsed.body.find("p")
                else "",
                "type": "news" if filename.startswith("news/") else "page",
                # Get the date of the file if it's a news item
                "date": file_parsed.html.get("newsdate")
                if file_parsed.html.has_attr("newsdate")
                else None,
            }
        )


n_processes = 4
p = mp.Pool(n_processes)
logger.info("Spawning {} processes".format(n_processes))
files = list(glob.glob("**/*.xhtml", recursive=True))
logger.info("Indexing {} files".format(len((files))))
p.map(process_file, files)
p.close()
p.join()

end_time = time.time()
logger.info("Indexation done in {} seconds!".format(int(end_time - start_time)))

index_path = "search/index.js"
# Make a JS file that can be directly loaded
# TODO find an easy way to load local JSON file from JavaScript
with open(index_path, "w", encoding="utf-8") as fh:
    fh.write("var pages = " + json.dumps(articles, ensure_ascii=False))

logger.info("Written index to {}".format(abspath(index_path)))
