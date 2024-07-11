# tutoFlow

## rebase avant finish ?

### sans rebase ni -r au finish, avec ou sans :wq ($ REBASE_BEFORE_FINISH=false)

- il y a un commit merge, donc conflit potentiel

*   4e89e1c (HEAD -> develop, origin/develop) Merge branch 'feature/F1' into develop
|\
| * 360c8a0 wip 2 F1
| * 0b3664a wip 1 F1
| * 3b6680d init F1
* |   566e87d Merge branch 'feature/F2' into develop
|\ \
| |/
|/|
| * 4860e03 wip 2 F2
| * 7747c82 wip 1 F2
| * 597da5f init F2
|/
* 7dc2175 (origin/main, main) Init

### avec -r au finish ($ REBASE_BEFORE_FINISH=-r) avec ou sans :wq

- L'historique de feature/F1 est réécrite pour récupérer feature/F2 mergée précédement sur
develop
- Ne permet pas de traiter les impacts
- Ne semble pas une bonne idée de toute façon

*   2cc6ddf (HEAD -> develop, origin/develop) Merge branch 'feature/F1' into develop
|\
| * 820f25b (feature/F1) wip 2 F1
| * 7d56432 wip 1 F1
| * ae7f746 init F1
|/
*   fdfbcfc Merge branch 'feature/F2' into develop
|\
| * 542c154 (origin/feature/F2) wip 2 F2
| * 27d7658 wip 1 F2
| * 0da7426 init F2
|/
| * d355cc5 (origin/feature/F1) wip 2 F1
| * 40b55fe wip 1 F1
| * 6aaf1db init F1
|/
* 22edfcb (origin/main, main) Init

### avec rebase depuis develop au finish, avec ou sans :wq ($ REBASE_BEFORE_FINISH=true)

- L'historique de feature/F1 est réécrite pour récupérer feature/F2 mergée précédement sur
develop
- Permet de traiter les impacts et de tester localement sur F1 tous les ajouts sur develop

*   fd63f3d (HEAD -> develop, origin/develop) Merge branch 'feature/F1' into develop
|\
| * b178e6a (feature/F1) wip 2 F1
| * 1da6238 wip 1 F1
| * 292ed19 init F1
|/
*   6eb2da6 Merge branch 'feature/F2' into develop
|\
| * d962a4e (origin/feature/F2) wip 2 F2
| * 3272e84 wip 1 F2
| * fec5653 init F2
|/
| * d0abbf5 (origin/feature/F1) wip 2 F1
| * 0120527 wip 1 F1
| * b73b37c init F1
|/
* 2d37e85 (origin/main, main) Init

## suppression de la branch distante

### sans -F au finish

* develop
  main
  remotes/origin/develop
  remotes/origin/feature/F1
  remotes/origin/feature/F2
  remotes/origin/main

>>>>>> F1 finished

*   f6a18bd (HEAD -> develop, origin/develop) Merge branch 'feature/F1' into develop
|\
| * 3a6dd75 (origin/feature/F1) wip 2 F1
| * 917b030 wip 1 F1
| * 59b3f39 init F1
* |   f74ff19 Merge branch 'feature/F2' into develop
|\ \
| |/
|/|
| * c348f5a (origin/feature/F2) wip 2 F2
| * d8a81a2 wip 1 F2
| * 71a98f5 init F2
|/
* 5617f24 (origin/main, main) Init

### avec -F au finish

* develop
  main
  remotes/origin/develop
  remotes/origin/main

*   4e89e1c (HEAD -> develop, origin/develop) Merge branch 'feature/F1' into develop
|\
| * 360c8a0 wip 2 F1
| * 0b3664a wip 1 F1
| * 3b6680d init F1
* |   566e87d Merge branch 'feature/F2' into develop
|\ \
| |/
|/|
| * 4860e03 wip 2 F2
| * 7747c82 wip 1 F2
| * 597da5f init F2
|/
* 7dc2175 (origin/main, main) Init
