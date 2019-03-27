import os
import hashlib
from collections import defaultdict

d = defaultdict(list)

BUFSIZE = 524288 # 512K
def hashsum(f):
    statinfo = os.stat(f) 
    if statinfo.st_size < 524288:
        return hashlib.md5(open(f, 'rb').read()).hexdigest()
    else: 
        md5sum = hashlib.md5()
        with open(f, 'rb') as infile:
            while True:
                data = infile.read(BUFSIZE)
                if not data:
                    break
                md5sum.update(data)
        return md5sum.hexdigest()
        

dir1 = '/home/ionadmin/NAS/backup-sequencers/Proton/results'
dir2 = '/mnt/nfs/Proton/results'

def get_all(directory):
    global d
    res = []
    for root, subd, files in os.walk(directory):
        for f in files:
            fullname = os.path.join(root, f)
            basename = fullname[len(directory):]
            d[basename].append((fullname, hashsum(fullname)))
            res.append(basename)
    return res
            

#rdir[os.path.join(root, f)] = hashsum(os.path.join(root, f))
#    return rdir
        
nas = get_all(dir1)
print('done {} = {}'.format(dir1, len(nas)))
nfs = get_all(dir2)
print('done {} = {}'.format(dir2, len(nfs)))

result = defaultdict(list)

for basename, list_ in d.items():
    refhash = list_[0][1]
    if all([t[1] == refhash for t in list_]):
        continue
    else:
        result[basename] = list_

print('result: {}'.format(len(result)))

for k, v in result.items():
    print(k, v)


        
    


