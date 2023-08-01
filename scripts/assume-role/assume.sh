
function assumerole() {

    local role sts_credentials
    role="$(aws iam list-roles --query 'Roles[].[Arn]' --output text | fzf)"
    # TODO: add preview(attached policies)

    sts_credentials=$(aws sts assume-role --role-arn "$role" --role-session-name AWSCLI-Session)

    # Updating AWS environment variables
    export AWS_ACCESS_KEY_ID=$(echo ${sts_credentials} | jq -r '.Credentials.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo ${sts_credentials} | jq -r '.Credentials.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo ${sts_credentials} | jq -r '.Credentials.SessionToken')
    echo "Assumed role: $role"

}
