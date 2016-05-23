import subprocess
import vim
import os
import os.path

_active_highlights = []

def _get_tags_file():
    return vim.eval("expand('%:p:h')") + "/.tags_" + vim.eval("expand('%:t:r')")


def highlight_tags():
    tags_file = _get_tags_file()
    if not os.path.exists(tags_file):
        generate_tags()

    tags = []

    try:
        with open(tags_file, 'r') as tags_data:
            tags = tags_data.readlines()
    except:
        pass

    _cleanup()

    for tag in tags:
        _parse_tag(tag.split("\t"))

def _parse_tag(values):
    if len(values) < 5:
        return

    tag_name = values[0]
    tag_type = values[3]

    if tag_type == "x":
        _vim_matchadd(_parse_tag_cursor(values), tag_name, "goReceiver")

def _parse_tag_cursor(options):
    (line, column) = (None, None)
    for option in options:
        parts = option.strip().split(":")
        if len(parts) <  2:
            continue

        (name, value) = parts
        if name == "column":
            column = value
        elif name == "line":
            line = value
    return (line, column)



def generate_tags():
    input_file = vim.eval("expand('%:p')")
    output_file = _get_tags_file()

    with open(os.devnull, "wb") as devnull:
        try:
            subprocess.call(
                ["gotags", "-f", output_file, "-sort=false", input_file],
                stdout=devnull, stderr=devnull,
            )
        except:
            pass


def _vim_matchadd(cursor, string, group):
    global _active_highlights

    command = "matchadd('{0}', '\%{2}l\%{3}c{1}')".format(
        group,
        string,
        cursor[0], cursor[1],
    )

    match_id = vim.eval(command)

    _active_highlights.append(match_id)


def _cleanup():
    global _active_highlights

    for match_id in _active_highlights:
        try:
            vim.eval('matchdelete({})'.format(match_id))
        except:
            pass

    _active_highlights = []
