{% from "lldpd/map.jinja" import lldpd with context -%}

lldpd_package:
  pkg.installed:
    - name: {{ lldpd.package }}

lldpd_flags:
{% if grains['os_family'] == 'FreeBSD' %}
  sysrc.managed:
    - name: lldpd_flags
    - value: "{{ lldpd.flags }}"
{% else %}{# Debian #}
  file.managed:
    - name: /etc/default/lldpd
    - contents: |
        # MANAGED VIA SALT. CHANGES WILL BE OVERWRITTEN.
        # Uncomment to start SNMP subagent and enable CDP, SONMP and EDP protocol
        #DAEMON_ARGS="-x -c -s -e"
        DAEMON_ARGS="{{ lldpd.flags }}"
{% endif %}
    - watch_in:
      - service: lldpd_service

lldpd_service:
  service.running:
    - enable: True
    - name: {{ lldpd.service }}
    - watch:
      - pkg: lldpd_package
