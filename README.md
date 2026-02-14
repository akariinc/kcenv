# kcenv
If you are a developer in use with Mac OS, store secure data on legacy Key Chain Access and export them to environmental variable without storing them on a regular file (ex .env file)


## Installation

Copy paste code written to `kcenv.sh` to `~/.zprofile`.


## Get Started

When your project `my_project` needs these environmental variable

```
export AWS_ACCESS_KEY_ID=xxxxxxxx
export AWS_SECRET_ACCESSS_KEY=yyyyyyy
export AWS_REGION=zzzzzzz
export SLACK_WEBHOOK_URL=aaaaaaaa
```

write them to temporal file `my_project_cred`

to encrypt and store them to your key chain with a name `my_project`

```shell
envkc my_project my_project_cred
```

then, you can export anytime you want from safe place.
```shell
kcenv my_project
```

if you are done with storing, do not forget to remove the temporal file.
```shell
rm my_project_cred
```

## Modify stored set

To modify stored set of environmental variables, simple export them to a file

```shell
kcenv my_project > my_project_cred
```
then edit the `my_project_cred` file and restore

```shell
envkc my_project my_project_cred
```
now remove the temporal file.
```shell
rm my_project_cred
```









