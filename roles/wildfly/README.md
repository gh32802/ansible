# Role wildfly

## Creates instances of Wildfly Application server

### Dependencies:

- role web-base
- role java

### Configuration

- Config hash "wildfly_instances"
- Config files from wildfly distribution ($JBOSS_HOME_DIR/standalone/configuration/*)
- Inserts for DATASOURCE and MQ configuration parts

Example config hash in vars file "wildfly.yml":

```shell
wildfly_instances:
  - name: 'wildfly8080'
    enable: false
    ensure: 'present'
    status: 'running'
    is_managed: true
    wildfly_version: '9.0.2'
    java_version: '8u131'
    port: '8080'
    cli_base_port: 9990
    port_offset: 0
    jboss_opts: []
    java_opts:
      - '-Xms1024m'
      - '-Xmx1024m'
      - '-XX:MaxPermSize=128m'
      - '-Djava.net.preferIPv4Stack=true'
      - '-Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS'
      - '-Djava.awt.headless=true'
      - '-Djboss.modules.policy-permissions=true'
      - '-Djboss.socket.binding.port-offset=0'
      - '-Djboss.node.name=$NODENAME'
      - '-Djboss.bind.address=0.0.0.0'
      - '-Djboss.bind.address.management=127.0.0.1'
    standalone_inserts: []
    config_files: []
    module_base_path: 'modules/system/layers/base'
    artifacts:
      - file: 'test.war'
        ensure: 'absent'
    modules:
      - name: 'ibm/db2'
        version: '4.19.26'
        path: 'com/ibm/db2'
        ensure: 'present'
        file: 'db2jcc.tar.gz'
      - name: 'oracle/jdbc'
        version: '11.2.0.2.0'
        path: 'com/oracle/jdbc'
        ensure: 'present'
        file: 'ojdbc6.tar.gz'
```
