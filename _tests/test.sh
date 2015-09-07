#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${THIS_SCRIPTDIR}/../_utils.sh"

export profile_file="${THIS_SCRIPTDIR}/_test_env.profile"
export BITRISE_STEP_FORMATTED_OUTPUT_FILE_PATH="${THIS_SCRIPTDIR}/_test_form_out.md"


#
# This should fail, because no "key" is defined
bash "${THIS_SCRIPTDIR}/../step.sh"
if [ $? -eq 0 ] ; then
	echo "[TEST ERROR] Should fail for not defined key!"
	exit 1
fi
echo "[TEST OK]"

#
# Empty Value: should work, only a warning is expected.
#  Intended use: clear out a previsouly defined value.
(
	rm "${profile_file}"
	export key="TEST_ENV_KEY_0"
	# EMPTY VALUE
	bash "${THIS_SCRIPTDIR}/../step.sh"
)
fail_if_cmd_error "[TEST ERROR] Test failed to run!"
(
	print_and_do_command_exit_on_error source "${profile_file}"
)
fail_if_cmd_error "[TEST ERROR] Test checks failed!"
echo "[TEST OK]"

#
# This should work, generate a formatted output and export the variable
#  into the specified environment profile file.
(
	rm "${profile_file}"
	export key="TEST_ENV_KEY_1"
	export value="Test env value, single line"
	bash "${THIS_SCRIPTDIR}/../step.sh"
)
fail_if_cmd_error "[TEST ERROR] Test failed to run!"
(
	source "${profile_file}"
	expected_val="Test env value, single line"
	if [[ "${TEST_ENV_KEY_1}" != "${expected_val}" ]] ; then
		echo "[TEST ERROR] TEST_ENV_KEY_1's value (${TEST_ENV_KEY_1}) doesn't match the expected one (${expected_val})"
		exit 1
	fi
)
fail_if_cmd_error "[TEST ERROR] Test checks failed!"
echo "[TEST OK]"


#
# Multiline test
expected_env_value2="This is

a multiline


env value!"


(
	rm "${profile_file}"
	export key="TEST_ENV_KEY_2"
	export value="${expected_env_value2}"
	bash "${THIS_SCRIPTDIR}/../step.sh"
)
fail_if_cmd_error "[TEST ERROR] Test failed to run!"
(
	source "${profile_file}"
	expected_val="${expected_env_value2}"
	if [[ "${TEST_ENV_KEY_2}" != "${expected_val}" ]] ; then
		echo "[TEST ERROR] TEST_ENV_KEY_2's value (${TEST_ENV_KEY_2}) doesn't match the expected one (${expected_val})"
		exit 1
	fi
)
fail_if_cmd_error "[TEST ERROR] Test checks failed!"
echo "[TEST OK]"

echo
echo "-----------"
echo " [TEST SUCCESS]"
echo "-----------"
echo