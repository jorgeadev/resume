# Welcome Students to Sunday Tech Study!

This project is designed to publish your web development code on a public facing website, https://coding.wan-scape.com.

## Getting started

Clone this project/repo to your local computer.

```
git clone https://gitlab.wan-scape.com/rburns/students.git
```

Create a branch of the project.

```
cd students
git checkout -b <branch-name>
```


## Add your files to your new branch, then push them to trigger public facing pipeline

Edit line 5 in main.yml file to include your new branch name.

```
ex. 
  vars:
    branch: david # <= Enter Your Branch Name
```

Add unchecked files your branch

```
git add <each file name>
```

Commit them to the branch.

```
git commit -m "<Commit Comment>"
```

Push your branch to the remote project

```
git push
```

## Monitor your pipeline job in GitLab

https://gitlab.wan-scape.com/rburns/students/-/pipelines


## Access Your Code Publicly

https://coding.wan-scape.com/branch-name/