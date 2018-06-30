# bash-utils

some utils for bash script.

# intro

I always use the bash as my devops script, while it's boring to write the condition judgement/echo statement/exit.

So, I want to make the bash script short and clear.

I have collected some useful function into this repo, which save me a lot of time in past few years.

Just source the `utils.sh` and write the expression calling the functions.

I can just focus on the logical, not the bash syntax and expression

# example

```bash
echo_separator

echo_step "1. begin to validate the params"

if_empty_then_exit "$1" "the first param required!"
FILE="${1}"
if_path_not_exist_then_exit "${FILE}" "file not exist"

VALUE=$(if_empty_return_default "${2}" 123)
```

# usage


```bash
curl https://raw.githubusercontent.com/wklken/bash-utils/master/utils.sh > utils.sh && curl https://raw.githubusercontent.com/wklken/bash-utils/master/template.sh > run.sh
```

# Donation

You can Buy me a coffee:)  [link](http://www.wklken.me/pages/donation.html)


# change log

2018-06-30 add some useful function from [pure-bash-bible](https://github.com/dylanaraps/pure-bash-bible)

------------------------
------------------------

wklken

Github: https://github.com/wklken

Blog: [http://www.wklken.me](http://www.wklken.me)
