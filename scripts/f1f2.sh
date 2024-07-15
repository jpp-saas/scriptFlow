#! /usr/bin/env bash

set -e

ROOT_DIR=$(cd `dirname $0`/..; pwd)
FAKE_REPO=jpp-saas/tutoFlow

AUTO_REMOTE=false
REBASE_BEFORE_FINISH=false # true/false/-r

#----------------------------------------------------------------------
LOG_FILE=${ROOT_DIR}/$(basename $0).log
echo > ${LOG_FILE}

source $(dirname $0)/reset.sh
source $(dirname $0)/git.sh

#----------------------------------------------------------------------
cd ${ROOT_DIR}/..

initRepo
printState "init" noLog

git flow init -d &>> ${LOG_FILE}
git_push develop
printState "init flow" noLog

featureStart  F1
workOnFeature F1
featureStart  F2
workOnFeature F2
printState "after start/publish F1, F2" noLog

workOnFeature F1
git log --oneline --decorate --graph --all
workOnFeature F2
git log --oneline --decorate --graph --all

featureFinish F2
printState "F2 finished" noLog
relaseStart 1.0.0
featureFinish F1
printState "F1 finished" noLog


echo; echo "in develop not in 1.0.0"
git log --oneline --decorate --graph release/1.0.0..develop
releaseFinish 1.0.0

relaseStart   2.0.0
releaseFinish 2.0.0

git log --oneline --decorate --graph --all

echo; echo "only merges"
git log --oneline --decorate --graph --merges
echo; echo "in main not in develop"
git log --oneline --decorate --graph develop..main
echo; echo "in develop not in main"
git log --oneline --decorate --graph main..develop
