# Role tomcat

## Creates instances of Apache Tomcat Application server

### Requirements:

- Filesystem "/wxx"
- User "webuser"

### Dependencies:

- role web-base
- role java

### Configuration

- Config hash "tomcat_instances"
- Config files from tomcat distribution ($CATALINA_HOME/conf/*)

Example config hash in vars file "tomcat.yml":

```shell
tomcat_instances:
  - name: 'tomcat9080'
    enable: false
    ensure: 'present'
    status: 'running'
    is_managed: true
    managed_by: 'webstaff'
    tomcat_version: '8.5.23'
    java_version: '8u144'
    maint_stop_delay: '15m'
    port: '9080'
    starttimeout: 120
    stoptimeout: 60
    catalina_opts:
      - '-server'
      - '-Xms1024m'
      - '-Xmx1024m'
      - '-XX:MaxMetaspaceSize=256m'
      - '-Djava.net.preferIPv4Stack=true'
      - '-Djava.net.preferIPv4Addresses=true'
      - '-Djava.awt.headless=true'
      - '-Dservername=$SERVERNAME'
    modules:
      - name: 'db2'
        version: '3.69.24'
        ensure: 'present'
        file: 'db2jcc.jar'
      - name: 'db2'
        version: '3.69.24'
        ensure: 'present'
        file: 'db2jcc_license_cisuz.jar'
    apps:
      - path: 'ROOT'
        file: 'ROOT.war'
        src: "{{ resources }}/apps"
        ensure: 'present'
        remote_src: 'no'
      - path: 'test'
        file: 'test.war'
        src: "{{ resources }}/apps"
        remote_src: 'no'
        ensure: 'present'
      - path: 'showcase
    appdynamics:
      ensure: 'present'
      properties:
        accountName: 'wsa'
        applicationName: 'wsaapp-test'
        tierName: 'wsaapp-test-tomcat'
        nodeName: $SERVERNAME
        uniqueHostId: "{{ ansible_fqdn }}"
```

### Role variables

```shell
tomcat_java_version
tomcat_java_archive_name
tomcat_java_home
tomcat_instance_name
tomcat_instance_ensure
tomcat_instance_status
tomcat_instance_enable
tomcat_version
tomcat_archive_name
tomcat_version_major
tomcat_version_minor
tomcat_version_patch
tomcat_http_port
tomcat_catalina_base
tomcat_catalina_home
tomcat_modules
tomcat_keystores
tomcat_apps
tomcat_user
tomcat_group
tomcat_java_opts
tomcat_catalina_opts
tomcat_starttimeout
tomcat_stoptimeout
tomcat_maint_stop_delay
tomcat_certs
tomcat_ca_certs
tomcat_ld_library_path
tomcat_appdynamics
tomcat_appdynamics_ensure
tomcat_appdynamics_properties
```

### Example playbook

```shell
---
 - hosts: testgroup
   remote_user: webuser
   gather_facts: no

   vars:
     ansible_home: "{{ lookup('env','ANSIBLE_HOME') }}"
     wsa_environment: test
     wsa_nodegroup: testgroup

   vars_files:
     - "{{ ansible_home }}/defaults/main.yml"
     - "vars/java.yml"
     - "vars/tomcat.yml"

   pre_tasks:
     - name: Gather Facts
       setup:
         filter: ansible_*

   roles:
     - web-base
     - java
     - tomcat
```

### Playbook layout example (tomcat8)

```shell
└── showcase-app
    ├── files
    │   └── tomcat9080
    │       ├── catalina.policy
    │       ├── catalina.properties
    │       ├── context.xml
    │       ├── jaspic-providers.xml
    │       ├── jaspic-providers.xsd
    │       ├── logging.properties
    │       ├── server.xml
    │       ├── tomcat-users.xml
    │       ├── tomcat-users.xsd
    │       └── web.xml
    ├── Jenkinsfile
    ├── site.yml
    ├── README.md
    ├── restart.yml
    ├── scripts
    │   ├── restart.sh
    │   ├── run.sh
    │   ├── start.sh
    │   └── stop.sh
    ├── start.yml
    ├── stop.yml
    └── vars
        ├── java.yml
        └── tomcat.yml
```

### Example Jenkinsfile

```shell
pipeline {
    agent any
    environment {
      ANSIBLE_HOME = "/wxx/ansible"
      ANSIBLE_CONFIGURATION = "${ANSIBLE_HOME}/ansible.cfg"
      REPOSERVER = "vvm1058.eil.risnet.de"
      ENVIRONMENT = "showcase"
      NODEGROUP = "showcase-app"
    }
    stages {
        stage('WebApp') {
            steps {
                echo 'Check roles for updates'
                script {
                  roles = [ 'web-base','java','tomcat', ]
                  for (role in roles) {
                    dir ("${ANSIBLE_HOME}/roles/${role}") {
                      git url: "git@${REPOSERVER}:WEBSTAFF/ANSIBLE_ROLES/${role}.git"
                    }
                  }
                }
                echo 'Get nodes'
                sh "/wxx/ansible/scripts/get_nodes.pl ${ENVIRONMENT} ${NODEGROUP}"
                echo 'Checkout playbook'
                dir ("${ANSIBLE_HOME}/playbooks/$ENVIRONMENT/${NODEGROUP}") {
                  git url: "git@${REPOSERVER}:WEBSTAFF/ANSIBLE_PLAYS/$ENVIRONMENT/${NODEGROUP}.git"
                }
                echo 'Run playbook'
                sh "ansible-playbook ${ANSIBLE_HOME}/playbooks/$ENVIRONMENT/${NODEGROUP}/site.yml --diff"
            }
        }
    }
    post {
      always {
        // Clean up workspace
        echo "Cleanup workspace"
        deleteDir()
      }
    }
}
```
