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


#Enable tab auto-completion for aws commands in MacOS
For zsh

1. Install awscli
> brew install awscli

2. Enable auto completion
> autoload -Uz compinit
> compinit
> autoload -Uz bashcompinit
> bashcompinit
> complete -C '/usr/local/bin/aws_completer' aws

3. Add to ~/.zshrc to make the changes permanent
> echo 'complete -C "/usr/local/bin/aws_completer" aws' >> ~/.zshrc

4. Source the file to apple changes
> source ~/.zshrc
