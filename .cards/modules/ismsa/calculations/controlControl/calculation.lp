transitionDenied(Card, "Not applicable", "Fill justification for not applying the control" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlJustification", _).

transitionDenied(Card, "Not applicable", "Set Status field to N/A" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlStatus","notApplicable").

transitionDenied(Card, "Complete plan", "Fix policy failures before completing plan" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    base_policyCheckFailure(Card, _, _, _).

editingContentDenied(Card, "You can't edit closed controls" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    field(Card, "workflowState", "Closed as not applicable").

transitionDenied(Card, "Not applicable", "Fill justification for not applying the control" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlJustification", _).

transitionDenied(Card, "Ready for verification", "Set Status field to Implemented" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlStatus","implemented").

transitionDenied(Card, "Ready for verification", "Fill in Justification field" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlJustification",_).

transitionDenied(Card, "Ready for verification", "Fill in 'Implementation summary' field" ):-
    base_projectCardType(Card, "ismsa/cardTypes/control"),
    not field(Card, "ismsa/fieldTypes/controlSummary",_).
