% Disable ISMS essentials asset control for development project

ismsa_disableAssetControl(Card) :- field(Card, "cardType", "secdeva/cardTypes/project2").

ismsa_asset(Card, "Development project") :-
  field(Card, "cardType", "secdeva/cardTypes/project2").

secdeva_closestProject(Project, Project) :-
  field(Project, "cardType", "secdeva/cardTypes/project2").

secdeva_closestProject(Card, Project) :-
  field(Project, "cardType", "secdeva/cardTypes/project2"),
  not field(Card, "cardType", "secdeva/cardTypes/project2"),
  ancestor(Card, Project),
  not field(MiddleAncestor, "cardType", "secdeva/cardTypes/project2") :
  ancestor(MiddleAncestor, Project),
  ancestor(Card, MiddleAncestor).
    