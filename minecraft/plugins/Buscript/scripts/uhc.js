//////////////////////////////////////////////////////////////////////////
run("include/consoleFunction.js")
run("include/serverFunction.js")
run("include/permFunction.js")
run("include/uhcContants.js")

//////////////////////////////////////////////////////////////////////////
var __filename__ = "uhc.js"
debug("vvvvv "+__filename__)

//////////////////////////////////////////////////////////////////////////
// var autouhc_timer
// if (autouhc_timer==null) { autouhc_timer = {} }
// debug("autouhc_timer getTimePassed="+getTimePassed(autouhc_timer))

//////////////////////////////////////////////////////////////////////////
var message1hr_timer
if (message1hr_timer==null) { message1hr_timer = {} }
var message1hr_step
if (message1hr_step==null) { message1hr_step = 0 }
function message1hr() {
	debug("message1hr_step="+message1hr_step)
	if (!isSecondsPassed(message1hr_timer,5)) return
	command("gamerule sendCommandFeedback false")
	TEXT_ACTIONBAR=bold+"8\u9ede\u958b\u59cb\u5206\u968a\uff0c\u8acb\u9032\u5165RC\u804a\u5929\u5ba4:"+blue+bold+"27685743"
	TEXT_TITLE=aqua+bold+italian+"UHC\u03b8\u76c31\u5c0f\u6642\u6bd4\u8cfd\u898f\u5247"
	switch(message1hr_step) {
		case 0:
			actionbar(TEXT_ACTIONBAR)
			subtitle(bold+"\u7279\u6b8a\u88dd\u5099"+yellow+"\u9644\u9b54\u9435\u9774"+off+bold+"\u6bcf\u500b\u6210\u5c31\u5347\u7d1a\u901f\u5ea6\u529b\u91cf\u8840\u91cf")
			title(TEXT_TITLE)
			break;
		case 1:
			actionbar(TEXT_ACTIONBAR)
			b=getEntryObjectScore(EntrySystem,ObjectTimeMapShrink)
			e=getEntryObjectScore(EntrySystem,ObjectTimeMapShrinkDuration)
			be=b+e
			d=getEntryObjectScore(EntryMap,ObjectMapStopSize)
			subtitle(red+bold+b+off+bold+"\u5206\u5730\u5716\u958b\u59cb\u6f38\u7e2e"+red+bold+be+off+bold+"\u5206\u5730\u5716\u7e2e\u81f3"+red+d)
			title(TEXT_TITLE)
			break;
		case 2:
			actionbar(TEXT_ACTIONBAR)
			g=getEntryObjectScore(EntrySystem,ObjectTimeStopDaylightCycle)
			subtitle(red+bold+g+off+bold+"\u5206\u6c38\u9060\u767d\u5929")
			title(TEXT_TITLE)
			break;
		case 3:
			actionbar(TEXT_ACTIONBAR)
			j=getEntryObjectScore(EntrySystem,ObjectTimeShowNametag)
			subtitle(red+bold+j+off+bold+"\u5206\u73a9\u5bb6\u540d\u689d\u986f\u793a")
			title(TEXT_TITLE)
			break;
		case 4:
			actionbar(TEXT_ACTIONBAR)
			l=getEntryObjectScore(EntrySystem,ObjectTimeGlowing)
			subtitle(red+bold+l+off+bold+"\u5206\u73a9\u5bb6\u767c\u51495\u5206\u9418")
			title(TEXT_TITLE)
			break;
		case 5:
			actionbar(TEXT_ACTIONBAR)
			ClearTime=getEntryObjectScore(EntrySystem,ObjectTimeClearMob)
			subtitle(red+bold+ClearTime+off+bold+"\u5206\u6e05\u9664\u602a\u7269")
			title(TEXT_TITLE)
			break;
		case 6:
			actionbar(TEXT_ACTIONBAR)
			FinalTime=getEntryObjectScore(EntrySystem,ObjectTimeFinalBattle)
			subtitle(red+bold+FinalTime+off+bold+"\u5206\u50b3\u9001\u5230\u6700\u5f8c\u6230\u5834")
			title(TEXT_TITLE)
			//break;
		default:
			printWithPerm("minecraft.command.gamemode","\u4f60\u53ef\u4ee5\u9ede\u9078\u300c\u6838\u5fc3\u9078\u9805\u300d\u4f86\u8a2d\u5b9a\u898f\u5247\u3001\u5206\u968a\u3001\u548c\u958b\u59cb\u904a\u6232")		
			message1hr_step=0
			return true
	}
	message1hr_step=message1hr_step+1
	return false
}

