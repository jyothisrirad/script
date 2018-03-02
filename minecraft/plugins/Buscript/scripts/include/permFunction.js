//////////////////////////////////////////////////////////////////////////
run("include/consoleFunction.js")

//////////////////////////////////////////////////////////////////////////
var includedpermFunction
if (!includedpermFunction) {
includedpermFunction = true

//////////////////////////////////////////////////////////////////////////
var __filename__ = "permFunction.js"
debug("vvvvv "+__filename__)


function timedPermAdd(role,perm,world,sec) {
	command("pex "+role+" timed add "+perm+" "+sec+" "+world)
	// debug("在世界"+world+"給予"+role+"的臨時權限"+perm+" "+sec+"秒")
	debug("\u5728\u4e16\u754c"+world+"\u7d66\u4e88"+role+"\u7684\u81e8\u6642\u6b0a\u9650"+perm+" "+sec+"\u79d2")
}

function timedPermRemove(role,perm,world) {
	// debug("在世界"+world+"移除"+role+"的臨時權限"+perm)
	debug("\u5728\u4e16\u754c"+world+"\u79fb\u9664"+role+"\u7684\u81e8\u6642\u6b0a\u9650"+perm)
	command("pex "+role+" timed remove "+perm+" "+world)
}

function disableFly() {
	server.getOnlinePlayers().toArray().forEach(function(p) {
		// debug(p.getDisplayName()+" getAllowFlight="+red+bold+p.getAllowFlight())
		if (p.getAllowFlight()) {
			debug(p.getDisplayName()+" setAllowFlight=false")
			p.setAllowFlight(false)
		}
		// debug(p.getDisplayName()+" isFlying= "+red+bold+p.isFlying())
	})
}

//////////////////////////////////////////////////////////////////////////
debug("^^^^^ "+__filename__)
}