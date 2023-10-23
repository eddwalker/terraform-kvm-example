# Path to plugins dir
PLUGIN_DIR=$HOME/.terraform/plugin-cache/x86_64

# Path to providers dir insite plugins dir
PROVIDER_DIR=$PLUGIN_DIR/.terraform/providers

# Path to terraform plan file, must be unique per dev/test/prod/etc
# normally pwd is workdir for scripts in dev/test/prod/etc
PLAN_FILE=$(pwd)/plan.out

# Path to script initially call something in ./sh
WORK_DIR=$(pwd)
