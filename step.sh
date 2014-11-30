#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${THIS_SCRIPTDIR}/_utils.sh"
source "${THIS_SCRIPTDIR}/_formatted_output.sh"

# init / cleanup the formatted output
echo "" > "${formatted_output_file_path}"

CONFIG_env_file_path="$HOME/.bash_profile"

if [ -n "${ENVIRONMENT_PROFILE_FILE}" ] ; then
  CONFIG_env_file_path="${ENVIRONMENT_PROFILE_FILE}"
fi

if [ ! -n "${ENVIRONMENT_KEY}" ]; then
  write_section_to_formatted_output "# Error!"
  write_section_to_formatted_output "* Reason: no Environment Key was specified!"
  exit 1
fi

if [ ! -n "${ENVIRONMENT_VALUE}" ]; then
  write_section_to_formatted_output "**No value provided, will be set to empty value!**"
fi

echo
echo "--- Config:"
echo "Environment Key: ${ENVIRONMENT_KEY}"
echo "Environment Value: ${ENVIRONMENT_VALUE}"
echo "Environment profile path: ${CONFIG_env_file_path}"
echo "---"
echo


if [ ! -n "${ENVIRONMENT_VALUE}" ]; then
  # No value - make it empty
  echo '' >> "${CONFIG_env_file_path}"
  echo '# Exported Environment' >> "${CONFIG_env_file_path}"
  echo "export ${ENVIRONMENT_KEY}=''" >> "${CONFIG_env_file_path}"
  echo '' >> "${CONFIG_env_file_path}"
else
  #
  # Safe multi-line environment export, with
  #  here-doc syntax.
  # Basically it'll append something like this to the specified Env Profile file:
  #   export YOUR_ENV_KEY=`cat << EOF_ENV_VAR
  #   The content of the variable, what you specified in ENVIRONMENT_VALUE
  #   EOF_ENV_VAR`
  #
  echo '' >> "${CONFIG_env_file_path}"
  echo '# Exported Environment' >> "${CONFIG_env_file_path}"
  printf '%s' "export ${ENVIRONMENT_KEY}=" >> "${CONFIG_env_file_path}"
  printf '%s' '`cat << EOF_ENV_VAR' >> "${CONFIG_env_file_path}"
  echo '' >> "${CONFIG_env_file_path}"  
  echo "${ENVIRONMENT_VALUE}" >> "${CONFIG_env_file_path}"
  printf '%s' 'EOF_ENV_VAR`' >> "${CONFIG_env_file_path}"
  echo '' >> "${CONFIG_env_file_path}"
  echo '' >> "${CONFIG_env_file_path}"
fi

if [ $? -ne 0 ] ; then
  write_section_to_formatted_output "# Error!"
  write_section_to_formatted_output "Failed to write the environment variable into the specified environment profile file!"
  exit 1
fi

write_section_to_formatted_output "# Success"
if [ ! -n "${ENVIRONMENT_VALUE}" ]; then
	write_section_to_formatted_output "${ENVIRONMENT_KEY}: **not provided (empty)**"
else
	write_section_to_formatted_output "${ENVIRONMENT_KEY}:"
  write_section_to_formatted_output "${ENVIRONMENT_VALUE}"
fi

exit 0
