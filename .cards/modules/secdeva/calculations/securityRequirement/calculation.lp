onTransitionExecuteTransition(Requirement, "Reopen", ReviewTask, "Reopen") :-
  base_projectCardType(Requirement, "secdeva/cardTypes/requirement"),
  parent(ReviewTask, Requirement),
  base_projectCardType(ReviewTask, "base/cardTypes/task").

link(Requirement, Asset, "secdeva/linkTypes/appliesTo") :-
  base_projectCardType(Requirement, "secdeva/cardTypes/requirement"),
  link(Asset, Risk, "ismsa/linkTypes/presentsRisk"),
  link(Requirement, Risk, "ismsa/linkTypes/mitigates").

link(Requirement, Risk, "ismsa/linkTypes/mitigates") :-
  base_projectCardType(Risk, "ismsa/cardTypes/risk"),
  base_projectCardType(Requirement, "secdeva/cardTypes/requirement"),
  parent(Requirement, Risk).