% Disable ISMS essentials asset control for development project

ismsa_disableAssetControl(Card) :- base_projectCardType(Card, "secdeva/cardTypes/project2").

ismsa_asset(Card, "Development project") :-
  base_projectCardType(Card, "secdeva/cardTypes/project2").

secdeva_closestProject(Project, Project) :-
  base_projectCardType(Project, "secdeva/cardTypes/project2").

secdeva_closestProject(Card, Project) :-
  base_projectCardType(Project, "secdeva/cardTypes/project2"),
  not base_projectCardType(Card, "secdeva/cardTypes/project2"),
  ancestor(Card, Project),
  not base_projectCardType(MiddleAncestor, "secdeva/cardTypes/project2") :
  ancestor(MiddleAncestor, Project),
  ancestor(Card, MiddleAncestor).
    