# Webpage optimize

The webpage will be minify html then use gzip to compress

## Minify html

The [minify.py](minify.py) script use to minify the index.html file include the javascript.

It's requirement the [minify-html](https://pypi.org/project/minify-html/) install on global of python environment.

```
pip install minify-html
```

## Generate

Run script [generate.bat](generate.bat) by `command Prompt` inside folder of `Webpage`

```
.\generate.bat
```

The final data will be copy to `spiffs` the folder should be exist to make sure there no error while generating.