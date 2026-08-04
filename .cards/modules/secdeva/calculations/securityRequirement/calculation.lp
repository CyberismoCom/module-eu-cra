onTransitionExecuteTransition(Requirement, "Reopen", ReviewTask, "Reopen") :-
    field(Requirement, "cardType", "secdeva/cardTypes/requirement"),
    parent(ReviewTask, Requirement),
    field(ReviewTask, "cardType", "base/cardTypes/task").

link(Requirement, Asset, "secdeva/linkTypes/appliesTo") :-
    field(Requirement, "cardType", "secdeva/cardTypes/requirement"),
    link(Asset, Risk, "ismsa/linkTypes/presentsRisk"),
    link(Requirement, Risk, "ismsa/linkTypes/mitigates").