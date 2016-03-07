#!/bin/bash -e

if test -z "${LDAP_ENV_DOMAIN}"; then
    echo "**** ERROR: please link to an mwaeckerlin/openldap container" 1>&2
    echo "            e.g.: --link my-openldap-container:ldap"
    exit 1
fi

DOMAIN="dc=${LDAP_ENV_DOMAIN//./,dc=}"

sed -e 's|\(\$servers->setValue('"'"'server'"'"','"'"'host'"'"','"'"'\).*\('"'"');\)|\1ldap\2|' \
    -e 's|\(\$servers->setValue('"'"'server'"'"','"'"'base'"'"',array('"'"'\).*\('"'"'));\)|\1'"cn=config','${DOMAIN}"'\2|' \
    -e 's|\(\$servers->setValue('"'"'login'"'"','"'"'bind_id'"'"','"'"'\).*\('"'"');\)|\1'"${USER:-cn=admin,${DOMAIN}}"'\2|' \
    -e 's|.*\(\$config->custom->appearance\['"'"'hide_template_warning'"'"'\] = \).*\(;\)|\1true\2|' \
    -i /etc/phpldapadmin/config.php

apache2ctl -DFOREGROUND
