#Configured through AWS IAM Identity Center

1. Download AWS CLI
2. Run AWS sso configure
> aws configure sso
> SSO session name (Recommended): <>
> SSO start URL [None]: <>
> SSO region [None]: <>
> SSO registration scopes [sso:account:access]: [Enter]

3. Create Profile name and details
Using the account ID <>
The only role available to you is: AdministratorAccess
Using the role name "AdministratorAccess"
CLI default client Region [None]: <>
CLI default output format [None]: <>
CLI profile name [AdministratorAccess-<account id>]: <>

4. Profile details are available at:
~/.aws/config

5. If logged out, use:
> aws sso login