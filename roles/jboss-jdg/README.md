# Role jboss-jdg

## Creates instances of Jboss DATAGRID server (JDG)

### Dependencies:

- role web-base
- role java

### Configuration

- Config hash "jdg_instances"
- Config files from jboss-jdg distribution ($JBOSS_HOME_DIR/standalone/configuration/*)
- Inserts for DATASOURCE and MQ configuration parts

Example config hash in vars file "jboss-jdg.yml":

```shell
jdg_instances:
  - name: 'jdg8180'
    enable: false
    ensure: 'present'
    status: 'running'
    is_managed: true
    managed_by: 'webstaff'
    jdg_version: '6.4.0'
    java_version: '8u111'
    port: '8180'
    cli_base_port: 9999
    port_offset: 100
    jboss_opts: []
    java_opts:
      - '-Xms512m'
      - '-Xmx512m'
      - '-XX:MaxMetaspaceSize=128m'
      - '-Djava.net.preferIPv4Stack=true'
      - '-Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS'
      - '-Djava.awt.headless=true'
      - '-Djboss.modules.policy-permissions=true'
      - '-Djboss.socket.binding.port-offset=100'
      - '-Djboss.node.name=$NODENAME'
      - '-Djboss.bind.address=0.0.0.0'
      - '-Djboss.bind.address.management=127.0.0.1'
    standalone_xml:
      deploy: False
      src: ''
    standalone_inserts: []
    config_files: []
    module_base_path: 'modules/system/layers/base'
    modules: []
```
