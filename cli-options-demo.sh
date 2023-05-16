#!/bin/bash

function usage {
    cat <<END
Usage: $0 [options]
Options:
  --no_cluster   Do not create cluster
  --aws   | -aw  Create AWS cloud account 
  --azure | -az  Create Azure cloud account
  --no_cloud     Do not create cloud account

If any of '--aws' or '--azure' is not specified, AWS cloud account will be created by default unless '--no_cloud' option is specified.

END
    exit $1
}

NOCLUSTER=false
AWS_CL=false
AZURE_CL=false
NOCLOUD=false

ARGUMENT_LIST=(
  "help"  
  "no_cluster"
  "no_cloud"
  "aws"
  "azure"
)

PARSED_ARGUMENTS=$(getopt \
-a \
--longoptions "$(printf "%s," "${ARGUMENT_LIST[@]}")" \
--name "$(basename "$0")" \
--options "" \
-- "$@")

VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set --"$PARSED_ARGUMENTS"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no_cluster)
      NOCLUSTER=true
      shift 1
      ;;

    --no_cloud)
      NOCLOUD=true
      shift 1
      ;;

    --aws)
      AWS_CL=true
      shift 1
      ;;

    -az | --azure)
      AZURE_CL=true
      shift 1
      ;;

    -h | --help)
      usage 
      ;;

    --)
      shift 1
      ;;  

    *)
      echo "Invalid argument: [$1]"
      usage
      ;;
  esac
done

if $AWS_CL && $AZURE_CL; then
   echo "Error: Both AWS (--aws) and Azure (--azure) were specified." 1>&2
   exit 1
fi

echo "NOCLUSTER     : $NOCLUSTER"
echo "NOCLOUD       : $NOCLOUD "
echo "AWS_CL        : $AWS_CL"
echo "AZURE_CL      : $AZURE_CL"
echo "Parameters remaining are: $@"
