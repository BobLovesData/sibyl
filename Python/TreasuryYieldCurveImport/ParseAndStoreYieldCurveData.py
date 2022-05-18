import lxml.etree
import pandas as pd

nsmap = {
  'm': 'http://schemas.microsoft.com/ado/2007/08/dataservices/metadata',
  'd': 'http://schemas.microsoft.com/ado/2007/08/dataservices'
}
m_null = ('{%s}null' % nsmap['m'])


def xml2df(xml_data):
    root = lxml.etree.parse(xml_data)
    all_records = []
    for properties in root.xpath('//m:properties', namespaces=nsmap):
        record = {}
        for child in properties.getchildren():
            tag = child.tag.split('}', 1)[-1]  # split the namespace off the tag
            if child.attrib.get(m_null):
                value = None
            else:
                value = child.text
            record[tag] = value
        all_records.append(record)
    return pd.DataFrame(all_records)


#xml2df('YCDPart.xml').to_csv('sample_xml_data.csv')
xml2df('YieldCurveData.xml')