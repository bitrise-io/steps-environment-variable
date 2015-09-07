#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${THIS_SCRIPTDIR}/_utils.sh"
source "${THIS_SCRIPTDIR}/_formatted_output.sh"

# init / cleanup the formatted output
echo "" > "${formatted_output_file_path}"

CONFIG_env_file_path="$HOME/.bash_profile"

if [ -n "${profile_file}" ] ; then
  CONFIG_env_file_path="${profile_file}"
fi

if [ ! -n "${key}" ]; then
  write_section_to_formatted_output "# Error!"
  write_section_to_formatted_output "* Reason: no Environment Key was specified!"
  exit 1
fi

if [ ! -n "${value}" ]; then
  write_section_to_formatted_output "**No value provided, will be set to empty value!**"
fi

echo
echo "--- Config:"
echo "Environment Key: ${key}"
echo "Environment Value: ${value}"
echo "Environment profile path: ${CONFIG_env_file_path}"
echo "---"
echo


if [ ! -n "${value}" ]; then
  # No value - make it empty
  echo '' >> "${CONFIG_env_file_path}"
  echo '# Exported Environment' >> "${CONFIG_env_file_path}"
  echo "export ${key}=''" >> "${CONFIG_env_file_path}"
  echo '' >> "${CONFIG_env_file_path}"
else
  #
  # Safe multi-line environment export, with
  #  here-doc syntax.
  # Basically it'll append something like this to the specified Env Profile file:
  #   export YOUR_ENV_KEY=`cat << EOF_ENV_VAR
  #   The content of the variable, what you specified in value
  #   EOF_ENV_VAR`
  #
  echo '' >> "${CONFIG_env_file_path}"
  echo '# Exported Environment' >> "${CONFIG_env_file_path}"
  printf '%s' "export ${key}=" >> "${CONFIG_env_file_path}"
  printf '%s' '`cat << EOF_ENV_VAR' >> "${CONFIG_env_file_path}"
  echo '' >> "${CONFIG_env_file_path}"
  echo "${value}" >> "${CONFIG_env_file_path}"
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
if [ ! -n "${value}" ]; then
	write_section_to_formatted_output "${key}: **not provided (empty)**"
else
	write_section_to_formatted_output "${key}:"
  write_section_to_formatted_output "${value}"
fi

exit 0
