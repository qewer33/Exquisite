 #!/usr/bin/env bash

get_project_id() {
    line=$(grep "^X-KDE-PluginInfo-Name" package/metadata.desktop)
    IFS='='
    read -ra array <<< "${line}"
    projectid=${array[1]}
    echo ${projectid}
}

PROJECT_ID=$(get_project_id)
INSTALL_LOCATION="${HOME}/.local/share/plasma/plasmoids/"

echo "Installing ${PROJECT_ID}"

if [ ! -d "${INSTALL_LOCATION}" ]; then
    mkdir "${INSTALL_LOCATION}${PROJECT_ID}"
else
    echo "Skipping directory creation: directory exists"
fi

cp -R "package/." "${INSTALL_LOCATION}${PROJECT_ID}/" &&
echo "Successfully installed ${PROJECT_ID} to ${INSTALL_LOCATION}/" ||
echo "Installation failed"
