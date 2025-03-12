transitionDenied(Card, "Content ready", "Fix policy failures for this register before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    policyCheckFailure(Card, _, _, _).

transitionDenied(Card, "Content ready", "Register should contain at least one item before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    Total = #count{
        card(SubCard):
        parent(SubCard,Card),
        not hiddenInTreeView(SubCard)
        },
    Total = 0.

transitionDenied(Card, "Content ready", "Fix policy failures in child cards before marking content ready" ):-
    field(Card, "cardType", "ismsa/cardTypes/register"),
    parent(SubCard,Card),
    policyCheckFailure(SubCard, _, _, _).