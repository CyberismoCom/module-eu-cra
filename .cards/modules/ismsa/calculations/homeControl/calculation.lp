transitionDenied(Card, "Content ready", "Fix policy failures before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/moduleHome"),
    base_policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Fix policy failures in child cards before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/moduleHome"),
    parent(SubCard,Card),
    base_policyCheckFailure(SubCard, _, _, _).

ismsa_closestHome(Card, Home) :-
    field(Home, "cardType", "ismsa/cardTypes/moduleHome"),
    ancestor(Card, Home),
    not field(MiddleAncestor, "cardType", "ismsa/cardTypes/moduleHome") :
    ancestor(MiddleAncestor, Home),
    ancestor(Card, MiddleAncestor).

