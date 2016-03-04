FROM ubuntu
MAINTAINER mwaeckerlin
ENV TERM "xterm"

ENV PASSWORD ""

EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get install -y phpldapadmin

START DOMAIN="dc=${LDAP_ENV_DOMAIN//./,dc=}"; \
      sed -e 's|\(\$servers->setValue('"'"'server'"'"','"'"'host'"'"','"'"'\).*\('"'"');\)|\1ldap\2|' \
          -e 's|\(\$servers->setValue('"'"'server'"'"','"'"'base'"'"',array('"'"'\).*\('"'"'));\)|\1'"${DOMAIN}"'\2|' \
          -e 's|\(\$servers->setValue('"'"'login'"'"','"'"'bind_id'"'"','"'"'\).*\('"'"');\)|\1'"cn=admin,${DOMAIN}"'\2|' \
          -e 's|.*\(\$config->custom->appearance\['"'"'hide_template_warning'"'"'\] = \).*\(;\)|\1true\2|' \
          -i /etc/phpldapadmin/config.php; \
      apache2ctl -DFOREGROUND
