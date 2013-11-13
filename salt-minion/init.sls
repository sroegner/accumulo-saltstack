
salt-mine:
  file:
    - managed
    - name: /etc/salt/minion.d/mine.conf
    - source: salt://salt-minion/salt-minion-mine.conf
    - user: root
    - group: root
    - mode: 644

salt-minion:
  service:
    - running
    - watch:
      - file: salt-mine

