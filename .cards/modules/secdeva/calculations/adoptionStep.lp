hiddenInTreeView(Card) :-
    card(Card),
    secdeva_closestProject(Card, Project),
    base_greaterAdoptionStep(Card, Project).

policyCheckFailure(
    Project,
    "Secure development",
    "Adoption step justification missing",
    "The target adoption step has been set to None, which indicates that secure development is not applicable. Enter a justification in the Adoption step justification field.") :-
        field(Project, "cardType", "secdeva/cardTypes/project"),
        not field(Project, "base/fieldTypes/adoptionStep", _),
        not field(Project, "secdeva/fieldTypes/adoptionStepJustification", _).

