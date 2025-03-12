base_greaterAdoptionStep(Card1, Card2) :-
    field(Card1, "base/fieldTypes/adoptionStep", "step1"),
    card(Card2),
    not field(Card2, "base/fieldTypes/adoptionStep", _).

base_greaterAdoptionStep(Card1, Card2) :-
    field(Card1, "base/fieldTypes/adoptionStep", "step2"),
    field(Card2, "base/fieldTypes/adoptionStep", "step1").

base_greaterAdoptionStep(Card1, Card2) :-
    field(Card1, "base/fieldTypes/adoptionStep", "step3"),
    field(Card2, "base/fieldTypes/adoptionStep", "step2").

base_greaterAdoptionStep(A, B) :-
    base_greaterAdoptionStep(A, C),
    base_greaterAdoptionStep(C, B).