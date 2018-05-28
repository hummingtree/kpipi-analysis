#!/usr/bin/python

import xml.etree
import xml.etree.ElementTree as et
import copy

tree = et.parse('fit_ps.xml')
root = tree.getroot()

c_count = 0
p_count = 0
params_dict = {}
for correlator in root.findall('correlator'):
    p_count = 0
    pg = correlator.find('parameter_guesses');
    print "correlator #%d:" %c_count
    for child in pg:
        print child.get('name')
        if child.get('name') in params_dict: 
            params_dict[child.get('name')].append([c_count, p_count])
        else: 
            params_dict[child.get('name')] = [[c_count, p_count]]
        p_count += 1
    c_count += 1

pb_ex_str = """
    <param_bind>
      <corr_1>0</corr_1>
      <param_1>0</param_1>
      <corr_2>1</corr_2>
      <param_2>0</param_2>
    </param_bind>
"""

pb_ex = et.fromstring(pb_ex_str)

# remove all constrains, if any.
constraints = root.find('Constraints')
for pb in constraints.findall('param_bind'):
    constraints.remove(pb)

for key in params_dict:
    if len(params_dict[key]) == 1: continue
    for i in range(1, len(params_dict[key])):
        pb_ex.find('corr_1').text = str(params_dict[key][0][0])
        pb_ex.find('param_1').text = str(params_dict[key][0][1])
        pb_ex.find('corr_2').text = str(params_dict[key][i][0])
        pb_ex.find('param_2').text = str(params_dict[key][i][1])
        pb_ex_cp = copy.deepcopy(pb_ex)
        root.find('Constraints').append(pb_ex_cp)

tree.write('fit_ps.xml', xml_declaration=True, encoding="us-ascii", method="xml")

# import xml.dom.minidom

# print xml.etree.ElementTree.tostring(root)

# xmldom = xml.dom.minidom.parseString(et.tostring(root))
# pretty_xml_as_string = xmldom.toprettyxml()
# print pretty_xml_as_string
