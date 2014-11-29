#!/bin/bash

formatted_output_file_path="$BITRISE_STEP_FORMATTED_OUTPUT_FILE_PATH"

function echo_string_to_formatted_output {
  echo "$1" >> $formatted_output_file_path
}

function write_section_to_formatted_output {
  echo '' >> $formatted_output_file_path
  echo "$1" >> $formatted_output_file_path
  echo '' >> $formatted_output_file_path
}

echo "Environment Key: $ENVIRONMENT_KEY"
echo "Environment Value: $ENVIRONMENT_VALUE"

if [ ! -n "$ENVIRONMENT_KEY" ]; then
  echo " [!] ENVIRONMENT_KEY is missing! Terminating..."
  echo
  write_section_to_formatted_output "# Error!"
  write_section_to_formatted_output "Reason: enviroment key is missing."
  exit 1
fi

echo "export $ENVIRONMENT_KEY=\"$ENVIRONMENT_VALUE\"" >> ~/.bash_profile
if [ ! -n "$ENVIRONMENT_VALUE" ]; then
	write_section_to_formatted_output "**${ENVIRONMENT_KEY}** = **not provided (empty)**"
else
	write_section_to_formatted_output "**${ENVIRONMENT_KEY}** = ${ENVIRONMENT_VALUE}"
fi