#! /usr/bin/env bash

set -e

ROOT_DIR=$(cd `dirname $0`/..; pwd)
FAKE_REPO=jpp-saas/tutoFlow

AUTO_REMOTE=false
PRUNE_ALL=true
REBASE_BEFORE_FINISH=false # true/false/-r

#----------------------------------------------------------------------
declare -A COUNTERS
LOG_FILE=${ROOT_DIR}/$(basename $0).log
echo > ${LOG_FILE}#

source $(dirname $0)/reset.sh

function printState {
  message="$1"
  echo
  echo "<<<<<<" ${message}
  git status
  echo
  git branch -a
  echo
  if [ "noLog" != "$2" ]; then
    git log
  fi
  echo ">>>>>>" ${message}
  echo
}

function printCounters {
  echo "-c-" ${!COUNTERS[@]}
  echo "-c-" ${COUNTERS[@]}
}

function git_push {
  branch=$1
  if [ "false" == "${AUTO_REMOTE}" ]; then
    git push --set-upstream origin $branch &>> ${LOG_FILE}
  else
    git config --add --bool push.autoSetupRemote ${AUTO_REMOTE} # only once
    git push &>> ${LOG_FILE}
  fi
}

function featureStart {
  feature=$1

  if [ ${COUNTERS[${feature}]+_} ]; then
    echo "***" "${feature} already started" >&2
    echo ${COUNTERS[@]}
    exit 1
  else
    COUNTERS+=([${feature}]=1)
  fi
  echo "---" "Starting ${feature}" | tee -a ${LOG_FILE}
  git flow feature start "${feature}" &>> ${LOG_FILE}
  printState "${feature} started" noLog
  if [ -z "" ]; then
    git flow feature publish "${feature}" &>> ${LOG_FILE}
  else
    git_push "feature/${feature}" &>> ${LOG_FILE}
  fi
  printState "${feature} published" noLog
  touch "${feature}.md"
  git add "${feature}.md" &>> ${LOG_FILE}
  git commit -am "init ${feature}"  &>> ${LOG_FILE}
  git push  &>> ${LOG_FILE}
}

function workOnFeature {
  feature=$1
  counter=${COUNTERS[${feature}]}
  COUNTERS[${feature}]=$(( $counter + 1 ))

  echo "---" "Working on ${feature} $counter" | tee -a ${LOG_FILE}
  git flow feature checkout ${feature} &>> ${LOG_FILE}
  echo "# ${feature} $counter" >> "${feature}.md"
  git commit -am "wip $counter ${feature}" &>> ${LOG_FILE}
  git push &>> ${LOG_FILE}
}

function featureFinish {
  feature=$1

  echo "---" "Finishing ${feature}" | tee -a ${LOG_FILE}

  git flow feature checkout ${feature} &>> ${LOG_FILE}
  pushOptions=
  if [ "true" == ${PRUNE_ALL} ]; then
    pushOptions="--all --prune"
  fi
  finishOptions=
  if [ "true" == "${REBASE_BEFORE_FINISH}" ]; then
    git rebase develop
    echo "---" "You can now check if everthing is fine" | tee -a ${LOG_FILE}
  elif [ "-r" == "${REBASE_BEFORE_FINISH}" ]; then
    finishOptions="-r"
  fi
  git flow feature finish ${finishOptions} ${feature} &>> ${LOG_FILE}
  git push ${pushOptions} &>> ${LOG_FILE}
}

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
printState "after start F1, F2" noLog

workOnFeature F1
git log --oneline --decorate --graph --all
workOnFeature F2
printState "after work F2, F1" noLog
git log --oneline --decorate --graph --all

featureFinish F2
printState "F2 finished" noLog
featureFinish F1
printState "F1 finished" noLog

git log --oneline --decorate --graph --all