//////////////////////////////////////////////////////////////////////////
var mcscores_timer
if (mcscores_timer==null) { mcscores_timer = {} }
var mcscores_steps
if (mcscores_steps==null) { mcscores_steps = 0 }
function mcscores(sec) {
	debug("mcscores_steps="+mcscores_steps)
	if (!isSecondsPassed(mcscores_timer,sec)) return
	command("gamerule sendCommandFeedback false")
	switch(mcscores_steps) {
		case 0:
			command("scoreboard objectives setdisplay sidebar FinalKill")
			// title("殺人數排行=>")
			title("\u6bba\u4eba\u6578\u6392\u884c=>")
			break;
		case 1:
			command("scoreboard objectives setdisplay sidebar FinalEntity")
			// title("殺怪數排行=>")
			title("\u6bba\u602a\u6578\u6392\u884c=>")
			break;
		case 2:
			command("scoreboard objectives setdisplay sidebar FinalDiamond")
			// title("挖掘鑽石礦排行=>")
			title("\u6316\u6398\u947d\u77f3\u7926\u6392\u884c=>")
			break;
		case 3:
			command("scoreboard objectives setdisplay sidebar FinalGold")
			// title("挖掘黃金礦排行=>")
			title("\u6316\u6398\u9ec3\u91d1\u7926\u6392\u884c=>")
			break;
		case 4:
			command("scoreboard objectives setdisplay sidebar FinalStone")
			// title("挖掘石頭排行=>")
			title("\u6316\u6398\u77f3\u982d\u6392\u884c=>")
			break;
		case 5:
			command("scoreboard objectives setdisplay sidebar FinalEat")
			// title("吃金蘋果數量排行=>")
			title("\u5403\u91d1\u860b\u679c\u6578\u91cf\u6392\u884c=>")
			// break;
		default:
			// command("scoreboard objectives setdisplay sidebar List")
			mcscores_steps=0
			return true
	}
	mcscores_steps=mcscores_steps+1
	return false
}

//////////////////////////////////////////////////////////////////////////
var end_message_timer
if (end_message_timer==null) { end_message_timer = {} }
var end_message_steps
if (end_message_steps==null) { end_message_steps = 0 }
function end_message() {
	debug("end_message_steps="+end_message_steps)
	if (!isSecondsPassed(end_message_timer,5)) return
	command("gamerule sendCommandFeedback false")
	playsound("block.note.hat")
	TEXT_ACTIONBAR=bold+"RC\u804a\u5929\u5ba4:"+aqua+bold+"27685743"
	TEXT_SUBTITLE=bold+"\u60f3\u53c3\u52a0\u8cfd\u5f8c\u8cfd\u7684\u73a9\u5bb6\uff0c\u8acb\u56de\u5230\u4f3a\u670d\u5668\u5927\u5ef3"
	TEXT_TITLE=aqua+bold+italian+"UHC\u03b8\u76c3\u5df2\u7d93\u7d50\u675f"
	TEXT_TITLE2=aqua+bold+italian+"UHC\u4f3a\u670d\u5668\u5373\u5c07\u95dc\u9589"
	switch(end_message_steps) {
		case 0:
			actionbar(TEXT_ACTIONBAR)
			subtitle(TEXT_SUBTITLE)
			title(TEXT_TITLE+"...3")
			break;
		case 1:
			actionbar(TEXT_ACTIONBAR)
			subtitle(TEXT_SUBTITLE)
			title(TEXT_TITLE+"...2")
			break;
		case 2:
			actionbar(TEXT_ACTIONBAR)
			subtitle(TEXT_SUBTITLE)
			title(TEXT_TITLE+"...1")
			break;
		case 3:
			actionbar(TEXT_ACTIONBAR)
			title(TEXT_TITLE2+"...3")
			break;
		case 4:
			actionbar(TEXT_ACTIONBAR)
			title(TEXT_TITLE2+"...2")
			break;
		case 5:
			actionbar(TEXT_ACTIONBAR)
			title(TEXT_TITLE2+"...1")
			// break;
		default:
			end_message_steps=0
			return true
	}
	end_message_steps=end_message_steps+1
	return false
}

//////////////////////////////////////////////////////////////////////////
var ending_timer
if (ending_timer==null) { ending_timer = {} }
var ending_step
if (ending_step==null) { ending_step = 0 }
function ending() {
	debug("ending_step="+ending_step)
	if (!isSecondsPassed(ending_timer,5)) return
	command("gamerule sendCommandFeedback false")
	switch(ending_step) {
		case 0:
		case 1:
		case 2:
			title(gold+bold+"\u6700\u5f8c\u8d0f\u5bb6\u662f"+aqua+bold+getWinnerName()+gold+bold+" \u904a\u6232\u7d50\u675f!")
			ending_step=ending_step+1	
			break;
		case 3:
		case 4:
			if ( mcscores(3) )
				ending_step=ending_step+1	
			break;
		case 5:
			if ( end_message() )
				ending_step=ending_step+1	
			break;
		case 6:
			command("stop")
			ending_step=ending_step+1	
			break;
		default:
			ending_step=0
			return true
	}
	return false
}

