window._file = {}
_file.fs = {}

_file.difficulty = {
    normal: {statBonus: 1, expMultiplier: 4/3},
    hard: {statBonus: 0, expMultiplier: 1}
}

class _file.File
    
    constructor: ->

    setFileState: (fsCls) ->
        @fileState = new fsCls(this)

    init: ->
        @fileState.init()
        
    pickle: ->
        return 'cucumber'
        return {
            'fsCls': @fileState.constructor,
            'playerTeam': @playerTeam.pickle()
        }


class _file.FileState

    constructor: (@file) ->

    chapterComplete: =>
        @ui.destroy()
        @ui = new _sui.StartUI(@file)
        @ui.init({message: @ui.messages.chapterComplete})


_file.createNewFile = (difficulty) ->
    file = new _file.File()
    file.difficulty = difficulty
    file.setFileState(_file.fs.Chapter1)
    
    playerUnits = [
        new _uclass.special.Ace(),
        new _uclass.special.Arrow(),
        new _uclass.special.Luciana(),
        new _uclass.special.Kenji(),
    ]
    
    file.playerTeam = new _team.PlayerTeam(playerUnits)
    return file
