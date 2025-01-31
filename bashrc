validate_playbook()
{
    local limit

    [ $# -lt 1 ] && { echo "Usage: SKIP_LINTING=<YES> EXTRA_ARGS=<EXTRA_ARGS> $FUNCNAME <PLAYBOOK> [ <LIMIT> ]" >&2; return 1; }

    [ -n "$2" ] && limit=$2

    [ -f $1 ] || { echo "File $1 does not exist in $PWD" >&2; return 1; }

    if [ -z "$SKIP_LINTING" ] ;then
        ansible-lint $1 || return $?
    fi

    if [ -n "$limit" ]; then
        ansible-playbook -l $limit $1 --syntax-check || return $?

        if [ -n "$EXTRA_ARGS" ]; then
            ansible-playbook -l $limit $1 --check -e vm_name="$EXTRA_ARGS" || return $?
        else
            ansible-playbook -l $limit $1 --check || return $?
        fi
    else
        ansible-playbook $1 --syntax-check || return $?

        if [ -n "$EXTRA_ARGS" ]; then
            ansible-playbook $1 --check -e vm_name="$EXTRA_ARGS" || return $?
        else
            ansible-playbook $1 --check || return $?
        fi
    fi
}

execute_playbook()
{
    local file
    local limit

    [ $# -lt 1 ] && { echo "Usage: EXTRA_ARGS=<EXTRA_ARGS> $FUNCNAME <PLAYBOOK> [ <LIMIT> ] [ <EXTRA-PLAYBOOKS> ]" >&2; return 1; }

    file=$1

    if [ -n "$2" ]; then
        limit=$2
        shift 2
    else
        shift 1
    fi

    [ -f $file ] || { echo "File $file does not exist in $PWD" >&2; return 1; }

    if [ -n "$limit" ]; then
        if [ -n "$EXTRA_ARGS" ]; then
            ansible-playbook -l $limit $file -e vm_name="$EXTRA_ARGS" $@ || return $?
        else
            ansible-playbook -l $limit $file $@ || return $?
        fi
    else
        if [ -n "$EXTRA_ARGS" ]; then
            ansible-playbook $file -e vm_name="$EXTRA_ARGS" $@ || return $?
        else
            ansible-playbook $file $@ || return $?
        fi
    fi
}

alias vp=validate_playbook
alias ep=execute_playbook