//////////////////////////////////////////////////////////////////////////
var granted
if (granted==null) { granted = false }
function timedPermAddOnce(role,perm,world,sec) {
	if (granted) return
	granted = true
	
	timedPermAdd(role,perm,world,sec)
}

function timedPermRemoveOnce(role,perm,world) {
	if (!granted) return
	granted = false
	
	timedPermRemove(role,perm,world)
}

//////////////////////////////////////////////////////////////////////////
// var disableFlyFlag
// if (disableFlyFlag==null) { disableFlyFlag = false }
// function disableFlyStart() {
	// if (disableFlyFlag) return
	// disableFlyFlag = true
	// run("subscript/disableFly.js")
// }

// function disableFlyStop() {
	// disableFlyFlag = false
// }

//////////////////////////////////////////////////////////////////////////
// print(getScoreboard().getObjective(org.bukkit.scoreboard.DisplaySlot.SIDEBAR).getDisplayName())
// print("running")
// getScoreboard().getObjectives().toArray().forEach(function(o) {
	// print(o.getDisplayName()+" in "+o.getDisplaySlot())
// })
// print(getScoreboard().getObjective("List").getDisplayName())
// getScoreboard().getObjective(org.bukkit.scoreboard.DisplaySlot.SIDEBAR).getDisplaySlot().values().forEach(function(v) {
		// print(v)
	// })
// print("target="+target)
// print("server="+server)

// print("plugin="+plugin)
// print("plugin.getConfig="+plugin.getConfig())
// print("plugin.getDataFolder="+plugin.getDataFolder())
// print("plugin.getDescription="+plugin.getDescription())
// print("plugin.getLogger="+plugin.getLogger())
// print("plugin.getName="+plugin.getName())
// print("plugin.getPluginLoader="+plugin.getPluginLoader())
// print("plugin.getServer="+plugin.getServer())

// print("metaData="+metaData)
// print("metaData="+metaData)
// metaData.put("a",new Date() )
// print("metaData="+metaData)
// print("metaData.size="+metaData.size())
	
// t = {}
// print("t="+t)
// t.a= new Date() 
// print("t="+t.a)

//////////////////////////////////////////////////////////////////////////
// dumpScores(print)
var s=getEntryObjectScore(EntrySystem,ObjectGameStarted)
// debug(ObjectGameStarted+"="+s)
// debug("在線人數="+getNumTotalPlayers())
// debug("\u5728\u7dda\u4eba\u6578="+getNumTotalPlayers())
// debug("剩餘人數="+getNumSurvivalPlayers())
// debug("\u5269\u9918\u4eba\u6578="+getNumSurvivalPlayers())
if ( s==0 ) {
	// timedPermAddOnce("group vip","minecraft.command.gamemode","AutoUHC",604800)
	if (getNumTotalPlayers()>=1) {
		message1hr()
		// disableFlyStart()
		disableFly()
	}
} else if (s==1) {
	// timedPermRemoveOnce("group vip","minecraft.command.gamemode","AutoUHC")
	// disableFlyStop()
	// debug("S="+s+" 剩餘人數="+getNumSurvivalPlayers())
	debug("S="+s+" \u5269\u9918\u4eba\u6578="+getNumSurvivalPlayers())
	// debug("S="+s+" 剩餘隊伍數="+getNumSurvivalTeams())
	debug("S="+s+" \u5269\u9918\u968a\u4f0d\u6578="+getNumSurvivalTeams())
	if (getNumSurvivalTeams()==1) {
		if (getNumSurvivalPlayers()>1) {
			getTeams().forEach(function(t) {
				if (getNumSurvivalPlayersInTeam(t) > 1) {
					if (!t.allowFriendlyFire()) {
						t.setAllowFriendlyFire(true)
						// subtitle("看看誰是最後贏家 戰到最後一人吧！")
						subtitle(gold+bold+"\u770b\u770b\u8ab0\u662f\u6700\u5f8c\u8d0f\u5bb6 \u6230\u5230\u6700\u5f8c\u4e00\u4eba\u5427\uff01")
						// title(t.getDisplayName()+"隊: 同隊傷害開啟")
						title(t.getDisplayName()+red+bold+"\u968a: \u540c\u968a\u50b7\u5bb3\u958b\u555f")
					}
				}
			})
		} else {
			ending()
		}
	}
	if (getNumTotalPlayers()==0) {
		// print(red+"全部玩家已經離場，伺服器關閉")
		// print(red+"\u5168\u90e8\u73a9\u5bb6\u5df2\u7d93\u96e2\u5834\uff0c\u4f3a\u670d\u5668\u95dc\u9589")
		// command("stop")
	}
}

//////////////////////////////////////////////////////////////////////////
runLater("uhc.js", "5s")

//////////////////////////////////////////////////////////////////////////
debug("^^^^^ "+__filename__)