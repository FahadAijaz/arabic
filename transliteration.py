
# %%
import os
import pandas as p
import itertools as itt
import numpy as np
import glob as g
import xml.etree.cElementTree as et
from cltk.stop.arabic.stopword_filter import stopwords_filter as ar_stop_filter
from cltk.phonology.arabic.romanization import transliterate


def reverse_transliterate(s: str):
    if not s:
        return None
    mode = 'buckwalter'
    reverse = False
    ignore = ''
    return transliterate(mode, s, ignore, reverse)


# %%
path = "/home/knight/repos/texts/Arabic/Lane/opensource/*"
files = g.glob(path)
curr_abs = files[4]
print(curr_abs)
parsedXML = et.parse(curr_abs)
r = parsedXML.getroot()


# %%


bd = r[1].getiterator()
all_entries = {}
roots = []
for b in bd:
    root_english = ""
    root = ""
    if b.find("div2"):
        root_node = b.find("div2")
        root_english = root_node.get("n")
        roots.append(reverse_transliterate(root_english))
    if b.find("entryFree"):
        b.findall("entryFree")
        ef = b.find("entryFree")
        wrd = (ef.get('key'), root)
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
        all_entries[wrd] = c_def

print(len(roots))
print(len(all_entries))

# %%

len(all_entries)
item_list = list(all_entries.items())
print(item_list[2])


# %%
mode = 'buckwalter'
reverse = False
ignore = ''
ar_defs = []
for k in all_entries.keys():
    print(k)
    ar_defs.append(reverse_transliterate(k))

ar_defs[0:15]

# %%

bd = r[1].getiterator()
roots = []
entries = []
for b in bd:
    div2s = b.findall("div2")
    for d in div2s:
        roots.append(d.get("n"))
        efs = d.findall("entryFree")
        for e in efs:
            entries.append(e.get("key"))

print(len(entries))
print(len(roots))


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
par_dir = "./data/"
lex_df.to_feather(fname=par_dir + curr_file_name)
