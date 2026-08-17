% base_greaterAdoptionStep(Card1, Card2) means that Card1 is on a higher adoption step than Card2
% These rules are a bit complex for performance reasons, so that we do not generate too much results
% we generate base_greaterAdoptionStep only for project cards that have an ancestor relationship

base_greaterAdoptionStep(Card1, Card2) :-
    field(Card1, "base/fieldTypes/adoptionStep", _),
    not field(Card2, "base/fieldTypes/adoptionStep", _),
    base_projectCardType(Card1, CardType1),
    base_projectCardType(Card2, CardType2),
    customField(CardType1, "base/fieldTypes/adoptionStep"),
    customField(CardType2, "base/fieldTypes/adoptionStep"),
    ancestor(Card1, Card2).

base_greaterAdoptionStep(Card1, Card2) :-
    field(Card1, "base/fieldTypes/adoptionStep", _),
    not field(Card2, "base/fieldTypes/adoptionStep", _),
    base_projectCardType(Card1, CardType1),
    base_projectCardType(Card2, CardType2),
    customField(CardType1, "base/fieldTypes/adoptionStep"),
    customField(CardType2, "base/fieldTypes/adoptionStep"),
    ancestor(Card2, Card1).

base_greaterAdoptionStep(Card1, Card2) :-
    projectCard(Card1),
    projectCard(Card2),
    field(Card1, "base/fieldTypes/adoptionStep", "step2"),
    field(Card2, "base/fieldTypes/adoptionStep", "step1"),
    ancestor(Card1, Card2).

base_greaterAdoptionStep(Card1, Card2) :-
    projectCard(Card1),
    projectCard(Card2),
    field(Card1, "base/fieldTypes/adoptionStep", "step2"),
    field(Card2, "base/fieldTypes/adoptionStep", "step1"),
    ancestor(Card2, Card1).

base_greaterAdoptionStep(Card1, Card2) :-
    projectCard(Card1),
    projectCard(Card2),
    field(Card1, "base/fieldTypes/adoptionStep", "step3"),
    field(Card2, "base/fieldTypes/adoptionStep", "step2"),
    ancestor(Card1, Card2).

base_greaterAdoptionStep(Card1, Card2) :-
    projectCard(Card1),
    projectCard(Card2),
    field(Card1, "base/fieldTypes/adoptionStep", "step3"),
    field(Card2, "base/fieldTypes/adoptionStep", "step2"),
    ancestor(Card2, Card1).

base_greaterAdoptionStep(Card1, Card2) :-
    projectCard(Card1),
    projectCard(Card2),
    field(Card1, "base/fieldTypes/adoptionStep", "step3"),
    field(Card2, "base/fieldTypes/adoptionStep", "step1"),
    ancestor(Card1, Card2).

base_greaterAdoptionStep(Card1, Card2) :-
    projectCard(Card1),
    projectCard(Card2),
    field(Card1, "base/fieldTypes/adoptionStep", "step3"),
    field(Card2, "base/fieldTypes/adoptionStep", "step1"),
    ancestor(Card2, Card1).
