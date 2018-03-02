//////////////////////////////////////////////////////////////////////////
run("include/consoleFunction.js")

//////////////////////////////////////////////////////////////////////////
var includedserverFunction
if (!includedserverFunction) {
includedserverFunction = true

//////////////////////////////////////////////////////////////////////////
var __filename__ = "serverFunction.js"
debug("vvvvv "+__filename__)


//////////////////////////////////////////////////////////////////////////
function getNumTotalPlayers() {
	return server.getOnlinePlayers().size()
}

function getNumSurvivalPlayersInArray(a) {
	var n=0
	a.forEach(function(p) {
		try {
			if (p.getGameMode()==org.bukkit.GameMode.SURVIVAL) {
				n=n+1
			}
		}
		catch(e) { 
		}
	})
	return n
}

function getWinnerName() {
	// var name="沒有人"
	var name="\u6c92\u6709\u4eba"
	server.getOnlinePlayers().toArray().forEach(function(p) {
		// debug(p)
		try {
			// debug("try"+p.getGameMode())
			if (p.getGameMode()==org.bukkit.GameMode.SURVIVAL) {
				// debug(p.getDisplayName()+p.getGameMode())
				name=p.getDisplayName()
			}
			// debug("else")
		}
		catch(e) {
			// debug("catch")
		}
	})
	// debug("end")
	return name
}

function getNumSurvivalPlayersInTeam(t) {
	return getNumSurvivalPlayersInArray(t.getPlayers().toArray())
}

function getNumSurvivalPlayers() {
	return getNumSurvivalPlayersInArray(server.getOnlinePlayers().toArray())
}

function getTeams() {
	return server.getScoreboardManager().getMainScoreboard().getTeams().toArray()
}

function getScoreboard() {
	return server.getScoreboardManager().getMainScoreboard()
}

function getNumSurvivalTeams() {
	var n=0
	getTeams().forEach(function(t) {
		// debug(t.getDisplayName()+": "+getNumSurvivalPlayersInTeam(t))
		if (getNumSurvivalPlayersInTeam(t)>0) {
			n=n+1
		}
	})
	return n
}

function allowFriendlyFire() {
	getTeams().toArray().forEach(function(t) {
		if (getNumSurvivalPlayersInTeam(t)>0) {
			n=n+1
		}
	})
}

function getEntryObjectScore(entry,objective) {
	// var s=getScoreboard().getObjective(objective).getScore(entry).getScore()
	// debug("s=",s)
	// debug s
	// debug(objective+" "+getScoreboard().getObjective(objective).getScore(entry).getEntry())
	// debug(entry+" "+objective)
	return getScoreboard().getObjective(objective).getScore(entry).getScore()
}

// function sleep_ms(millis) {
    // var date = new Date();
    // var curDate = null;
    // do { curDate = new Date(); }
    // while(curDate-date < millis);
// }

// function sleep(sec) {
	// for (i = 0; i < sec; i++) { 
		// sleep_ms(1000)
	// }
// }

// var lastTimeStamp
// if (lastTimeStamp==null) { lastTimeStamp = new Date() }
// function isSecondsPassed(sec) {
	// var now = new Date();
	// if ( now.getTime() - lastTimeStamp.getTime() > 1000*sec ) {
		// lastTimeStamp = now
		// return true
	// }
	// return false
// }

function isSecondsPassed(h,sec) {
	if (h) {
		if ( h.lastTimeStamp==null) { 
			h.lastTimeStamp = new Date() 
			// debug(red+bold+"h.lastTimeStamp created")
			return true
		}
		var now = new Date();
		// var timePassed=now.getTime() - h.lastTimeStamp.getTime()
		// debug(green+bold+"timeDifference="+timePassed)
		if ( now.getTime() - h.lastTimeStamp.getTime() > 1000*sec ) {
			h.lastTimeStamp = now
			return true
		}
	}
	return false
}

function getTimePassed(h) {
	var timePassed = 0 
	if (h) {
		if ( h.lastTimeStamp==null) { 
			h.lastTimeStamp = new Date() 
			// debug(greed+bold+"h.lastTimeStamp created")
		}
		var now = new Date();
		timePassed = now.getTime() - h.lastTimeStamp.getTime()
		h.lastTimeStamp = now
		// debug(greed+bold+"timePassed=",timePassed)
	}
	return timePassed
}

function dumpScores(outputFunc) {
	getScoreboard().getEntries().toArray().forEach(function(e) {
		outputFunc("====="+e)
		getScoreboard().getObjectives().toArray().forEach(function(o) {
			var score=o.getScore(e).getScore()
			if (score!=0) {
			outputFunc(o.getName()+", "+o.getDisplayName()+", "+o.getCriteria()+", "+o.getDisplaySlot()+", "+score)
			}	
		})
	})
}

//////////////////////////////////////////////////////////////////////////
debug("^^^^^ "+__filename__)
}