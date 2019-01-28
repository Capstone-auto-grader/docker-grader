import xml.etree.ElementTree as et
from sys import argv

etree = et.parse('.project')
etree.find('.//name').text = argv[1]
etree.write('.project')
