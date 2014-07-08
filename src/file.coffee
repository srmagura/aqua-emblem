window._file = {}

_file.difficulty = {
    normal: {},
    hard: {}
}

class _file.File
    
    constructor: ->

    init: ->
        @fileState.init()


_file.fs = {}
class _file.FileState

class _file.fs.Prologue extends _file.FileState

class _file.fs.Chapter1 extends _file.FileState

    init: ->
        ui = new _cui.ChapterUI()
        ui.setChapter(new _chapters.Chapter1(ui))
        ui.startChapter()
