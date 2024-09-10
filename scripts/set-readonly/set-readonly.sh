
function set-readonly() {
    # make current role give only ReadOnlyAccess
    aws sts assume-role --role-arn $(aws sts get-caller-identity --query "Arn" --output text) --role-session-name MY-AWSCLI-ReadOnlySession --policy-arns arn=arn:aws:iam::aws:policy/ReadOnlyAccess
}