vm.swappiness:
  sysctl:
    - present
    - value: 10

vm.overcommit_memory:
  sysctl:
    - present
    - value: 0
