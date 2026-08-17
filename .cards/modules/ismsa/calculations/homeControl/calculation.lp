transitionDenied(Card, "Content ready", "Fix policy failures before marking content ready" ):-
    base_projectCardType(Card, "ismsa/cardTypes/moduleHome"),
    base_policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Fix policy failures in child cards before marking content ready" ):-
    base_projectCardType(Card, "ismsa/cardTypes/moduleHome"),
    parent(SubCard,Card),
    base_policyCheckFailure(SubCard, _, _, _).

ismsa_closestHome(Card, Home) :-
    base_projectCardType(Home, "ismsa/cardTypes/moduleHome"),
    ancestor(Card, Home),
    not base_projectCardType(MiddleAncestor, "ismsa/cardTypes/moduleHome") :
    ancestor(MiddleAncestor, Home),
    ancestor(Card, MiddleAncestor).

