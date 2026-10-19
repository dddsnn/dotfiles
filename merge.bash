#!/usr/bin/env bash

GENERAL_FILES_DIR="general_files/"
DEVICE_SPECIFIC_FILES_DIR="device_specific_files/"

function merge_files_from() {
    files_dir="${1}"
    source_paths=$(find ${files_dir} -type f)
    for source_path in ${source_paths} ; do
        path="${source_path#${files_dir}}"
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
}

echo -n "Merging general files to \"${HOME}\". Ok? [y/n] "
read response
if [[ "${response}" == "y" ]] ; then
    merge_files_from "${GENERAL_FILES_DIR}"
elif [[ "${response}" != "n" ]] ; then
    echo "Response \""${response}"\" not understood."
    exit 1
fi

devices="$(printf "%s " $(ls ${DEVICE_SPECIFIC_FILES_DIR}) | sed 's/ $//')"
if [[ "${devices}" == "" ]] ; then
    exit 0
fi
echo -n "Found files for devices [${devices}]. Which should be merged to \"${HOME}\" (empty for none)? "
read device
if [[ "${device}" == "" ]] ; then
    exit 0
fi
if [[ ! -d "${DEVICE_SPECIFIC_FILES_DIR}/${device}" ]] ; then
    echo "Device ${device} doesn't exist."
    exit 1
else
    merge_files_from "${DEVICE_SPECIFIC_FILES_DIR}/${device}"
fi
