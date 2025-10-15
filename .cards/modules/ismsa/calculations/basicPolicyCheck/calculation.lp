policyCheckFailure(Card, "ISMS", "Owner is a required field", "Owner has not been defined for this card. Set the owner field.", "base/fieldTypes/owner") :-
    card(Card),
    field(Card, "cardType", CardType),
    customField(CardType, "base/fieldTypes/owner"),
    CardType != "base/cardTypes/controlledDocument",
    not field(Card, "workflowStateCategory", "initial"),
    not field(Card, "base/fieldTypes/owner", _).

policyCheckFailure(Card, "ISMS", "Classification is a required field", "Classification has not been defined for this card. Set the Classification field.", "base/fieldTypes/informationClassification") :-
    card(Card),
    field(Card, "cardType", CardType),
    customField(CardType, "base/fieldTypes/informationClassification"),
    not field(Card, "workflowStateCategory", "initial"),
    not field(Card, "base/fieldTypes/informationClassification", _).