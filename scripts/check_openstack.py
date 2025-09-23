#!/usr/bin/env python3
import re, json, sys, urllib.request, urllib.error, shutil, subprocess

TFVARS = 'terraform/terraform.tfvars'
vars = {}
try:
    with open(TFVARS) as f:
        for line in f:
            m = re.match(r"^\s*([A-Za-z0-9_]+)\s*=\s*\"([^\"]*)\"", line)
            if m:
                vars[m.group(1)] = m.group(2)
except FileNotFoundError:
    print(f'Missing {TFVARS}', file=sys.stderr)
    sys.exit(1)

required = ['os_auth_url','os_username','os_password','os_project_name']
missing = [r for r in required if not vars.get(r)]
if missing:
    print('Missing required OpenStack values in %s: %s' % (TFVARS, ', '.join(missing)))
    sys.exit(1)

os_auth_url = vars.get('os_auth_url')
os_username = vars.get('os_username')
os_password = vars.get('os_password')
os_user_domain = vars.get('os_user_domain_name','Default')
os_project = vars.get('os_project_name')
os_project_domain = vars.get('os_project_domain_name','Default')

payload = {
    'auth':{
        'identity':{'methods':['password'],'password':{'user':{
            'name': os_username,
            'domain':{'name': os_user_domain},
            'password': os_password
        } }},
        'scope':{'project':{'name': os_project,'domain':{'name': os_project_domain}}}
    }
}

data = json.dumps(payload).encode('utf-8')
url = os_auth_url.rstrip('/') + '/auth/tokens'
req = urllib.request.Request(url, data=data, headers={'Content-Type':'application/json'}, method='POST')
try:
    with urllib.request.urlopen(req, timeout=20) as resp:
        status = resp.getcode()
        token = resp.getheader('X-Subject-Token') or ''
        if status == 201 and token:
            print(f'Authentication succeeded (HTTP 201). Token length: {len(token)} characters.')
        else:
            print(f'Authentication response: HTTP {status}')
except urllib.error.HTTPError as e:
    body = e.read(400).decode('utf-8', errors='ignore')
    print(f'Authentication failed. HTTP status: {e.code}')
    print('Response body (first 400 chars):')
    print(body)
except Exception as e:
    print('Request failed:', e)

# check openstack CLI
cli = shutil.which('openstack')
if cli:
    try:
        v = subprocess.run([cli,'--version'], capture_output=True, text=True, timeout=5)
        ver = (v.stdout.strip() or v.stderr.strip()).splitlines()[0]
    except Exception:
        ver = 'version unknown'
    print('openstack CLI: available ->', ver)
else:
    print('openstack CLI: not installed')
