#!/usr/bin/env bash

DOTFILES_DIR="files/"

echo -n "Merging to \"${HOME}\". Ok? [y/n] "
read response
if [[ "${response}" == "n" ]] ; then
    exit 0
elif [[ "${response}" != "y" ]] ; then
    echo "Response \""${response}"\" not understood."
    exit 1
fi

source_paths=$(find ${DOTFILES_DIR} -type f)
for source_path in ${source_paths} ; do
    path="${source_path#${DOTFILES_DIR}}"
    echo -n "Processing ${path} ..."
    dir="$(dirname ${path})"
    dest_path="${HOME}/${path}"
    dest_dir="${HOME}/${dir}"

    if [[ ! -f "${dest_path}" ]] ; then
        echo " ${dest_path} doesn't exist, copying."
        mkdir -p "${dest_dir}"
        cp "${source_path}" "${dest_path}"
        continue
    fi

    diff "${dest_path}" "${source_path}" > /dev/null 2>&1
    if [[ $? -eq 0 ]] ; then
        echo " ${dest_path} exists, but there is no difference, continuing."
        continue
    fi
    echo " ${dest_path} exists."

    while true ; do
        echo -n "[(s)kip / Show (d)iff / (c)opy] "
        read response
        if [[ "${response}" == "s" ]] ; then
            continue 2
        elif [[ "${response}" == "d" ]] ; then
            diff "${dest_path}" "${source_path}"
            continue
        elif [[ "${response}" == "c" ]] ; then
            cp "${source_path}" "${dest_path}"
            break
        else
            echo "Response \""${response}"\" not understood."
            continue
        fi
    done
done
