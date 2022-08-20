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

get_project_name() {
    line=$(grep "^Name" package/metadata.desktop)
    IFS='='
    read -ra array <<< "${line}"
    projectname=${array[1]}
    echo "${projectname}"
}

PACKAGE_NAME=$(kreadconfig5 --file="$PWD/package/metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Name")

# tar -cvf "${PACKAGE_NAME}.kwinscript" -C "package/" .
zip -r "${PACKAGE_NAME}.kwinscript package" "package"

prompt "Do you want to commit and push the changes to the git repository?" && \
git add . && \
git commit -m "Update package" && \
git push
