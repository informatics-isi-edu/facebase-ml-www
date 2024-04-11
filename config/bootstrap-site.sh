#!/bin/bash

set -e

if [[ "$#" -eq 0 ]]
then
  echo "Invalid parameter(s): must specify <-h|--host>, catalog <-c|--catalog>, and optional <-l|--label>"
  exit 1
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    -h) host="$2"; shift 2;;
    -c) catalog="$2"; shift 2;;
    -l) label="$2"; shift 2;;
    --host=*) host="${1#*=}"; shift 1;;
    --catalog=*) catalog="${1#*=}"; shift 1;;
    --label=*) label="${1#*=}"; shift 1;;
    --host|--catalog) echo "$1 requires an argument" >&2; exit 1;;

    -*) echo "unknown option: $1" >&2; exit 1;;
    *) echo "unrecognized argument: $1" >&2; exit 1;;
  esac
done

echo "Host = ${host}"
echo "Catalog = \"${catalog}"\"
echo "Label = \"${label:=${host}}"\"
echo "HeadTitle = \"${label:=${host}}"\"
echo "NavbarBrandText = \"${label:=${host}}"' Data Browser'\"

deriva-catalog-cli --host ${host} create --id "${catalog}" \
--owner 'https://auth.globus.org/3938e0d0-ed35-11e5-8641-22000ab4b42b' \
--auto-configure \
--configure-args includeWWWSchema='False' \
publicSchemaDisplayName='User Info' \
headTitle="${label:=${host}}" \
navbarBrandText="${label:=${host}}"' Data Browser'

deriva-acl-config --host ${host} --config ./self_serve_policy.json "${catalog}"

#  Reference for below Hatrac ACLs:
#  "isrd-systems":      ["https://auth.globus.org/3938e0d0-ed35-11e5-8641-22000ab4b42b"],
#  "isrd-staff":        ["https://auth.globus.org/176baec4-ed26-11e5-8e88-22000ab4b42b"],
#  "isrd-testers":      ["https://auth.globus.org/9d596ac6-22b9-11e6-b519-22000aef184d"],
#  "project-admins":    ["https://auth.globus.org/a936387a-f767-11ee-8680-2565a03ec47c"],
#  "project-curators":  ["https://auth.globus.org/c2510ac2-f769-11ee-a014-1fb3dd6261f9"],
#  "project-writers":   ["https://auth.globus.org/8951e112-f767-11ee-8680-2565a03ec47c"],
#  "project-users":     ["https://auth.globus.org/1ef7a8ec-f767-11ee-b567-2f0eecfe32e3"],

deriva-hatrac-cli --host ${host} setacl /hatrac/ owner \
'https://auth.globus.org/3938e0d0-ed35-11e5-8641-22000ab4b42b' \
'https://auth.globus.org/a936387a-f767-11ee-8680-2565a03ec47c'

deriva-hatrac-cli --host ${host} setacl /hatrac/ create \
'https://auth.globus.org/3938e0d0-ed35-11e5-8641-22000ab4b42b' \
'https://auth.globus.org/a936387a-f767-11ee-8680-2565a03ec47c' \
'https://auth.globus.org/c2510ac2-f769-11ee-a014-1fb3dd6261f9'

deriva-hatrac-cli --host ${host} setacl /hatrac/ subtree-owner \
'https://auth.globus.org/3938e0d0-ed35-11e5-8641-22000ab4b42b' \
'https://auth.globus.org/a936387a-f767-11ee-8680-2565a03ec47c'

deriva-hatrac-cli --host ${host} setacl /hatrac/ subtree-create \
'https://auth.globus.org/3938e0d0-ed35-11e5-8641-22000ab4b42b' \
'https://auth.globus.org/a936387a-f767-11ee-8680-2565a03ec47c' \
'https://auth.globus.org/c2510ac2-f769-11ee-a014-1fb3dd6261f9'

deriva-hatrac-cli --host ${host} setacl /hatrac/ subtree-update \
'https://auth.globus.org/c2510ac2-f769-11ee-a014-1fb3dd6261f9' \
'https://auth.globus.org/8951e112-f767-11ee-8680-2565a03ec47c'

deriva-hatrac-cli --host ${host} setacl /hatrac/ subtree-read \
'https://auth.globus.org/176baec4-ed26-11e5-8e88-22000ab4b42b' \
'https://auth.globus.org/9d596ac6-22b9-11e6-b519-22000aef184d' \
'https://auth.globus.org/c2510ac2-f769-11ee-a014-1fb3dd6261f9' \
'https://auth.globus.org/8951e112-f767-11ee-8680-2565a03ec47c' \
'https://auth.globus.org/ba972c88-ac96-11ed-9b41-0551c8802154'