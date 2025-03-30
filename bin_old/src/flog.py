# ~ expansion doesnt work
import subprocess
nvim = subprocess.getoutput("fd --follow --extension log . /home/f1/.local/share/nvim")
home_logs = subprocess.getoutput("fd --follow --extension log . /home/f1/logs")
qemu_logs = subprocess.getoutput("fd --follow --extension log . /var/log/libvirt/qemu")
logs = nvim + "\n" + home_logs + "\n" + qemu_logs + "\n/home/f1/.local/share/qtile/qtile.log" 

selection = subprocess.run(['fzf', '--exit-0'], stdout=subprocess.PIPE, input=logs.encode('utf-8')).stdout.decode('utf-8')
print(selection)
#subprocess.run(['tail', '-f', selection], stdout=subprocess.PIPE)
