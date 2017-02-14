#!/usr/bin/env python
# -*- coding: utf-8 -*-
import subprocess, time

#Inits repo
def gitInit():
    cmd = 'git init'
    process = subprocess.Popen(["git", "init"], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    (out, error) = process.communicate()
    print (out,error)
    process.wait()
    return

#Sets the username and email
def gitSetUser(username, email):
    process = subprocess.Popen(["git", "config", "user.name", username], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    out = process.communicate()[0]
    #print (out)
    process.wait()
    process2 = subprocess.Popen(["git", "config", "user.email", email], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    out2 = process2.communicate()[0]
    process2.wait()
    return

#Adds new remote
#params, url is the url of the git repo and name is the name but for now its just origin
def gitAddRemote(url, name):
    process = subprocess.Popen(["git", "remote", "add", "origin", url], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    process.wait()
    return

#Sets new url to existing remote
def gitSetRemote(url):
    process = subprocess.Popen(["git", "remote", "set-url", "origin", url], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    process.wait()
    return

#Checks the remote name and url
#Returns the remote name and url as one string
def gitCheckRemote():
    out = subprocess.check_output(["git", "remote", "-v"], universal_newlines=True).strip()
    print(out)
    return out

#Checks if user or email exists.
#returns false if one of them is missing
#returns true if both are non-empty strings
def gitCheckUser():
    out = subprocess.check_output(["git", "config", "user.name"], universal_newlines=True).strip()
    out2 = subprocess.check_output(["git", "config", "user.email"], universal_newlines=True).strip()
    #out = process.communicate()[0]
    print(out, out2)
    if(out and out2):
        return True
    else:
        return False

#Checks the git status
#Returns three lists which contains added files, untracked files and modified files
#Returns False if git init hasnt been donw
def gitStatus(path):
    addedFiles = []
    untrackedFiles = []
    modifiedFiles = []
    try:
        out = subprocess.check_output(["git", "status", "--porcelain"], cwd=path, universal_newlines=True).strip()
    except subprocess.CalledProcessError as e:
        return False
    allfiles = out.split("\n")
    for f in allfiles:
        if f[0] == "A":
            if f[1] == "M":
                modifiedFiles.append(f.replace(" ", "")[2:])

            f = f.replace(" ", "")
            f = f[2:]
            addedFiles.append(f)
        elif f[0] == "?":
            f = f.replace(" ", "")
            f = f[2:]
            untrackedFiles.append(f)
        elif f[1] == "M":
            f = f.replace(" ", "")
            f = f[2:]
            modifiedFiles.append(f)
        print("Added : ", addedFiles, "\nUntracked: ", untrackedFiles, "\nModified: ", modifiedFiles)
        return addedFiles, untrackedFiles, modifiedFiles

#Creates new branch
def gitBranch(branchName):
    process = subprocess.Popen(["git", "branch", branchName], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    process.wait()
    return

#Returns branches in list. Current branch starts with *.. for example *master
def gitListBranches():
    out = subprocess.check_output(["git", "branch"], universal_newlines=True)
    allBranches = out.split("\n")
    del allBranches[-1]
    for i in range(len(allBranches)):
        allBranches[i] = allBranches[i].replace(" ", "")
    return allBranches

def gitCheckout(branchName):
    process = subprocess.Popen(["git", "checkout", branchName], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    process.communicate()
    process.wait()

#Adds all the files
#param List containing all the files user wants to add
def gitAdd(filelist):
    for f in filelist:
        process = subprocess.Popen(["git", "add", f], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
        process.wait()
    return

#Commits the added files
#param commit message
def gitCommit(msg):
    process = subprocess.Popen(["git", "commit", "-m", msg], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    process.wait()
    return

#Push.....
def gitPush(passwd):
    process = subprocess.Popen(["git", "push", "origin", "master"], stdout = subprocess.PIPE, stderr = subprocess.PIPE, stdin = subprocess.PIPE)
    #time.sleep(1)
    #process.stdin.write(b'asd\n')
    process.stdout.readline()
    #time.sleep(1)
    #process.stdin.write(b'asd\n')
    #process.stdin.flush()
    (out, error) = process.communicate(b'asd\n')
    print (out, error)
    process.wait()
    return
