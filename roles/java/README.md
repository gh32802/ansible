# Role java

## Install Oracle JDK

### Dependencies:

- role web-base

### Configuration

- Config hash "java_instances"

Example config hash in vars file "java.yml":

```shell
java_instances:
  - version: '6u45'
    ensure: 'present'
    link: 'jdk6'
    set_link: True
  - version: '8u151'
    ensure: 'present'
    link: 'jdk8'
    set_link: True
  - version: '9.0.1'
    ensure: 'present'
    link: 'latest'
    set_link: True
```

