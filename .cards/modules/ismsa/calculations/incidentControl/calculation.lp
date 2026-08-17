transitionDenied(Card, "Complete analysis", "Fix policy failures before completing analysis"):-
    base_projectCardType(Card, "ismsa/cardTypes/incident"),
    base_policyCheckFailure(Card, _, _, _).

policyCheckFailure(Card, "ISMS", "Start date and time is a required field",
    "Start date and time has not been defined for this card. Set the Start date and time field.",
    "ismsa/fieldTypes/incidentStartDateTime") :-
    base_projectCardType(Card, "ismsa/cardTypes/incident"),
    not field(Card, "ismsa/fieldTypes/incidentStartDateTime", _).

policyCheckFailure(Card, "ISMS", "Incident severity is a required field",
    "Incident severity has not been defined for this card. Set the Incident severity field.",
    "ismsa/fieldTypes/incidentSeverity") :-
    base_projectCardType(Card, "ismsa/cardTypes/incident"),
    not field(Card, "ismsa/fieldTypes/incidentSeverity", _).

editingContentDenied(Card, "You can't edit a closed incident" ):-
    base_projectCardType(Card, "ismsa/cardTypes/incident"),
    field(Card, "workflowState", "Closed").