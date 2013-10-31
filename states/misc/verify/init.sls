python-pip:
  pkg.installed

nose:
  pip.installed:
    - require:
      - pkg: python-pip