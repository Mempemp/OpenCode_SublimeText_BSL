"""This module exports the OneScriptLint plugin class."""

import sublime
from SublimeLinter.lint import Linter, util

class OneScriptLint(Linter):
    """Provides an interface to OneScriptLint."""

    syntax = '1c'
    cmd = ('oscript -encoding=utf-8 -check @')
    regex = r'\{\S+\s+(?P<error>.*)\s\/\s.*:\s+(?P<line>\d+)\s+\/\s+(?P<message>.*)\}'
    error_stream = util.STREAM_BOTH
    comment_re = r'\s*//'

    def run(self, cmd, code):
        lintBSLFiles = sublime.load_settings('Language 1C (BSL).sublime-settings').get('lintBSLFiles')
        if not (self.filename.endswith('.bsl') and not lintBSLFiles):
            return self.communicate(cmd, code)
