link(Asset, Risk, "ismsa/linkTypes/presentsRisk") :-
    ismsa_asset(Asset),
    base_projectCardType(Risk, "ismsa/cardTypes/risk"),
    parent(Risk, Asset).

link(Control, Risk, "ismsa/linkTypes/mitigates") :-
    base_projectCardType(Risk, "ismsa/cardTypes/risk"),
    base_projectCardType(Control, "ismsa/cardTypes/control"),
    parent(Control, Risk).
