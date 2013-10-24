{% if grains['os'] == 'RedHat' %}
sudoer-group: wheel 
{% elif grains['os'] == 'Ubuntu' %}
sudoer-group: sudo 
{% elif grains['os'] == 'Amazon' %}
sudoer-group: wheel 
{% endif %}
