@setlocal enableextensions & cls & python -x "%~f0" %* & goto :EOF

import sys
import os

# def remove_directory(top):
	# uTop=unicode(top)
	# for root, dirs, files in os.walk(uTop, topdown=False):
		# for name in files:
			# try:
				# f = os.path.join(root, name)
				# os.system('takeown /f "' + f + '"')
				# os.remove(f)
			# except: pass
		# for name in dirs:
			# try:
				# d = os.path.join(root, name)
				# os.system('takeown /r /d Y /f "' + d + '"')
				# os.rmdir(d)
			# except: pass
	
	# try: os.rmdir(uTop)
	# except: pass


def delDirExceptLastOf(prefix,num,debug=0):
	import shutil

	#print os.listdir(prefix)
	dirs = []
	for dir in os.listdir(prefix):
		fulpath = os.path.join(prefix,dir)
		#print fulpath
		if os.path.isdir(fulpath):
			#print fulpath
			dirs.append(fulpath)
		#else:
		#	print 'not dir:',fulpath
	# print '-----', dirs	
	for dir in dirs[:-num]:
		# print 'deleting',dir
		#raw_input()
		if debug: 
			print "Selecting",dir
		else:
			print "Deleting",dir
			
			if sys.platform == 'win32': 
				# remove_directory(dir)
				os.system('rd /s /q "' + dir + '"')
				
				os.system('takeown /r /d Y /f "' + dir + '"')
				os.system('icacls "' + dir + '" /grant %USERNAME%:D /t')
				os.system('rd /s /q "' + dir + '"')
			else:
				try: shutil.rmtree(dir)
				except: 
					import traceback
					traceback.print_exc()
					print "Deleting",dir,"failed."

			
def main():
	#print sys.argv
	prefix = os.path.dirname(sys.argv[0])
	
	num = 3
	debug = 0
	if len(sys.argv) > 1:
		try:
			temp = int(sys.argv[1])
			#print temp
			if temp > 0: num = temp
			debug = int(sys.argv[2])
		except: pass

	# os.system('chcp 65001')	
		
	print "Cleanup Recycled Directory:",prefix,"Keeping dir of last",num,", Debug:",debug==1
		
	delDirExceptLastOf(prefix,num,debug)

	
if __name__ == '__main__':
	main()
