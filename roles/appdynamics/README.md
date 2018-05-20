# Role appdynamics

## Install Appdynamics AppAgent and MachineAgent

### Dependencies:

- role web-base

### Configuration

- Config hash "appdynamics"

Example config hash in vars file "appdynamics.yml":

```shell
appdynamics:
  version: 4.2.14.0
  machineagent:
    ensure: 'present'
    status: 'running'
  appagent:
    ensure: 'present'
  account: 'bigl'
  application: 'BigL-Test'
  tier: 'BigL-Rest-Proxy'
  access_key: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx'
```