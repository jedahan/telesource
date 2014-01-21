exec = require("child_process").exec

#  GET /
exports.main = (req, res) ->
  res.render "main.html"

#  GET /input
exports.input = (req, res) ->
  message = req.query.message
  console.log message
  command = "echo tmsis | sudo OpenBTSCLI | grep -v TMSI | awk '{print $2}' | grep -v '^$' | grep -E \"[0-9]+\""
  child = exec(command, (error, stdout, stderr) ->
    for sms in stdout.split "\n" when sms isnt ""
      newCommand = "echo sendsms " + sms + " 0 " + message + " | sudo OpenBTSCLI"
      console.log newCommand
      newChild = exec(newCommand, (error, stdout, stderr) ->
        console.log "child exec error: " + error  if error?
      )
  )
  res.redirect "/"

#  GET /tmsis
exports.tmsis = (req, res) ->
  command = "echo tmsis | sudo OpenBTSCLI | grep -v TMSI | awk '{print $2}' | grep -v '^$' | grep -E \"[0-9]+\""
  console.log command
  child = exec(command, (error, stdout, stderr) ->
    console.log "IMSI NUMBERS"
    res.send stdout
  )

#  GET /numbers
exports.numbers = (req, res) ->
  command = 'echo .dump dialdata_table | sqlite3 /var/lib/asterisk/sqlite3dir/sqlite3.db | grep VALUES | awk \'{print $4}\' | cut -d"\'" -f2,4'
  console.log command
  child = exec(command, (error, stdout, stderr) ->
    console.log "PHONE NUMBERS"
    res.send stdout
  )