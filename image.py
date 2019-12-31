from PIL import Image
import sys
import re

import pyocr
import pyocr.builders
import download


download.main()

print(download.namedata)
tools = pyocr.get_available_tools()

if len(tools) == 0:
 print("No OCR tool found")
 sys.exit(1)
# The tools are returned in the recommended order of usage
tool = tools[0]
print("Will use tool '%s'" % (tool.get_name()))
# Ex: Will use tool 'libtesseract'

langs = tool.get_available_languages()
print("Available languages: %s" % ", ".join(langs))
lang = langs[0]
print("Will use lang '%s'" % (langs))
for img in download.namedata:
    image_name = Image.open(img)
    image_box = image_name.crop((698,377,979,461)) #カロリーの部分を囲む
    image_box1 = image_name.crop((679,269,971,342)) #活動時間の部分を囲む

    txt = tool.image_to_string(
    image_box,
    lang=lang,
    builder=pyocr.builders.TextBuilder(tesseract_layout=6)
    )

    txt2 = tool.image_to_string(
    image_box1,
    lang=lang,
    builder=pyocr.builders.TextBuilder(tesseract_layout=6)
    )
# txt is a Python string
    retime = txt2.replace(' ','')
    if len(retime) == 4:
        if '4' in retime[1]:
            re = list(retime)
            re[1] = '分'
            retime = ''.join(re)
        retime = retime.replace(retime[3],'秒').replace('/','7')

    elif len(retime) == 5:
        if '4' in retime[2]:
            re = list(retime)
            re[2] = '分'
            retime = ''.join(re)
        retime = retime.replace(retime[4],'秒').replace('/','7')
    elif len(retime) == 6:
        if '4' in retime[2]:
            re = list(retime)
            re[2] = '分'
            retime = ''.join(re)
        retime = retime.replace('»','秒').replace('/','7')

    retext = txt.replace(' ','').replace('i','1').replace(']','1')
    print("消費カロリー= " + retext)
    print("運動時間= " + retime)
