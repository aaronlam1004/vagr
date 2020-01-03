import json, os, subprocess, sys
if os.path.exists('Vagr.json'):
    json_file = open('Vagr.json', 'r')
    vagr_json = json.load(json_file)
    cwd = os.getcwd()
    os.chdir('C:\\Program Files\\Oracle\\VirtualBox\\')
    if sys.argv[1] == '--start':
        subprocess.run(['VBoxManage', 'startvm', vagr_json['machine'], '--type', 'headless'])
    elif sys.argv[1] == '--pause':
        subprocess.run(['VBoxManage', 'controlvm', vagr_json['machine'], 'pause'])
    elif sys.argv[1] == '--resume':
        subprocess.run(['VBoxManage', 'controlvm', vagr_json['machine'], 'resume'])
    elif sys.argv[1] == '--stop':
        subprocess.run(['VBoxManage', 'controlvm', vagr_json['machine'], 'poweroff'])
    elif sys.argv[1] == '--reload':
        subprocess.run(['VBoxManage', 'controlvm', vagr_json['machine'], 'reset'])
    elif sys.argv[1] == '--remove':
        subprocess.run(['VBoxManage', 'unregistervm', vagr_json['machine'], '--delete'])
    elif sys.argv[1] == '--add_shared':
        print('Adding shared folder ' + sys.argv[2] + '...')
        subprocess.run(['VBoxManage', 'sharedfolder', 'add', vagr_json['machine'], '--name', sys.argv[2], '--hostpath', sys.argv[3], '--transient'])
    elif sys.argv[1] == '--init_shared':
        print('Setting up shared folder ' + sys.argv[2] + ' ...')
        subprocess.run(['VBoxManage', 'guestcontrol', vagr_json['machine'], 'run', '-v', '--exe', '/bin/sh', '--username', 'root', '--password', '1234567890', '--quiet', '--', 'sh/arg0', '-c', 'mkdir {folder} 2>null'.format(folder=sys.argv[3])])
        subprocess.run(['VBoxManage', 'guestcontrol', vagr_json['machine'], 'run', '-v', '--exe', '/sbin/mount.vboxsf', '--username', 'root', '--password', '1234567890', '--quiet', '--', 'mount.vboxsf/arg0', sys.argv[2], sys.argv[3]])
    elif sys.argv[1] == '--list_shared':
        for folder in vagr_json['shared']:
            print(folder)
    elif sys.argv[1] == '--list_ports':
        for port in vagr_json['ports']:
            print(port)
    elif sys.argv[1] == '--name':
        print(vagr_json['machine'])
    elif sys.argv[1] == '--add_port':
        print('Adding port ' + str(sys.argv[2]) + '...')
        subprocess.run(['VBoxManage', 'modifyvm', vagr_json['machine'], '--natpf1', sys.argv[2]])
    elif sys.argv[1] == '--delete_port':
        for port in vagr_json['ports']:
            if sys.argv[2] == port[0]:
                print('Deleting port ' + str(sys.argv[2]) + '...')
                subprocess.run(['VBoxManage', 'modifyvm', vagr_json['machine'], '--natpf1', 'delete', sys.argv[2]])
                vagr_json['ports'].remove(port)
                json_file.close()
                os.chdir(cwd)
                with open('Vagr.json', 'w') as (outfile):
                    json.dump(vagr_json, outfile)
                break
else:
    print('Missing: Vagr.json')
    print('Run: vagr setup [vmname/uuid]')