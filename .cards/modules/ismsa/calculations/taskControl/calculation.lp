policyCheckFailure(Card, "ISMS", "Due date is a required field", "Due date has not been defined for this target. Set this field..") :-
    base_projectCardType(Card, "ismsa/cardTypes/securityTarget"),
    not field(Card, "base/fieldTypes/dueDate", _).

transitionDenied(Card, "Approve target", "Fix policy failures before approving target" ):-
    base_projectCardType(Card, "ismsa/cardTypes/securityTarget"),
    base_policyCheckFailure(Card, _, _, _).