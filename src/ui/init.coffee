window.init = ->
    return doChapter()
    
    ui = new _sui.StartUI()
    ui.init()
    
    
doChapter = ->
    #file = _file.File.unpickle('{"difficultyStr":"hard","fsCls":"Chapter3","playerTeam":[{"constructor":"Ace","level":6,"exp":0.6100000000000003,"inventory":[{"constructor":"IronSword"},{"constructor":"SteelAxe","uses":30}]},{"constructor":"Arrow","level":5,"exp":0.9700000000000003,"inventory":[{"constructor":"KillerBow","uses":17},{"constructor":"IronBow"},{"constructor":"SteelBow","uses":30}]},{"constructor":"Luciana","level":6,"exp":0.08999999999999986,"inventory":[{"constructor":"IronLance"},{"constructor":"SteelLance","uses":29},{"constructor":"SteelSword","uses":30},{"constructor":"BraveLance","uses":30}]},{"constructor":"Kenji","level":6,"exp":0.2600000000000001,"inventory":[{"constructor":"IronAxe"},{"constructor":"HandAxe","uses":18}]}]}')
    #file = _file.File.unpickle(localStorage.getItem('file'))
    file = _file.createNewFile('normal')
    
    ui = new _cui.ChapterUI(file)
    ui.setConfirmUnload(false)
    ui.setChapter(_chapters.Chapter1)
    ui.startChapter((->), true)
