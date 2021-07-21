# How to create a AWS Profile

1. Create credentians file under ~/.aws folder
touch ~/.aws/credentials

Make sure you have below entry

```
[<profile Name>]
aws_access_key_id = <>
aws_secret_access_key = <>
```

2. Create config file under ~/.aws folder
touch ~/.aws/config

Make sure you have below entry

```
[default]
region = us-east-1
output = json

[profile profile-name]
region = us-east-1
output = json
```

## How to switch profiles Or Make a default profile for the session

```
export AWS_PROFILE=<profile-name>
```
