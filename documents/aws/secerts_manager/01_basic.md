Secret Manager:

example:

- API's Key
- Password
- Imp env
- Clients details

CLI command:
aws secretsmanager get-secret-value \
 --secret-id my-app-secret --version-stage AWSPREVIOUS \
 --region us-east-1

aws secretsmanager get-secret-value --secret-id my-app-secret --version-id fb86a529-9dc5-46a9-a426-b34db249a933 --region us-east-1
