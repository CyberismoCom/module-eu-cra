% The default indicator based on workflow state

field(Card, "statusIndicator", "error") :-
  base_policyCheckFailure(Card, _, _, _),
  not base_disableDefaultStatusIndicator,
  not base_disableDefaultStatusIndicator(Card).

field(Card, "statusIndicator", StatusIndicator) :-
  not base_policyCheckFailure(Card, _, _, _),
  not field(Card, "progress", _),
  workflowState(Workflow, State, StatusIndicator),
  field(Card, "cardType", CardType),
  field(Card, "workflowState", State),
  field(CardType, "workflow", Workflow),
  not base_disableDefaultStatusIndicator,
  not base_disableDefaultStatusIndicator(Card).

% Indicator for card types that use the assessment field

base_disableDefaultStatusIndicator(Card) :-
  field(Card, "cardType", CardType),
  customField(CardType, "base/fieldTypes/assessment").

field(Card, "statusIndicator", "error") :-
  base_policyCheckFailure(Card, _, _, _),
  field(Card, "cardType", CardType),
  customField(CardType, "base/fieldTypes/assessment").

field(Card, "statusIndicator", "initial") :-
  field(Card, "cardType", CardType),
  customField(CardType, "base/fieldTypes/assessment"),
  not base_policyCheckFailure(Card, _, _, _),
  not field(Card, "progress", _),
  field(Card, "base/fieldTypes/assessment", "open").

field(Card, "statusIndicator", "active") :-
  field(Card, "cardType", CardType),
  customField(CardType, "base/fieldTypes/assessment"),
  not base_policyCheckFailure(Card, _, _, _),
  not field(Card, "progress", _),
  field(Card, "base/fieldTypes/assessment", "notOk").

field(Card, "statusIndicator", "closed") :-
  field(Card, "cardType", CardType),
  customField(CardType, "base/fieldTypes/assessment"),
  not base_policyCheckFailure(Card, _, _, _),
  not field(Card, "progress", _),
  field(Card, "base/fieldTypes/assessment", "ok").