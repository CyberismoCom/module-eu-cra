secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/process").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/dataStore").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/person").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/trustBoundary").

secdeva_threatModelComponent(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/external").

link(Asset, SecurityIssue, "ismsa/linkTypes/presentsRisk") :-
    parent(SecurityIssue, Asset),
    field(SecurityIssue, "cardType", "secdeva/cardTypes/securityIssue"),
    secdeva_threatModelComponent(Asset).
