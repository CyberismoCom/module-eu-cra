% If the owner of a card is calculated and overridable, 
% then make the owner of the parent card the automatic owner

fieldCalculated(Card, "base/fieldTypes/owner", Owner) :-
  parent(Card, Parent),
  field(Parent, "base/fieldTypes/owner", Owner),
  base_projectCardType(Card, CardType),
  calculatedField(CardType, "base/fieldTypes/owner"),
  overridableField(CardType, "base/fieldTypes/owner").

fieldCalculated(Card, "base/fieldTypes/approver", Owner) :-
  parent(Card, Parent),
  field(Parent, "base/fieldTypes/owner", Owner),
  base_projectCardType(Card, CardType),
  calculatedField(CardType, "base/fieldTypes/approver"),
  overridableField(CardType, "base/fieldTypes/approver").