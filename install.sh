#!/usr/bin/env bash

PACKAGE_NAME=$(kreadconfig5 --file="${PWD}/package/metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Name")
INSTALL_LOCATION="${HOME}/.local/share/kwin/scripts/"

echo "Installing PACKAGE_NAME"

if [ ! -d "${INSTALL_LOCATION}" ]; then
    mkdir -p "${INSTALL_LOCATION}${PACKAGE_NAME}"
else
    echo "Skipping directory creation: directory exists"
fi

cd widget
./install.sh
cd ..

cp -R "package/." "${INSTALL_LOCATION}${PACKAGE_NAME}/" &&
echo "Successfully installed ${PACKAGE_NAME} to ${INSTALL_LOCATION}" ||
echo "Installation failed"
