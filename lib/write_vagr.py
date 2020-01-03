import json, os, sys
vagr_json = {'machine':'', 'ports':[]}
if sys.argv[1] == '-e':
	if os.path.exists('Vagr.json'):
		json_file = open('Vagr.json', 'r')
		vagr_json = json.load(json_file)

commandline_args = []
for i in range(1, len(sys.argv)):
	if '-' in sys.argv[i]:
		commandline_args.append((sys.argv[i], i))

for arg in commandline_args:
	if arg[0] == '-m':
		vagr_json['machine'] = sys.argv[(arg[1] + 1)]
	elif arg[0] == '-p':
		contains = False
		port_info = sys.argv[(arg[1] + 1)].rstrip(' ').split()
		for port in vagr_json['ports']:
			if port_info[0] == port[0]:
				contains = True
				print('Port with name', port_info[0], 'already exists.')
				break
		if not contains:
			for i in range(len(port_info)):
				if port_info[i] == '_':
					port_info[i] = ''
		print('Adding', port_info)
		vagr_json['ports'].append(port_info)

with open('Vagr.json', 'w') as (outfile):
	json.dump(vagr_json, outfile)