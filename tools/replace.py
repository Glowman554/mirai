import sys, subprocess

out = subprocess.Popen(["./debug/enc", "string", sys.argv[1]], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
stdout,stderr = out.communicate()
xor = stdout.decode().replace("\n", " ").replace("\\", "\\").split(" ")[5]
length = stdout.decode().replace("\n", " ").replace("\\", "\\").split(" ")[1]
string = f"\"{xor}\", {length}"

print(sys.argv)
print(stdout)
	
with open("bot/table.c",) as f:
	tmp = f.read()
	tmp = tmp.replace("\"\\x41\\x4C\\x41\\x0C\\x41\\x4A\\x43\\x4C\\x45\\x47\\x4F\\x47\\x0C\\x41\\x4D\\x4F\\x22\", 30", string)
with open("bot/table.c", "w") as f:
	f.write(tmp)
	f.flush()