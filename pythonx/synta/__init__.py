import subprocess
import vim
import os
import os.path
import re

_active_highlights = []


def build():
    filename = os.path.basename(vim.current.buffer.name)
    building = True
    if not filename.endswith("_test.go"):
        args = ["go-fast-build"]
        if not vim.vars['synta_use_go_fast_build']:
            args = ["go", "build"]
    else:
        building = False
        args = ["go", "test", "-c"]

    dirname = os.path.dirname(vim.current.buffer.name)
    cwd = os.getcwd()

    envs = None
    if os.path.exists(os.path.join(cwd, "AndroidManifest.xml")):
        envs = {
            "GOOS": "android",
            "GOARCH": "arm64",
            "CC": vim.vars['synta_android_toolchain'],
            "CXX": vim.vars['synta_android_toolchain'] + "++",
        }

        envs.update(os.environ)

        args += ["-buildmode=c-shared"]

    target = ""
    if dirname != cwd:
        if dirname.startswith(cwd):
            target = "." + dirname[len(cwd):]
        elif dirname.startswith("./") or dirname.startswith("/"):
            target = dirname
        else:
            target = "./" + dirname

    if target != "":
        args.append(target)

    target_recursive = ""
    if building and vim.vars['synta_go_build_recursive']:
        if target == "":
            target_recursive = "./..."
        else:
            if target.endswith("/"):
                target_recursive = target + "..."
            else:
                target_recursive = target + "/..."

    if target_recursive != "":
        args.append(target_recursive)

    build = subprocess.Popen(
        args,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        close_fds=True,
        env=envs,
    )

    lines = []

    _, stderr = build.communicate()
    lines = _filter_and_sort_errors(filename, stderr.split('\n'))

    if len(lines) > 0:
        vim.vars['go_errors'] = lines


def _filter_and_sort_errors(filename, lines):
    lines = list(filter(
        lambda line: not line.startswith('go: warning:') and \
            not line.endswith('matched no packages'),
        lines,
    ))

    # errors with current filename should be first
    def _sort_error(line):
        candidate = os.path.basename(line.split(':')[0])
        return int(candidate == filename)
    lines = sorted(lines, key=_sort_error, reverse=True)

    return lines


def _get_tags_file():
    return '/tmp/.synta.tags.' + vim.eval("expand('%:p')").replace('/', '_')


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

    command = "matchadd('{0}', '\%{2}l\%{3}c{1}', -1)".format(
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


def try_jump_to_error_identifier(contents):
    regexps = [
        'undefined: ([\w.]+)',
        'cannot use ([\w.]+)',
        'syntax error: unexpected ([\w.]+)',
    ]
    for regexp in regexps:
        matches = re.search(regexp, contents)
        if matches:
            identifier = matches.group(1)
            vim.command("call search('\<\V%s\m\>', 'cs')" % identifier)
            return True
