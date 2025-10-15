link(Asset, Risk, "ismsa/linkTypes/presentsRisk") :-
    ismsa_asset(Asset),
    field(Risk, "cardType", "ismsa/cardTypes/risk"),
    parent(Risk, Asset).

link(Control, Risk, "ismsa/linkTypes/mitigates") :-
    field(Risk, "cardType", "ismsa/cardTypes/risk"),
    field(Control, "cardType", "ismsa/cardTypes/control"),
    parent(Control, Risk).
