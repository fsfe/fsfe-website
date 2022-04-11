import sys
import xml.etree.ElementTree as ET

# Load root of XML file
root = ET.parse(sys.argv[1]).getroot()

# Print all XML elements, one per row
elementlist = '\n'.join([elem.tag for elem in root.iter()])

print(elementlist)
