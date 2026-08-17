onTransitionSetField(Card, "Create", Card, "title", @concatenate(@today(), " Untitled meeting notes")) :-
    base_projectCardType(Card, "base/cardTypes/page"),
    field(Card, "title", "Untitled meeting notes").
