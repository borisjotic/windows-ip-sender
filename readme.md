# Windows IP Sender

Widnows scheduled job that tracks changes of your ip address and when change occurs sends mail. Sheduled job is trigered on system startup.

# How it works

Scheduled job executes PowerShell script (`rdp.ps1`) which checks public ip address (using [ipify](https://github.com/rdegges/ipify-api) api) and compares it with log file with all previous ip addresses (`iplog.csv`) if ip address is diferent than last inserted e-mail is sent, otherwise new row is inserted to `iplog.csf` file with ip address and date.

# License

MIT