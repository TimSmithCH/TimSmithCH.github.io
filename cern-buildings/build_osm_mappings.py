#! /usr/bin/python
import json
import re

# Read in the output of the OSM bounding box search for ways in the vicinty of CERN
json_file='buildings_in_CERN_bb.json'
json_data=open(json_file)
data = json.load(json_data)
json_data.close()

building_array = []
# Loop over each building dict in the elements array
for building in data['elements']:
  if 'name' in building['tags']:
    # Name field is usually simply the building number, but sometimes it also contains a descrition
    build = building['tags']['name'].encode('utf-8').strip()
    int_list = [int(s) for s in re.findall(r'\d+', build)]
    # If at least one number was found, identify the maximum one (nicknames seem to be lower!)
    if int_list:
      building_array.append({"osm_id": building['id'], "building": max(int_list)})

with open('cern_osm_mappings.json', 'w') as outfile:
    json.dump({'data': sorted(building_array, key=lambda k: k['building'])}, outfile)
