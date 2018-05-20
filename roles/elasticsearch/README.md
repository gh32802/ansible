# Role elasticsearch

## Creates instances of Elasticsearch server

### Dependencies:

- role web-base
- role java

### Configuration

- Config hash "elasticsearch_instances"
- Config files from elasticsearch distribution ($ES_HOME/config/*)

Example config hash in vars file "elasticsearch.yml":

```shell
elasticsearch_instances:
  - name: 'es9200'
    enable: false
    ensure: 'present'
    status: 'running'
    is_managed: true
    managed_by: 'webstaff'
    elasticsearch_version: '2.2.2'
    java_version: '8u131'
    network_host: '0.0.0.0'
    port: '9200'
    modules: []
    plugins:
      - name: 'delete-by-query'
        version: '2.2.2'
        ensure: 'present'
```
