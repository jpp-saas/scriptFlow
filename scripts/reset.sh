function initRepo {
  fake_dir=$(basename ${FAKE_REPO})

  if [[ ! "$FAKE_REPO" =~ ^jpp.* ]] || [[ ! "$fake_dir" =~ ^tuto.* ]]; then # AT YOUR OWN RISKS
    echo "DANGER $FAKE_REPO" >&2
    exit 1
  fi

  if [ ! -d ${fake_dir} ]; then
    echo "---" "clone" | tee ${LOG_FILE}
    git clone git@github.com:${FAKE_REPO}.git 2>> ${LOG_FILE}
    cd ${fake_dir}
  else
    echo "---" "reset" | tee ${LOG_FILE}
    cd ${fake_dir}
    git fetch -apm 2>> ${LOG_FILE}
    rm -rf .git *
    git init >> ${LOG_FILE}
    echo "# ${fake_dir}" > README.md
    for i in $(seq 9); do
      echo "## $i" >> README.md
    done
    git add . 2>> ${LOG_FILE}
    git commit -m 'Init' >> ${LOG_FILE}
    git remote add origin git@github.com:${FAKE_REPO}.git 2>> ${LOG_FILE}
    git push --force --set-upstream origin main &>> ${LOG_FILE}
    git fetch -apm 2>> ${LOG_FILE}
    for b in $(git branch -al | grep -v main); do
      bn=$(echo $b | sed -e 's#remotes/origin/##g')
      git push origin -d $bn 2>> ${LOG_FILE}
    done
  fi
}
