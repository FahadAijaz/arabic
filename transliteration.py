
# %%
import os
import pandas as p
import itertools as itt
import numpy as np
import glob as g
import xml.etree.cElementTree as et
from cltk.stop.arabic.stopword_filter import stopwords_filter as ar_stop_filter
from cltk.phonology.arabic.romanization import transliterate
import sys


def reverse_transliterate(s: str):
    if not s:
        return None
    mode = 'buckwalter'
    reverse = False
    ignore = ''
    return transliterate(mode, s, ignore, reverse)


# %%
curr_input = int(sys.argv[1])
path = "/home/knight/repos/texts/Arabic/Lane/opensource/*"
files = g.glob(path)
total_files = len(files)
if not (curr_input >= 0 and curr_input < total_files):
    exit
curr_abs = files[curr_input]
print(curr_abs)
parsedXML = et.parse(curr_abs)
r = parsedXML.getroot()


# %%


# assume in our case that it
# r1 is the parameter


bd = r[1].getiterator()
all_entries = {}
roots = []
for i, b in enumerate(bd):
    root_english = ""

    root_paths = b.findall("div2")
    for root_path in root_paths:
        curr_root = root_path.get("n")
        efs = root_path.findall("entryFree")
        for ef in efs:
            wrd = ef.get('key')
            childs = ef.getchildren()
            c_def = ""
            c_data = []
            for c in childs:
                if c.tag == "hi":
                    c_data.append(c.text)
                # c_data.append(c.find("hi"))
                if c.tag == "foreign":
                    arabic_string = reverse_transliterate(c.text)
                    c_data.append(arabic_string)
                c_def = ' '.join(c_data)
            all_entries[(curr_root, wrd)] = c_def

all_entries_with_ar = []
for k, v in all_entries.items():
    ar_root = reverse_transliterate(k[0])
    ar_word = reverse_transliterate(k[1])
    all_entries_with_ar.append([k[0], k[1], ar_root, ar_word, v])


transposed = np.array(all_entries_with_ar)

lex_df = p.DataFrame(transposed, columns=[
                     "EnglishRoot", "EnglishWord", "ArabicRoot", "ArabicWord", "Definition"])
curr_file_wo_ext = os.path.basename(curr_abs)
curr_file_name = os.path.splitext(curr_file_wo_ext)[0] + ".feather"
par_dir = "./data/lexicon/"
lex_df.to_feather(fname=par_dir + curr_file_name)
