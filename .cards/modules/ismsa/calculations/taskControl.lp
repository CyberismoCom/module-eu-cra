policyCheckFailure(Card, "ISMS", "Due date is a required field", "Due date has not been defined for this target. Set this field..") :-
    field(Card, "cardType", "ismsa/cardTypes/securityTarget"),
    not field(Card, "base/fieldTypes/dueDate", _).

transitionDenied(Card, "Approve target", "Fix policy failures before approving target" ):-
    field(Card, "cardType", "ismsa/cardTypes/securityTarget"),
    policyCheckFailure(Card, _, _, _).