field(Card, "statusIndicator", "error") :-
    policyCheckFailure(Card, _, _, _),
    not base_disableDefaultStatusIndicator.

field(Card, "statusIndicator", StatusIndicator) :-
    not policyCheckFailure(Card, _, _, _),
    not field(Card, "progress", _),
    workflowState(Workflow, State, StatusIndicator),
    field(Card, "cardType", CardType),
    field(Card, "workflowState", State),
    field(CardType, "workflow", Workflow),
    not base_disableDefaultStatusIndicator.