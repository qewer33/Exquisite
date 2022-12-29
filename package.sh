  #!/usr/bin/env bash

prompt() {
    while true; do
        echo -e "$1 [y/n]: "
        read -r yn
        case ${yn} in
            [Yy]*) return 0 ;;
            [Nn]*) return  1 ;;
        esac
    done
}

PACKAGE_NAME=$(kreadconfig5 --file="${PWD}/package/metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Name")

zip -r "${PACKAGE_NAME}.kwinscript" "package"

prompt "Do you want to commit and push the changes to the git repository?" && \
git add . && \
git commit -m "Update package" && \
git push
