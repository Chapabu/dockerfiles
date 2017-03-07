#! /usr/bin/env bash

#####
# Ensure permissions are valid.
#####
do_build_permissions() {
  if [ "$IS_CHOWN_FORBIDDEN" -ne 0 ]; then
    chown -R "$CODE_OWNER":"$CODE_GROUP" ${WORK_DIRECTORY}
  else
    chmod -R a+rw ${WORK_DIRECTORY}
  fi
}

#####
# Run pip installation.
#####
run_pip() {
  as_code_owner "pip install -r ${REQUIREMENTS_FILE}" "${REQUIREMENTS_DIRECTORY}"
}

#####
# Check if there's a requirements.txt file.
#####
do_pip() {
  if [ -f "${REQUIREMENTS_DIRECTORY}/${REQUIREMENTS_FILE}"]; then
    run_pip
  fi
}