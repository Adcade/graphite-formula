{%- set graph_explorer = salt['pillar.get']('graphite:config:graph_explorer', False) %}

{% if graph_explorer %}

include:
  - graphite

/opt/graph-explorer/.virtualenv:
  virtualenv.managed:
    - user: graphite
    - require:
      - file: /opt/graph-explorer

https://github.com/vimeo/graph-explorer.git:
  git.latest:
    - rev: master
    - user: graphite
    - submodules: True
    - target: /opt/graph-explorer/src
    - require:
      - file: /opt/graph-explorer

/opt/graph-explorer:
  file.directory:
    - user: graphite
    - group: graphite
    - mode: 755
    - makedirs: True

install_graph_explorer:
  cmd.wait:
    - name: "source /opt/graph-explorer/.virtualenv/bin/activate && python /opt/graph-explorer/src/setup.py install"
    - watch:
      - git: https://github.com/vimeo/graph-explorer.git
    - user: graphite

/etc/supervisor/conf.d/graph-explorer.conf:
  file.managed:
    - source: salt://graphite/files/supervisord-graph-explorer.conf
    - mode: 644
    - user: graphite
    - group: graphite
    - require:
      - user: graphite

/opt/graph-explorer/graph-explorer.conf:
  file.managed:
    - source: salt://graphite/files/graph-explorer.conf
    - mode: 644
    - user: graphite
    - group: graphite
    - require:
      - user: graphite

{% endif %}
