# myenv
Simple environment variable manager on Windows.

# Install
```
git clone https://github.com/yeoupooh/myenv.git
```

# Configure
1. Add installed folder to PATH environment variable. e.g. d:\Apps\myenv
1. Edit _set.myenv.bat. (you can start by copying _sset.myenv.bat.sample.)
```
@echo off

set MYENV_HOME=d:\Apps\myenv
```
3. Backup your clean environment. This will backup your PATH variables.
```
myenv init
```


# Add your environments
1. Go to env folder under myenv installed folder.
2. Create _env.(your env).set.bat and _env.(your env).unset.bat file.

e.g. _env.python.set.bat
```
@echo off

set MINICONDA=d:\Apps\Miniconda3
set PATH=%PATH%;%MINICONDA%;%MINICONDA%\Scripts
```

e.g. _env.python.unset.bat
```
@echo off

set MINICONDA=
```

# Change environment
```
myenv set (your env)
```

e.g.
```
myenv set python
```

# Unset ennvironment
```
myenv unset (your env)
```

e.g.
```
myenv unset python
```

# Revert environment
This will revert with your initial environment
```
myenv revert
```
